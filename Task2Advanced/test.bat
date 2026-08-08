@echo off
chcp 65001 >nul
echo === Автоматическая настройка MinIO ===

REM Удаляем старый контейнер
docker rm -f minio 2>nul

echo Очистка предыдущих ресурсов...
docker rm -f $(docker ps -a -q --filter name="dev-node-") 2>nul
docker rm -f $(docker ps -a -q --filter name="stage-node-") 2>nul
docker rm -f $(docker ps -a -q --filter name="prod-node-") 2>nul
docker network rm future20-dev-net 2>nul
docker network rm future20-stage-net 2>nul
docker network rm future20-prod-net 2>nul

REM Запускаем MinIO
echo Запуск MinIO...
docker run -d --name minio ^
    -p 9000:9000 -p 9001:9001 ^
    -e MINIO_ROOT_USER=admin ^
    -e MINIO_ROOT_PASSWORD=admin123 ^
    quay.io/minio/minio server /data --console-address ":9001"

echo Ожидание запуска...
timeout /t 5 /nobreak >nul

REM Создаём bucket через mc
echo Создание bucket через MinIO Client...
docker run --rm --entrypoint sh minio/mc -c "mc alias set myminio http://host.docker.internal:9000 admin admin123 && mc mb myminio/terraform-state --ignore-existing"

if errorlevel 1 (
    echo Ошибка создания bucket!
    pause
    exit /b 1
)

echo Bucket создан успешно!
echo.

REM Переходим в директорию
echo Переход в envs\dev...
cd "envs\dev"

REM Устанавливаем переменные окружения для AWS SDK
set AWS_ACCESS_KEY_ID=admin
set AWS_SECRET_ACCESS_KEY=admin123
set AWS_DEFAULT_REGION=eu-central-1


echo.
echo Запуск terraform init...
terraform init ^
    -backend-config="endpoint=http://localhost:9000" ^
    -backend-config="bucket=terraform-state"

if errorlevel 1 (
    echo.
    echo Ошибка terraform init!
    pause
    exit /b 1
)

echo.
echo Запуск terraform plan...
terraform plan -var-file=dev.tfvars

echo.
echo Применить план? (Y/N)
set /p apply_confirm=
if /i "%apply_confirm%"=="Y" (
    echo Применение...
    terraform apply -auto-approve -var-file=dev.tfvars ^
        -var="minio_endpoint=http://localhost:9000" ^
        -var="minio_bucket=terraform-state" ^
        -var="minio_access_key=admin" ^
        -var="minio_secret_key=admin123" ^
        -var="ssh_password=testpass"
    if errorlevel 1 (
        echo Ошибка применения!
        pause
        exit /b 1
    )
) else (
    echo Пропуск применения.
)

cd ..
cd ..

echo.
echo === Готово! ===
echo MinIO Console: http://localhost:9001
pause
@echo off
REM ============================================
REM   SCRIPT AUTOMATIZADO DE BACKUP MYSQL
REM   Proyecto: Jewelry Workshop - Taller FESC
REM   Desarrollado en Laragon (MySQL 8.4.3)
REM ============================================

REM === FORMATO DE FECHA UNIVERSAL ===
REM Captura la fecha del sistema (dd/mm/yyyy) y la reorganiza a formato yyyy-mm-dd
for /f "tokens=2-4 delims=/ " %%a in ('date /t') do (
  set FECHA=%%c-%%a-%%b
)

REM === CONFIGURACIÓN ===
REM Define las variables principales:
REM - BK_DIR: Carpeta donde se almacenará el backup
REM - MYSQLDUMP: Ruta del ejecutable mysqldump
REM - DB: Nombre de la base de datos a respaldar
REM - FILE: Ruta y nombre final del archivo generado
set "BK_DIR=C:\backups"
set "MYSQLDUMP=C:\laragon\bin\mysql\mysql-8.4.3-winx64\bin\mysqldump.exe"
set "DB=techstore"
set "FILE=%BK_DIR%\%DB%_%FECHA%.sql"

REM === CREAR CARPETA SI NO EXISTE ===
REM Verifica si la carpeta C:\backups existe; si no, la crea automáticamente.
if not exist "%BK_DIR%" mkdir "%BK_DIR%"

REM === MENSAJE INICIAL DE ESTADO ===
REM Muestra en consola la información básica del respaldo.
echo ==============================
echo INICIANDO BACKUP DE %DB%
echo Fecha: %FECHA%
echo Carpeta destino: %BK_DIR%
echo ==============================

REM === EJECUTAR BACKUP ===
REM Llama al ejecutable mysqldump con los parámetros de respaldo.
REM --single-transaction evita bloqueos mientras se copia la base de datos.
REM --routines, --events y --triggers aseguran que se respalden también procedimientos, eventos y disparadores.
call "%MYSQLDUMP%" -u root %DB% --single-transaction --routines --events --triggers > "%FILE%"

REM === VERIFICACIÓN DEL RESULTADO ===
REM Comprueba si el archivo SQL fue creado correctamente.
if exist "%FILE%" (
    echo Backup completado correctamente: %FILE%
) else (
    echo Error: no se creó el archivo de backup.
)

REM === FINALIZAR ===
REM Pausa la consola para permitir al usuario ver el resultado antes de cerrar.
pause
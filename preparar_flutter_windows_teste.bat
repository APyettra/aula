@echo off
setlocal EnableExtensions EnableDelayedExpansion
title Preparacao do Laboratorio Flutter - Windows

echo ============================================================
echo   PREPARACAO DO LABORATORIO FLUTTER - WINDOWS
echo   Instalacao por usuario - sem necessidade de administrador
echo ============================================================
echo.

set "LOG=%USERPROFILE%\preparar_flutter_windows_log.txt"
echo Inicio: %DATE% %TIME% > "%LOG%"

echo [1/9] Verificando Windows...
ver >nul 2>&1
if errorlevel 1 goto :fim
echo OK - Windows detectado.
echo.

echo [2/9] Verificando pasta do usuario...
set "TESTFILE=%USERPROFILE%\flutter_lab_test_%RANDOM%.tmp"
echo teste > "%TESTFILE%" 2>nul
if not exist "%TESTFILE%" (
  echo ERRO: nao foi possivel gravar na pasta do usuario.
  goto :fim
)
del "%TESTFILE%" >nul 2>&1
echo OK - pasta do usuario permite escrita.
echo.

echo [3/9] Verificando Flutter e Dart...
where flutter >nul 2>&1
if errorlevel 1 (
  echo [!!] Flutter nao encontrado no PATH.
  set "FLUTTER_OK=0"
) else (
  echo [OK] Flutter encontrado:
  flutter --version
  set "FLUTTER_OK=1"
)

where dart >nul 2>&1
if errorlevel 1 (
  echo [!!] Dart nao encontrado no PATH.
  set "DART_OK=0"
) else (
  echo [OK] Dart encontrado:
  dart --version
  set "DART_OK=1"
)
echo.

echo [4/9] Verificando Git...
where git >nul 2>&1
if errorlevel 1 (
  echo [!!] Git nao encontrado.
  set "GIT_OK=0"
) else (
  git --version
  set "GIT_OK=1"
)
echo.

echo [5/9] Verificando Google Chrome...
set "CHROME_FOUND=0"
if exist "%ProgramFiles%\Google\Chrome\Application\chrome.exe" set "CHROME_FOUND=1"
if exist "%ProgramFiles(x86)%\Google\Chrome\Application\chrome.exe" set "CHROME_FOUND=1"
if exist "%LocalAppData%\Google\Chrome\Application\chrome.exe" set "CHROME_FOUND=1"
if "%CHROME_FOUND%"=="1" (echo [OK] Google Chrome encontrado.) else (echo [!!] Google Chrome nao encontrado.)
echo.

echo [6/9] Verificando VS Code...
where code >nul 2>&1
if errorlevel 1 (
  if exist "%LocalAppData%\Programs\Microsoft VS Code\bin\code.cmd" (
    echo [OK] VS Code encontrado na instalacao por usuario.
    set "PATH=%PATH%;%LocalAppData%\Programs\Microsoft VS Code\bin"
  ) else (
    echo [!!] VS Code nao encontrado no PATH.
  )
) else (
  echo [OK] VS Code encontrado.
)
echo.

echo [7/9] Configurando Dart Pub Cache no PATH do usuario...
if "%LOCALAPPDATA%"=="" (
  echo [!!] LOCALAPPDATA nao esta definido.
) else (
  set "PUB_CACHE_BIN=%LOCALAPPDATA%\Pub\Cache\bin"
  if not exist "%PUB_CACHE_BIN%" mkdir "%PUB_CACHE_BIN%" >nul 2>&1
  powershell -NoProfile -ExecutionPolicy Bypass -Command "$p=[Environment]::GetEnvironmentVariable('Path','User'); if($null -eq $p){$p=''}; if($p -notlike '*%PUB_CACHE_BIN%*'){[Environment]::SetEnvironmentVariable('Path',($p.TrimEnd(';')+';%PUB_CACHE_BIN%'),'User')}"
  set "PATH=%PATH%;%PUB_CACHE_BIN%"
  echo [OK] PATH do usuario configurado para Dart Pub Cache.
)
echo.

echo [8/9] Instalando/atualizando FlutterFire CLI...
if "%DART_OK%"=="1" (
  dart pub global activate flutterfire_cli
  if errorlevel 1 (
    echo [!!] Falha no FlutterFire CLI.
    set "FLUTTERFIRE_OK=0"
  ) else (
    echo [OK] FlutterFire CLI instalado/atualizado.
    set "FLUTTERFIRE_OK=1"
  )
) else (
  echo [--] FlutterFire CLI pulado porque Dart nao foi encontrado.
  set "FLUTTERFIRE_OK=0"
)
echo.

echo [9/9] Verificando Node.js, npm e Firebase CLI...
where node >nul 2>&1
if errorlevel 1 (echo [--] Node.js nao encontrado.) else (node --version)

where npm >nul 2>&1
if errorlevel 1 (echo [--] npm nao encontrado.) else (npm --version)

where firebase >nul 2>&1
if errorlevel 1 (
  echo [--] Firebase CLI ainda nao encontrado.
  set "FIREBASE_OK=0"
) else (
  echo [OK] Firebase CLI:
  firebase --version
  set "FIREBASE_OK=1"
)
echo.

echo ============================================================
echo   RELATORIO FINAL
echo ============================================================
if "%FLUTTER_OK%"=="1" echo [OK] Flutter
if "%DART_OK%"=="1" echo [OK] Dart
if "%GIT_OK%"=="1" echo [OK] Git
if "%CHROME_FOUND%"=="1" echo [OK] Google Chrome
if "%FLUTTERFIRE_OK%"=="1" echo [OK] FlutterFire CLI
if "%FIREBASE_OK%"=="1" echo [OK] Firebase CLI

echo.
echo Este script nao solicita privilegios de administrador.
echo Flutter, Git, Chrome e VS Code devem ser previamente instalados.
echo O FlutterFire CLI e instalado no perfil do usuario.
echo.
echo Depois de abrir um NOVO CMD, teste:
echo     flutterfire --version
echo.
echo Para configurar um projeto Firebase:
echo     flutterfire configure
echo.
echo Log: %LOG%
echo Fim: %DATE% %TIME% >> "%LOG%"
pause
endlocal

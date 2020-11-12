@echo off

if not "%1" == "x64" if not "%1" == "x86" goto:usage
if "%2" == "" goto:usage

set PROJECT_NAME=TON SDK
set ROOT_DIR=%cd%
set INSTALL_DIR=%ROOT_DIR%\install
set TON_SDK_VERSION=%2
set TON_SDK_TARGET=x86_64-pc-windows-msvc
if "%1" == "x86" set TON_SDK_TARGET=i686-pc-windows-msvc

echo Building TON SDK
if not exist .\build mkdir .\build
cd .\build

cmake .. -DTON_SDK_VERSION=%TON_SDK_VERSION% -DTON_SDK_TARGET="%TON_SDK_TARGET%" -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release
if %errorlevel% neq 0 exit /b %errorlevel%

nmake
if %errorlevel% neq 0 exit /b %errorlevel%

nmake install
if %errorlevel% neq 0 exit /b %errorlevel%

cd %ROOT_DIR%

echo %PROJECT_NAME% build finished.
goto:eof

:usage
echo usage: build.bat platform version
echo allowed values for platform are: x64, x86
echo example: build.bat x64 1.1.0
exit 1
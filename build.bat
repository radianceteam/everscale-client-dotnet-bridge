@echo off

set PROJECT_NAME=TON CLIENT .NET BRIDGE
set ROOT_DIR=%cd%
set INSTALL_DIR=%ROOT_DIR%\install
set TON_SDK_TARGET=x86_64-pc-windows-msvc

if "%1" == "x86" set TON_SDK_TARGET=i686-pc-windows-msvc

echo Building third party libraries.
if not exist .\vendor\build mkdir .\vendor\build
cd .\vendor\build

cmake .. -DTON_SDK_TARGET="%TON_SDK_TARGET%" -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release
if %errorlevel% neq 0 exit /b %errorlevel%

nmake
if %errorlevel% neq 0 exit /b %errorlevel%

cd %ROOT_DIR%

echo Building %PROJECT_NAME%.
if not exist .\cmake-build-release mkdir .\cmake-build-release
cd .\cmake-build-release

cmake .. -DTON_SDK_TARGET="%TON_SDK_TARGET%" -DCMAKE_INSTALL_PREFIX="%INSTALL_DIR%" -G "NMake Makefiles" -DCMAKE_BUILD_TYPE=Release
if %errorlevel% neq 0 exit /b %errorlevel%

nmake
if %errorlevel% neq 0 exit /b %errorlevel%

echo Running tests.
ctest --output-on-failure --timeout 100
if %errorlevel% neq 0 exit /b %errorlevel%

echo Installing %PROJECT_NAME% into %INSTALL_DIR%.
nmake install
if %errorlevel% neq 0 exit /b %errorlevel%

cd "%ROOT_DIR%"

echo %PROJECT_NAME% build finished.

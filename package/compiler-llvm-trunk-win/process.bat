@echo off

rem
rem Installation script for CK packages.
rem
rem See CK LICENSE.txt for licensing details.
rem See CK Copyright.txt for copyright details.
rem
rem Developer(s): Grigori Fursin, 2015
rem

rem PACKAGE_DIR
rem INSTALL_DIR

echo.
echo Getting LLVM trunk from SVN
svn co http://llvm.org/svn/llvm-project/llvm/trunk %INSTALL_DIR%\trunk\llvm

if %errorlevel% neq 0 (
 echo.
 echo Failed installing package!
 goto err
)

echo Getting CLANG trunk from SVN ...
svn co http://llvm.org/svn/llvm-project/cfe/trunk  %INSTALL_DIR%\trunk\llvm\tools\clang

if %errorlevel% neq 0 (
 echo.
 echo Failed installing package!
 goto err
)

echo Getting Polly trunk from SVN ...
svn co http://llvm.org/svn/llvm-project/polly/trunk  %INSTALL_DIR%\trunk\llvm\tools\polly

if %errorlevel% neq 0 (
 echo.
 echo Failed installing package!
 goto err
)

echo.
echo Configuring using Visual Studio ...

set INSTALL_OBJ_DIR=%INSTALL_DIR%\obj
mkdir %INSTALL_OBJ_DIR%

cd /D %INSTALL_OBJ_DIR%

rem cmake.exe -G "Visual Studio 12 2013" -DCMAKE_INSTALL_PREFIX=%INSTALL_DIR% -DLLVM_TARGETS_TO_BUILD=X86;ARM;NVPTX %INSTALL_DIR%\trunk\llvm
cmake.exe -DCMAKE_INSTALL_PREFIX=%INSTALL_DIR% -DLLVM_TARGETS_TO_BUILD=X86;X86;ARM;NVPTX %INSTALL_DIR%\trunk\llvm

if %errorlevel% neq 0 (
 echo.
 echo Failed installing package!
 goto err
)

echo.
echo Building using Visual Studio ...

msbuild.exe llvm.sln /m:1 /p:Configuration=Release /p:Platform=Win32
rem if %errorlevel% neq 0 (
rem  echo.
rem  echo Failed installing package!
rem  goto err
rem )

exit /b 0

:err
exit /b 1

@echo off
REM ============================================================================
REM szideNG - 专用芯片嵌入式软件IDE 打包脚本
REM 版本: 1.0.0
REM 日期: 2026-01-21
REM ============================================================================

setlocal enabledelayedexpansion

echo ========================================
echo   szideNG 打包脚本
echo ========================================
echo.

REM 设置变量
set "PACKAGE_NAME=szideNG"
set "VERSION=1.0.0"
set "BUILD_DATE=%date:~0,10%"
set "OUTPUT_DIR=dist"
set "PACKAGE_DIR=%OUTPUT_DIR%\%PACKAGE_NAME%-v%VERSION%"

REM 颜色定义（在Windows 10+中使用ANSI转义码）
set "COLOR_GREEN=[92m"
set "COLOR_YELLOW=[93m"
set "COLOR_RED=[91m"
set "COLOR_RESET=[0m"

echo [1/8] 检查依赖...
echo.

REM 检查是否存在必要的文件
if not exist "vscodium" (
    echo %COLOR_RED%错误: 未找到 vscodium 目录！%COLOR_RESET%
    echo 请先下载并解压 VSCodium 到 vscodium 目录
    pause
    exit /b 1
)

if not exist "toolchains" (
    echo %COLOR_YELLOW%警告: 未找到 toolchains 目录%COLOR_RESET%
    echo 将创建空的工具链目录
    mkdir toolchains
)

echo [2/8] 清理旧的构建文件...
if exist "%OUTPUT_DIR%" (
    rd /s /q "%OUTPUT_DIR%"
)
mkdir "%OUTPUT_DIR%"
mkdir "%PACKAGE_DIR%"
echo %COLOR_GREEN%完成%COLOR_RESET%
echo.

echo [3/8] 复制 VSCodium 核心文件...
xcopy /E /I /Y /Q vscodium "%PACKAGE_DIR%\vscodium" >nul 2>&1
if errorlevel 1 (
    echo %COLOR_RED%错误: 复制 VSCodium 失败%COLOR_RESET%
    pause
    exit /b 1
)
echo %COLOR_GREEN%完成%COLOR_RESET%
echo.

echo [4/8] 复制工具链...
xcopy /E /I /Y /Q toolchains "%PACKAGE_DIR%\toolchains" >nul 2>&1
echo %COLOR_GREEN%完成%COLOR_RESET%
echo.

echo [5/8] 复制配置文件...
xcopy /E /I /Y /Q config "%PACKAGE_DIR%\config" >nul 2>&1
xcopy /E /I /Y /Q templates "%PACKAGE_DIR%\templates" >nul 2>&1
echo %COLOR_GREEN%完成%COLOR_RESET%
echo.

echo [6/8] 安装扩展...
mkdir "%PACKAGE_DIR%\extensions"
xcopy /E /I /Y /Q extensions "%PACKAGE_DIR%\extensions" >nul 2>&1
echo %COLOR_GREEN%完成%COLOR_RESET%
echo.

echo [7/8] 复制脚本和文档...
copy /Y scripts\*.bat "%PACKAGE_DIR%\" >nul 2>&1
xcopy /E /I /Y /Q docs "%PACKAGE_DIR%\docs" >nul 2>&1
copy /Y README.md "%PACKAGE_DIR%\" >nul 2>&1
copy /Y LICENSE "%PACKAGE_DIR%\" >nul 2>&1 2>nul
echo %COLOR_GREEN%完成%COLOR_RESET%
echo.

echo [8/8] 创建版本信息文件...
(
    echo szideNG - 专用芯片嵌入式软件IDE
    echo 版本: %VERSION%
    echo 构建日期: %BUILD_DATE%
    echo.
    echo 支持芯片:
    echo - STM32F429BIT6 ^(ARM Cortex-M4F^)
    echo - ADSP-SC834/SC834W ^(SHARC+ DSP^)
    echo.
    echo 工具链:
    echo - ARM GCC for STM32
    echo - ADI CCES for ADSP
    echo.
    echo 版权所有 ^(C^) 2026 您的企业名称
) > "%PACKAGE_DIR%\VERSION.txt"
echo %COLOR_GREEN%完成%COLOR_RESET%
echo.

echo [可选] 创建压缩包...
set "ZIP_FILE=%OUTPUT_DIR%\%PACKAGE_NAME%-v%VERSION%.zip"

REM 检查是否安装了 7-Zip
where 7z >nul 2>&1
if %errorlevel% equ 0 (
    echo 使用 7-Zip 压缩...
    7z a -tzip "%ZIP_FILE%" "%PACKAGE_DIR%\*" -mx9 >nul
    if errorlevel 1 (
        echo %COLOR_YELLOW%警告: 压缩失败%COLOR_RESET%
    ) else (
        echo %COLOR_GREEN%压缩包创建成功: %ZIP_FILE%%COLOR_RESET%
    )
) else (
    echo %COLOR_YELLOW%未找到 7-Zip，跳过压缩步骤%COLOR_RESET%
    echo 可以手动压缩 %PACKAGE_DIR% 目录
)
echo.

echo ========================================
echo   打包完成！
echo ========================================
echo.
echo 输出目录: %PACKAGE_DIR%
echo.
echo 文件大小统计:
dir "%PACKAGE_DIR%" | find "个文件"
echo.
echo 下一步:
echo 1. 测试安装包: cd %PACKAGE_DIR% ^&^& setup.bat
echo 2. 运行验证: validate.bat
echo 3. 分发给用户
echo.

pause

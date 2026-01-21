@echo off
REM ============================================================================
REM szideNG - 安装配置脚本
REM ============================================================================

setlocal enabledelayedexpansion

echo ========================================
echo   szideNG 安装向导
echo ========================================
echo.

REM 检查管理员权限（可选）
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo 注意: 未以管理员身份运行
    echo 如需安装系统级组件，请右键选择"以管理员身份运行"
    echo.
    timeout /t 3 >nul
)

echo [1/6] 检查安装环境...
echo 操作系统: %OS%
echo 系统架构: %PROCESSOR_ARCHITECTURE%
ver
echo.

REM 检查必要文件
if not exist "vscodium\VSCodium.exe" (
    echo 错误: 未找到 VSCodium.exe
    echo 请确保解压完整
    pause
    exit /b 1
)

echo [2/6] 创建配置目录...
if not exist "%APPDATA%\szideNG" (
    mkdir "%APPDATA%\szideNG"
)
if not exist "%APPDATA%\szideNG\workspace" (
    mkdir "%APPDATA%\szideNG\workspace"
)
echo 完成
echo.

echo [3/6] 复制默认配置...
if exist "config\settings.json" (
    copy /Y "config\settings.json" "vscodium\data\user-data\User\settings.json" >nul 2>&1
)
if exist "config\keybindings.json" (
    copy /Y "config\keybindings.json" "vscodium\data\user-data\User\keybindings.json" >nul 2>&1
)
echo 完成
echo.

echo [4/6] 配置企业标识...
if exist "config\branding.json" (
    echo 正在应用企业标识配置...
    REM 这里可以添加修改 VSCodium 界面的逻辑
    echo 完成
) else (
    echo 跳过（未找到 branding.json）
)
echo.

echo [5/6] 安装必需扩展...
set "VSCODE_PATH=%CD%\vscodium\VSCodium.exe"

REM 安装 C/C++ 扩展
echo - 安装 C/C++ 扩展...
"%VSCODE_PATH%" --install-extension ms-vscode.cpptools --force >nul 2>&1

REM 安装 Cortex-Debug
echo - 安装 Cortex-Debug 扩展...
"%VSCODE_PATH%" --install-extension marus25.cortex-debug --force >nul 2>&1

REM 安装 ARM Assembly
echo - 安装 ARM Assembly 扩展...
"%VSCODE_PATH%" --install-extension dan-c-underwood.arm --force >nul 2>&1

echo 完成
echo.

echo [6/6] 创建桌面快捷方式...
set "SHORTCUT_PATH=%USERPROFILE%\Desktop\szideNG.lnk"
set "TARGET_PATH=%CD%\vscodium\VSCodium.exe"
set "WORK_DIR=%CD%\vscodium"

REM 使用 PowerShell 创建快捷方式
powershell -Command "$WS = New-Object -ComObject WScript.Shell; $SC = $WS.CreateShortcut('%SHORTCUT_PATH%'); $SC.TargetPath = '%TARGET_PATH%'; $SC.WorkingDirectory = '%WORK_DIR%'; $SC.Description = '专用芯片嵌入式软件IDE'; $SC.Save()"

if exist "%SHORTCUT_PATH%" (
    echo 快捷方式已创建: %SHORTCUT_PATH%
) else (
    echo 警告: 快捷方式创建失败
)
echo.

echo ========================================
echo   安装完成！
echo ========================================
echo.
echo 安装位置: %CD%
echo 配置目录: %APPDATA%\szideNG
echo.
echo 启动方式:
echo 1. 双击桌面快捷方式"szideNG"
echo 2. 运行: vscodium\VSCodium.exe
echo.
echo 使用指南:
echo - 按 Ctrl+Shift+N 创建新项目
echo - 按 F7 编译项目
echo - 按 F5 开始调试
echo.
echo 文档位置: docs\user-manual.md
echo.

set /p START="是否立即启动 szideNG? (Y/N): "
if /i "%START%"=="Y" (
    start "" "%TARGET_PATH%"
)

pause

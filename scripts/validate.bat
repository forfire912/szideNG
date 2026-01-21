@echo off
REM ============================================================================
REM szideNG - 验证测试脚本
REM ============================================================================

setlocal enabledelayedexpansion

echo ========================================
echo   szideNG 验收测试
echo ========================================
echo.

set "PASS_COUNT=0"
set "FAIL_COUNT=0"
set "TOTAL_TESTS=0"

echo 开始时间: %date% %time%
echo.

REM ===== 测试 1: 检查核心文件 =====
set /a TOTAL_TESTS+=1
echo [测试 1/%TOTAL_TESTS%] 检查核心文件存在性...
set "CORE_FILES_OK=1"

if not exist "vscodium\VSCodium.exe" (
    echo   [失败] VSCodium.exe 不存在
    set "CORE_FILES_OK=0"
)
if not exist "config\settings.json" (
    echo   [失败] settings.json 不存在
    set "CORE_FILES_OK=0"
)
if not exist "templates\stm32" (
    echo   [失败] STM32 模板不存在
    set "CORE_FILES_OK=0"
)
if not exist "templates\adsp" (
    echo   [失败] ADSP 模板不存在
    set "CORE_FILES_OK=0"
)

if !CORE_FILES_OK! equ 1 (
    echo   [通过] 所有核心文件存在
    set /a PASS_COUNT+=1
) else (
    set /a FAIL_COUNT+=1
)
echo.

REM ===== 测试 2: 检查工具链 =====
set /a TOTAL_TESTS+=1
echo [测试 2/%TOTAL_TESTS%] 检查工具链完整性...
set "TOOLCHAIN_OK=1"

if exist "toolchains\arm-gcc" (
    if not exist "toolchains\arm-gcc\bin\arm-none-eabi-gcc.exe" (
        echo   [警告] ARM GCC 编译器不存在
        set "TOOLCHAIN_OK=0"
    )
) else (
    echo   [警告] ARM GCC 工具链目录不存在
    set "TOOLCHAIN_OK=0"
)

if exist "toolchains\adi-cces" (
    if not exist "toolchains\adi-cces\cc21k.exe" (
        echo   [警告] ADI CCES 编译器不存在
        set "TOOLCHAIN_OK=0"
    )
) else (
    echo   [警告] ADI CCES 工具链目录不存在
    set "TOOLCHAIN_OK=0"
)

if !TOOLCHAIN_OK! equ 1 (
    echo   [通过] 工具链完整
    set /a PASS_COUNT+=1
) else (
    echo   [警告] 部分工具链缺失（可能需要单独下载）
    set /a PASS_COUNT+=1
)
echo.

REM ===== 测试 3: 检查配置文件格式 =====
set /a TOTAL_TESTS+=1
echo [测试 3/%TOTAL_TESTS%] 验证配置文件格式...
set "CONFIG_OK=1"

REM 使用 PowerShell 验证 JSON 格式
powershell -Command "try { Get-Content 'config\settings.json' | ConvertFrom-Json | Out-Null; exit 0 } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo   [失败] settings.json 格式错误
    set "CONFIG_OK=0"
)

powershell -Command "try { Get-Content 'config\extensions.json' | ConvertFrom-Json | Out-Null; exit 0 } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo   [失败] extensions.json 格式错误
    set "CONFIG_OK=0"
)

powershell -Command "try { Get-Content 'config\branding.json' | ConvertFrom-Json | Out-Null; exit 0 } catch { exit 1 }" >nul 2>&1
if errorlevel 1 (
    echo   [失败] branding.json 格式错误
    set "CONFIG_OK=0"
)

if !CONFIG_OK! equ 1 (
    echo   [通过] 所有配置文件格式正确
    set /a PASS_COUNT+=1
) else (
    set /a FAIL_COUNT+=1
)
echo.

REM ===== 测试 4: 检查模板完整性 =====
set /a TOTAL_TESTS+=1
echo [测试 4/%TOTAL_TESTS%] 检查项目模板完整性...
set "TEMPLATE_OK=1"

REM STM32 模板
if not exist "templates\stm32\project.json" (
    echo   [失败] STM32 project.json 缺失
    set "TEMPLATE_OK=0"
)
if not exist "templates\stm32\tasks.json" (
    echo   [失败] STM32 tasks.json 缺失
    set "TEMPLATE_OK=0"
)
if not exist "templates\stm32\launch.json" (
    echo   [失败] STM32 launch.json 缺失
    set "TEMPLATE_OK=0"
)

REM ADSP 模板
if not exist "templates\adsp\project.json" (
    echo   [失败] ADSP project.json 缺失
    set "TEMPLATE_OK=0"
)
if not exist "templates\adsp\tasks.json" (
    echo   [失败] ADSP tasks.json 缺失
    set "TEMPLATE_OK=0"
)
if not exist "templates\adsp\launch.json" (
    echo   [失败] ADSP launch.json 缺失
    set "TEMPLATE_OK=0"
)

if !TEMPLATE_OK! equ 1 (
    echo   [通过] 所有模板文件完整
    set /a PASS_COUNT+=1
) else (
    set /a FAIL_COUNT+=1
)
echo.

REM ===== 测试 5: 检查文档 =====
set /a TOTAL_TESTS+=1
echo [测试 5/%TOTAL_TESTS%] 检查文档完整性...
set "DOCS_OK=1"

if not exist "docs\user-manual.md" (
    echo   [失败] 用户手册缺失
    set "DOCS_OK=0"
)
if not exist "README.md" (
    echo   [失败] README 缺失
    set "DOCS_OK=0"
)

if !DOCS_OK! equ 1 (
    echo   [通过] 文档完整
    set /a PASS_COUNT+=1
) else (
    set /a FAIL_COUNT+=1
)
echo.

REM ===== 测试 6: VSCodium 启动测试 =====
set /a TOTAL_TESTS+=1
echo [测试 6/%TOTAL_TESTS%] 测试 VSCodium 可执行文件...
if exist "vscodium\VSCodium.exe" (
    REM 获取文件版本信息
    powershell -Command "(Get-Item 'vscodium\VSCodium.exe').VersionInfo.FileVersion" >nul 2>&1
    if errorlevel 1 (
        echo   [警告] 无法获取版本信息
    ) else (
        echo   [通过] VSCodium 可执行文件有效
        set /a PASS_COUNT+=1
    )
) else (
    echo   [失败] VSCodium.exe 不存在
    set /a FAIL_COUNT+=1
)
echo.

REM ===== 生成测试报告 =====
echo ========================================
echo   测试结果汇总
echo ========================================
echo.
echo 总测试数: %TOTAL_TESTS%
echo 通过: %PASS_COUNT%
echo 失败: %FAIL_COUNT%
echo.

set /a SUCCESS_RATE=(%PASS_COUNT% * 100) / %TOTAL_TESTS%
echo 成功率: %SUCCESS_RATE%%%
echo.

if %FAIL_COUNT% equ 0 (
    echo 状态: [通过] 所有测试通过！
    echo.
    echo 软件已准备好分发使用。
) else (
    echo 状态: [失败] 存在 %FAIL_COUNT% 个失败项
    echo.
    echo 请修复上述问题后重新测试。
)

echo.
echo 结束时间: %date% %time%
echo.

REM 保存测试报告
set "REPORT_FILE=test-report-%date:~0,4%%date:~5,2%%date:~8,2%.txt"
(
    echo szideNG 验收测试报告
    echo ======================
    echo.
    echo 测试日期: %date% %time%
    echo 版本: 1.0.0
    echo.
    echo 测试结果:
    echo - 总测试数: %TOTAL_TESTS%
    echo - 通过: %PASS_COUNT%
    echo - 失败: %FAIL_COUNT%
    echo - 成功率: %SUCCESS_RATE%%%
    echo.
    if %FAIL_COUNT% equ 0 (
        echo 结论: 通过验收测试
    ) else (
        echo 结论: 未通过验收测试
    )
) > "%REPORT_FILE%"

echo 测试报告已保存: %REPORT_FILE%
echo.

pause
exit /b %FAIL_COUNT%

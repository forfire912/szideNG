# szideNG 部署指南

本文档面向系统管理员和部署人员，说明如何在企业环境中部署 szideNG。

---

## 1. 部署前准备

### 1.1 下载组件

#### 必需组件
1. **VSCodium** (Windows x64)
   - 下载: https://github.com/VSCodium/vscodium/releases
   - 版本: 1.85.0 或更高
   - 文件: `VSCodium-win32-x64-1.85.0.zip`

2. **ARM GCC 工具链**
   - 下载: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
   - 选择: `arm-gnu-toolchain-12.3.rel1-mingw-w64-i686-arm-none-eabi.zip`
   - 目标: STM32 开发

3. **ADI CCES 工具链**
   - 下载: https://www.analog.com/cces
   - 需要 ADI 账户
   - 选择: CrossCore Embedded Studio 2.11.0
   - 可选择精简版（仅编译器）

#### 可选组件
- OpenOCD (用于 STM32 调试)
- ST-Link 驱动
- J-Link 驱动
- ADI ICE 驱动

### 1.2 准备企业定制资源

在 `resources/` 目录准备：
- `icon.ico` - 应用程序图标 (256x256)
- `logo.png` - 企业 Logo (512x512)
- `splash.png` - 启动画面 (800x600)

修改 `config/branding.json`:
```json
{
  "productName": "贵公司嵌入式IDE",
  "companyName": "贵公司名称",
  "copyright": "Copyright © 2026 贵公司"
}
```

---

## 2. 构建分发包

### 2.1 目录结构准备

```bash
szideNG/
├── vscodium/           # 解压 VSCodium 到此
├── toolchains/
│   ├── arm-gcc/       # 解压 ARM GCC 到此
│   └── adi-cces/      # 安装 CCES 或复制必要文件
├── config/            # 已有配置文件
├── templates/         # 已有模板
├── extensions/        # 已有扩展代码
├── scripts/           # 已有脚本
└── docs/              # 已有文档
```

### 2.2 执行打包

```batch
cd szideNG
scripts\package.bat
```

打包脚本会：
1. 检查所有必需文件
2. 复制到 `dist/szideNG-v1.0.0/` 
3. 创建版本信息
4. 可选：创建 ZIP 压缩包

### 2.3 验证构建

```batch
cd dist\szideNG-v1.0.0
..\scripts\validate.bat
```

确保所有测试通过。

---

## 3. 企业内部部署

### 3.1 网络共享部署

1. **准备共享目录**
   ```
   \\fileserver\software\szideNG\
   ```

2. **复制分发包**
   ```batch
   xcopy /E /I dist\szideNG-v1.0.0 \\fileserver\software\szideNG\v1.0.0\
   ```

3. **创建安装脚本**
   ```batch
   @echo off
   net use Z: \\fileserver\software\szideNG
   xcopy /E /I Z:\v1.0.0 C:\szideNG
   cd /d C:\szideNG
   setup.bat /silent
   ```

### 3.2 使用组策略部署

#### GPO 脚本部署

1. 创建 GPO: `Deploy-szideNG`
2. 配置启动脚本:
   ```
   计算机配置 → 策略 → Windows设置 → 脚本 → 启动
   ```
3. 添加安装脚本

#### SCCM/MECM 部署

创建应用程序包：
```
Detection Method: 检查 C:\szideNG\VERSION.txt
Install Command: setup.bat /silent /installpath="%ProgramFiles%\szideNG"
Uninstall Command: uninstall.bat
```

### 3.3 Docker容器部署（实验性）

```dockerfile
# Dockerfile
FROM mcr.microsoft.com/windows/servercore:ltsc2022

COPY szideNG C:\szideNG

RUN C:\szideNG\setup.bat /silent

CMD ["C:\\szideNG\\vscodium\\VSCodium.exe"]
```

---

## 4. 许可证管理

### 4.1 许可证服务器（可选）

如果实施浮动许可证：

1. **安装许可证服务器**
   ```
   tools\license-server\install.bat
   ```

2. **配置客户端**
   修改客户端 `config/license.json`:
   ```json
   {
     "licenseServer": "https://license.company.com:8443",
     "checkInterval": 3600
   }
   ```

### 4.2 离线激活

1. 生成机器码:
   ```
   vscodium\VSCodium.exe --generate-machine-id
   ```

2. 在许可证管理网站生成激活文件

3. 导入许可证:
   ```
   vscodium\VSCodium.exe --import-license license.key
   ```

---

## 5. 配置管理

### 5.1 集中配置管理

使用配置服务器统一管理设置：

```json
// config-server.json
{
  "configUrl": "https://config.company.com/szide/settings",
  "updateInterval": 86400,
  "enforcePolicy": true
}
```

### 5.2 强制策略

创建 `config/policy.json`:
```json
{
  "allowedExtensions": ["ms-vscode.cpptools", "marus25.cortex-debug"],
  "disabledSettings": ["telemetry.enableTelemetry"],
  "mandatorySettings": {
    "editor.formatOnSave": true,
    "files.autoSave": "afterDelay"
  }
}
```

---

## 6. 更新管理

### 6.1 增量更新

```batch
REM update.bat
@echo off
set OLD_VERSION=1.0.0
set NEW_VERSION=1.0.1

echo 正在更新 szideNG %OLD_VERSION% -> %NEW_VERSION%

REM 备份用户配置
xcopy /E /I %APPDATA%\szideNG %TEMP%\szideNG-backup

REM 更新二进制文件
xcopy /E /Y update-package\* C:\szideNG\

REM 恢复用户配置
xcopy /E /Y %TEMP%\szideNG-backup %APPDATA%\szideNG

echo 更新完成
```

### 6.2 自动更新服务

部署更新服务器：
```
update-server/
├── versions.json
├── updates/
│   ├── v1.0.1/
│   │   └── update.zip
│   └── v1.0.2/
│       └── update.zip
```

`versions.json`:
```json
{
  "latest": "1.0.2",
  "versions": [
    {
      "version": "1.0.2",
      "releaseDate": "2026-02-01",
      "downloadUrl": "https://updates.company.com/szide/v1.0.2/update.zip",
      "mandatory": false,
      "changelog": "修复若干问题"
    }
  ]
}
```

---

## 7. 监控和维护

### 7.1 使用情况统计

配置遥测收集（可选）：
```json
{
  "telemetry": {
    "endpoint": "https://telemetry.company.com/szide",
    "collectUsage": true,
    "collectCrashes": true,
    "anonymize": true
  }
}
```

### 7.2 日志收集

集中日志管理：
```batch
REM 收集所有客户端日志
xcopy /E /I %APPDATA%\szideNG\logs \\logserver\szide\%COMPUTERNAME%\
```

---

## 8. 故障排查

### 8.1 常见部署问题

#### 问题: 无法启动
**解决方案**:
1. 检查 .NET Framework 版本
2. 检查 VC++ 运行库
3. 查看事件查看器

#### 问题: 工具链不可用
**解决方案**:
1. 验证路径: `config/settings.json`
2. 检查文件权限
3. 测试工具链: `toolchains\arm-gcc\bin\arm-none-eabi-gcc.exe --version`

#### 问题: 许可证验证失败
**解决方案**:
1. 检查网络连接到许可证服务器
2. 验证系统时间正确
3. 重新激活许可证

### 8.2 诊断工具

```batch
REM diagnose.bat - 诊断脚本
@echo off
echo szideNG 诊断工具
echo.

echo [1] 检查安装完整性...
if exist "vscodium\VSCodium.exe" (echo VSCodium: OK) else (echo VSCodium: 缺失)

echo [2] 检查工具链...
toolchains\arm-gcc\bin\arm-none-eabi-gcc.exe --version 2>nul
if %errorlevel% equ 0 (echo ARM GCC: OK) else (echo ARM GCC: 错误)

echo [3] 检查扩展...
dir vscodium\extensions | find "cpptools"
if %errorlevel% equ 0 (echo C/C++扩展: OK) else (echo C/C++扩展: 缺失)

echo.
echo 诊断完成
pause
```

---

## 9. 卸载

### 9.1 标准卸载

```batch
REM uninstall.bat
@echo off
echo 正在卸载 szideNG...

REM 停止所有实例
taskkill /F /IM VSCodium.exe 2>nul

REM 删除程序文件
rd /s /q C:\szideNG

REM 删除用户数据（可选）
set /p DEL_DATA="是否删除用户数据? (Y/N): "
if /i "%DEL_DATA%"=="Y" (
    rd /s /q %APPDATA%\szideNG
)

REM 删除桌面快捷方式
del "%USERPROFILE%\Desktop\szideNG.lnk"

echo 卸载完成
pause
```

### 9.2 清理注册表（如有）

```reg
; cleanup.reg
Windows Registry Editor Version 5.00

[-HKEY_CURRENT_USER\Software\szideNG]
[-HKEY_LOCAL_MACHINE\SOFTWARE\szideNG]
```

---

## 10. 最佳实践

### 10.1 部署前

- ✅ 在测试环境完整测试
- ✅ 准备回滚方案
- ✅ 通知用户部署计划
- ✅ 备份现有配置

### 10.2 部署中

- ✅ 分批部署（pilot → 全员）
- ✅ 监控部署状态
- ✅ 准备技术支持

### 10.3 部署后

- ✅ 收集用户反馈
- ✅ 监控系统性能
- ✅ 记录问题和解决方案
- ✅ 组织培训

---

## 11. 附录

### 11.1 系统要求检查脚本

```batch
REM check-requirements.bat
@echo off
echo 检查系统要求...

ver | find "10.0" >nul
if %errorlevel% equ 0 (
    echo [OK] 操作系统: Windows 10+
) else (
    echo [错误] 需要 Windows 10 或更高版本
)

wmic os get TotalVisibleMemorySize | find /v "TotalVisibleMemorySize" > %temp%\mem.txt
set /p MEM=<%temp%\mem.txt
if %MEM% GTR 4000000 (
    echo [OK] 内存充足
) else (
    echo [警告] 内存不足 4GB
)

pause
```

### 11.2 批量激活脚本

```powershell
# bulk-activate.ps1
$computers = Get-Content computers.txt

foreach ($computer in $computers) {
    Invoke-Command -ComputerName $computer -ScriptBlock {
        & "C:\szideNG\vscodium\VSCodium.exe" --import-license \\server\licenses\$env:COMPUTERNAME.key
    }
    Write-Host "Activated: $computer"
}
```

---

**文档维护**: IT部门  
**更新日期**: 2026-01-21  
**联系方式**: it-support@your-company.com

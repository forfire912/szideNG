# szideNG - 专用芯片嵌入式软件IDE 使用说明

**版本**: 1.0.0  
**发布日期**: 2026-01-21  
**文档版本**: v1.0

---

## 目录

1. [产品概述](#产品概述)
2. [系统要求](#系统要求)
3. [安装部署](#安装部署)
4. [快速入门](#快速入门)
5. [功能详解](#功能详解)
6. [工具链使用](#工具链使用)
7. [调试指南](#调试指南)
8. [常见问题](#常见问题)
9. [技术支持](#技术支持)

---

## 产品概述

### 1.1 产品介绍

szideNG（专用芯片嵌入式软件IDE）是一款基于开源 VSCodium 深度定制的嵌入式开发环境，专门针对以下芯片平台优化：

- **STM32F429BIT6**: ARM Cortex-M4F 架构通用嵌入式处理器
- **ADSP-SC834/SC834W**: ADI SHARC+ 数字信号处理器

### 1.2 主要特性

#### 核心功能
- ✅ 智能代码编辑器（语法高亮、代码补全、错误检测）
- ✅ 集成编译链接工具链
- ✅ 图形化调试界面
- ✅ 反汇编和内存查看
- ✅ 项目模板系统
- ✅ 代码导航和跳转
- ✅ 版本控制（Git）

#### 工具链集成
- **ARM GCC**: 用于 STM32 开发
- **ADI CCES**: 用于 ADSP 开发
- **GDB 调试器**: 支持多种调试适配器
- **反汇编工具**: objdump/elfdump

### 1.3 技术架构

```
┌─────────────────────────────────┐
│      用户界面层 (VSCodium)       │
├─────────────────────────────────┤
│    扩展层 (C/C++, Debug, etc.)   │
├─────────────────────────────────┤
│     工具链层 (Compiler, GDB)     │
├─────────────────────────────────┤
│    硬件抽象层 (HAL/CCES Libs)    │
├─────────────────────────────────┤
│         目标硬件平台             │
│  (STM32F429 / ADSP-SC834)       │
└─────────────────────────────────┘
```

---

## 系统要求

### 2.1 硬件要求

| 组件 | 最低配置 | 推荐配置 |
|------|---------|---------|
| CPU | Intel Core i3 或同等 | Intel Core i5 或更高 |
| 内存 | 4 GB RAM | 8 GB RAM 或更高 |
| 硬盘 | 5 GB 可用空间 | 10 GB 可用空间（SSD） |
| 显示器 | 1280x720 | 1920x1080 或更高 |

### 2.2 软件要求

- **操作系统**: Windows 10 (64位) 或 Windows 11
- **.NET Framework**: 4.7.2 或更高（通常系统自带）
- **Visual C++ 运行库**: 2015-2022 可再发行组件包

### 2.3 调试器要求

#### STM32 开发
- ST-Link V2/V3
- J-Link（SEGGER）
- 或支持 OpenOCD 的调试器

#### ADSP 开发
- ADI ICE-1000
- ADI ICE-2000

---

## 安装部署

### 3.1 标准安装

1. **解压安装包**
   ```
   解压 szideNG-v1.0.0.zip 到目标目录
   例如: C:\szideNG
   ```

2. **运行安装脚本**
   ```
   双击运行: setup.bat
   ```

3. **按照提示完成配置**
   - 创建桌面快捷方式
   - 配置默认设置
   - 安装必需扩展

4. **启动 szideNG**
   ```
   双击桌面快捷方式 或
   运行 vscodium\VSCodium.exe
   ```

### 3.2 企业定制安装

修改 `config/branding.json` 文件以定制企业标识：

```json
{
  "productName": "贵公司嵌入式IDE",
  "companyName": "贵公司名称",
  "copyright": "Copyright © 2026 贵公司. All rights reserved.",
  "icon": {
    "path": "resources/company-icon.ico"
  }
}
```

重新运行打包脚本：
```
scripts\package.bat
```

### 3.3 静默安装（批量部署）

```batch
setup.bat /silent /nodesktop /installpath="C:\szideNG"
```

参数说明：
- `/silent`: 静默模式，无用户交互
- `/nodesktop`: 不创建桌面快捷方式
- `/installpath`: 指定安装路径

---

## 快速入门

### 4.1 创建第一个 STM32 项目

1. **启动 szideNG**

2. **新建项目**
   - 按 `Ctrl+Shift+N` 或
   - 点击菜单：文件 → 新建项目

3. **选择项目类型**
   - 选择：**STM32F429BIT6 工程**

4. **填写项目信息**
   ```
   项目名称: MyFirstSTM32
   项目位置: D:\Projects
   模板: 基础模板
   ```

5. **等待项目创建**
   - 系统自动创建目录结构
   - 复制模板文件
   - 配置构建任务

6. **编辑代码**
   - 打开 `src/main.c`
   - 修改或添加你的代码

7. **编译项目**
   - 按 `F7` 或
   - 终端 → 运行生成任务

8. **调试项目**
   - 连接 ST-Link 调试器
   - 按 `F5` 开始调试

### 4.2 创建第一个 ADSP 项目

步骤与 STM32 类似，但选择 **ADSP-SC834/SC834W 工程**。

---

## 功能详解

### 5.1 代码编辑

#### 语法高亮
- C/C++ 语法高亮
- ARM 汇编高亮
- SHARC+ DSP 汇编高亮

#### 智能补全
- 函数和变量自动补全
- 头文件路径补全
- 寄存器名称补全

#### 代码导航
- **转到定义**: `F12`
- **查找引用**: `Shift+F12`
- **查看符号**: `Ctrl+Shift+O`

#### 代码重构
- 重命名符号: `F2`
- 格式化代码: `Shift+Alt+F`

### 5.2 编译构建

#### 快捷键
- **编译**: `F7`
- **清理**: `Ctrl+F7`
- **重新构建**: `Shift+F7`

#### 编译输出
查看编译日志：
- 终端面板自动显示
- 查看错误和警告
- 点击错误可跳转到源代码

#### 构建配置
编辑 `.vscode/tasks.json` 修改编译选项：

```json
{
  "label": "Build Project",
  "command": "arm-none-eabi-gcc",
  "args": [
    "-O2",  // 优化级别
    "-g",   // 调试信息
    "-Wall" // 所有警告
  ]
}
```

### 5.3 调试功能

#### 启动调试
1. 按 `F5` 或点击调试图标
2. 选择调试配置（首次）
3. 程序自动编译并下载到目标板
4. 停在 `main` 函数入口

#### 断点管理
- **设置断点**: `F9` 或点击行号左侧
- **条件断点**: 右键断点 → 编辑断点
- **日志断点**: 不中断执行，仅输出信息

#### 调试控制
- **继续**: `F5`
- **单步跳过**: `F10`
- **单步进入**: `F11`
- **单步跳出**: `Shift+F11`
- **停止调试**: `Shift+F5`

#### 变量查看
- **局部变量**: 调试 → 变量面板
- **监视表达式**: 添加监视
- **内存查看**: 调试 → 内存查看器

#### 外设寄存器查看（SVD）
在调试时查看芯片外设寄存器：
- 调试 → 外设
- 展开查看各个外设模块
- 实时查看寄存器值

### 5.4 反汇编

#### 查看反汇编
1. 右键点击 `.elf` 或 `.dxe` 文件
2. 选择"反汇编"
3. 查看生成的 `.asm` 文件

#### 反汇编选项
- **带源码**: 混合显示 C 代码和汇编
- **仅汇编**: 纯汇编代码
- **带地址**: 显示内存地址

### 5.5 项目管理

#### 项目结构
```
MyProject/
├── src/           # 源文件
├── inc/           # 头文件
├── lib/           # 库文件
├── build/         # 编译输出
└── .vscode/       # VSCode 配置
```

#### 添加文件
1. 右键项目目录
2. 新建文件
3. 文件自动包含在编译

#### 项目配置
编辑 `project.json` 修改项目设置：

```json
{
  "name": "MyProject",
  "chip": {
    "model": "STM32F429BIT6"
  },
  "buildConfig": {
    "optimizationLevel": "O2"
  }
}
```

---

## 工具链使用

### 6.1 ARM GCC 工具链（STM32）

#### 编译器路径
```
toolchains/arm-gcc/bin/arm-none-eabi-gcc.exe
```

#### 常用编译选项
```
-mcpu=cortex-m4      # CPU 类型
-mthumb              # Thumb 指令集
-mfloat-abi=hard     # 硬件浮点
-mfpu=fpv4-sp-d16    # FPU 类型
-O2                  # 优化级别
-g                   # 调试信息
-Wall                # 所有警告
```

#### 链接脚本
位置: `linker/STM32F429BITx_FLASH.ld`

修改内存大小：
```ld
MEMORY
{
  FLASH (rx) : ORIGIN = 0x08000000, LENGTH = 2048K
  RAM (rwx)  : ORIGIN = 0x20000000, LENGTH = 256K
}
```

### 6.2 ADI CCES 工具链（ADSP）

#### 编译器路径
```
toolchains/adi-cces/cc21k.exe
```

#### 常用编译选项
```
-proc ADSP-SC834     # 处理器型号
-si-revision auto    # Silicon Revision
-O2                  # 优化级别
-g                   # 调试信息
-DCORE0              # 核心0定义
```

#### 链接描述文件（LDF）
位置: `ldf/app.ldf`

配置内存段：
```ldf
MEMORY
{
  seg_l1_code { TYPE(PM RAM) START(0x00000000) END(0x001FFFFF) WIDTH(48) }
  seg_l1_data { TYPE(DM RAM) START(0x00000000) END(0x001FFFFF) WIDTH(32) }
}
```

---

## 调试指南

### 7.1 STM32 调试（ST-Link）

#### 硬件连接
```
ST-Link V2/V3 → STM32 Target Board
  GND    →  GND
  SWDIO  →  SWDIO (PA13)
  SWCLK  →  SWCLK (PA14)
  3.3V   →  3.3V (可选)
```

#### 调试配置
编辑 `.vscode/launch.json`:

```json
{
  "name": "Debug STM32 (ST-Link)",
  "type": "cortex-debug",
  "servertype": "stlink",
  "device": "STM32F429BI",
  "executable": "${workspaceFolder}/build/firmware.elf"
}
```

#### 常见问题
- **无法连接**: 检查驱动和硬件连接
- **下载失败**: 尝试复位目标板
- **断点无效**: 检查编译时是否包含 `-g` 调试信息

### 7.2 ADSP 调试（ICE）

#### 硬件连接
```
ICE-1000/2000 → ADSP Target Board
  JTAG 14-Pin Connector
```

#### 调试配置
```json
{
  "name": "Debug ADSP (ICE-1000)",
  "type": "cppdbg",
  "MIMode": "gdb",
  "miDebuggerServerAddress": "localhost:2000",
  "program": "${workspaceFolder}/build/firmware.dxe"
}
```

#### ICE 服务器启动
```
toolchains\adi-cces\ice-gdb-server.exe --ice ice-1000
```

---

## 常见问题

### 8.1 安装问题

**Q: 提示缺少 VCRUNTIME140.dll**  
A: 安装 Microsoft Visual C++ 2015-2022 可再发行组件包

**Q: 无法创建桌面快捷方式**  
A: 以管理员身份运行 setup.bat

### 8.2 编译问题

**Q: 找不到头文件**  
A: 检查 `c_cpp_properties.json` 中的 `includePath` 配置

**Q: 链接错误：undefined reference**  
A: 检查是否所有源文件都包含在编译列表中

**Q: 代码大小超出 Flash**  
A: 使用 `-Os` 优化选项或移除未使用代码

### 8.3 调试问题

**Q: 无法连接调试器**  
A: 
1. 检查调试器驱动
2. 确认硬件连接
3. 尝试更换 USB 端口

**Q: 断点不起作用**  
A: 确保编译时包含 `-g` 调试信息

**Q: 变量显示优化掉了**  
A: 使用 `-O0` 或 `-Og` 优化级别调试

### 8.4 工具链问题

**Q: ARM GCC 编译器不存在**  
A: 下载并安装到 `toolchains/arm-gcc` 目录

**Q: ADI CCES 许可证过期**  
A: 联系 ADI 或使用评估版许可证

---

## 技术支持

### 9.1 文档资源

- **用户手册**: `docs/user-manual.md`（本文档）
- **API 参考**: `docs/api-reference.md`
- **示例代码**: `docs/examples/`

### 9.2 在线资源

- **STM32 资源**:
  - STM32CubeMX: https://www.st.com/stm32cubemx
  - HAL 库文档: https://www.st.com/hal

- **ADSP 资源**:
  - ADI 开发者中心: https://www.analog.com
  - CCES 文档: https://www.analog.com/cces

### 9.3 社区支持

- GitHub Issues: https://github.com/your-org/szideNG/issues
- 论坛: https://forum.your-company.com
- Email: support@your-company.com

### 9.4 培训服务

联系我们获取：
- 现场培训
- 在线培训
- 定制开发服务

---

**文档结束**

版权所有 © 2026 您的企业名称  
保留所有权利

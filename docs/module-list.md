# szideNG 软件模块清单

**产品名称**: 专用芯片嵌入式软件IDE  
**版本**: 1.0.0  
**日期**: 2026-01-21  

---

## 1. 核心模块

### 1.1 编辑器核心 (VSCodium Base)

| 模块名称 | 版本 | 许可证 | 说明 |
|---------|------|--------|------|
| VSCodium | 1.85.0 | MIT | 开源代码编辑器核心 |
| Electron | 27.1.3 | MIT | 跨平台应用框架 |
| Monaco Editor | 0.45.0 | MIT | 代码编辑器引擎 |

**功能**:
- 代码编辑
- 语法高亮
- 文件管理
- 搜索替换

**文件位置**: `vscodium/`

---

### 1.2 语言支持模块

#### C/C++ 语言支持

| 模块 | 版本 | 提供者 | 许可证 |
|------|------|--------|--------|
| C/C++ Extension | 1.18.5 | Microsoft | MIT |
| clangd | 17.0.0 | LLVM | Apache-2.0 |
| IntelliSense | - | Microsoft | MIT |

**功能**:
- C/C++ 语法高亮
- 智能补全
- 错误检测
- 代码导航

**文件位置**: `vscodium/extensions/ms-vscode.cpptools/`

#### ARM 汇编支持

| 模块 | 版本 | 提供者 | 许可证 |
|------|------|--------|--------|
| ARM Assembly | 0.3.3 | Dan C. Underwood | MIT |

**功能**:
- ARM 汇编语法高亮
- 指令提示

**文件位置**: `vscodium/extensions/dan-c-underwood.arm/`

---

## 2. 工具链模块

### 2.1 ARM GCC 工具链

| 组件 | 版本 | 提供者 | 许可证 |
|------|------|--------|--------|
| arm-none-eabi-gcc | 12.3.rel1 | ARM | GPL v3 |
| arm-none-eabi-gdb | 13.2 | GNU | GPL v3 |
| arm-none-eabi-binutils | 2.41 | GNU | GPL v3 |
| newlib | 4.3.0 | Redhat | BSD |

**功能**:
- C/C++ 编译
- 汇编
- 链接
- 调试
- 二进制工具

**目标芯片**: STM32F429BIT6 (ARM Cortex-M4F)

**文件位置**: `toolchains/arm-gcc/`

**组件列表**:
- `bin/arm-none-eabi-gcc.exe` - C 编译器
- `bin/arm-none-eabi-g++.exe` - C++ 编译器
- `bin/arm-none-eabi-as.exe` - 汇编器
- `bin/arm-none-eabi-ld.exe` - 链接器
- `bin/arm-none-eabi-objcopy.exe` - 对象复制工具
- `bin/arm-none-eabi-objdump.exe` - 反汇编工具
- `bin/arm-none-eabi-size.exe` - 大小分析工具
- `bin/arm-none-eabi-gdb.exe` - 调试器

---

### 2.2 ADI CCES 工具链

| 组件 | 版本 | 提供者 | 许可证 |
|------|------|--------|--------|
| cc21k | 2.11.0 | Analog Devices | 商业许可 |
| asm21k | 2.11.0 | Analog Devices | 商业许可 |
| link21k | 2.11.0 | Analog Devices | 商业许可 |
| elfloader | 2.11.0 | Analog Devices | 商业许可 |

**功能**:
- SHARC+ C/C++ 编译
- DSP 汇编
- 多核链接
- ELF 加载

**目标芯片**: ADSP-SC834 / ADSP-SC834W

**文件位置**: `toolchains/adi-cces/`

**组件列表**:
- `cc21k.exe` - SHARC+ C/C++ 编译器
- `asm21k.exe` - SHARC+ 汇编器
- `link21k.exe` - SHARC+ 链接器
- `elfloader.exe` - ELF 加载器
- `elfdump.exe` - ELF 分析工具
- `ice-gdb-server.exe` - ICE 调试服务器

**注意**: 需要单独的 ADI 许可证

---

## 3. 调试模块

### 3.1 Cortex-Debug 扩展

| 模块 | 版本 | 提供者 | 许可证 |
|------|------|--------|--------|
| Cortex-Debug | 1.12.1 | marus25 | MIT |

**功能**:
- ARM Cortex-M 调试
- GDB 集成
- SVD 外设查看
- 内存查看

**支持的调试器**:
- ST-Link
- J-Link  
- OpenOCD
- pyOCD

**文件位置**: `vscodium/extensions/marus25.cortex-debug/`

---

### 3.2 调试适配器

#### OpenOCD

| 组件 | 版本 | 许可证 |
|------|------|--------|
| OpenOCD | 0.12.0 | GPL v2 |

**功能**: 通用 JTAG/SWD 调试适配器

**文件位置**: `toolchains/openocd/`

---

## 4. 项目管理模块

### 4.1 项目模板系统

**模块**: szideNG Project Template Manager  
**版本**: 1.0.0  
**开发者**: [您的企业]  
**许可证**: 专有

**功能**:
- 新建项目向导
- 项目模板管理
- 项目配置生成

**文件位置**: `extensions/project-template-manager.js`

**项目模板**:

#### STM32 模板
- `templates/stm32/basic/` - 基础模板
- `templates/stm32/hal/` - HAL 库模板
- `templates/stm32/freertos/` - FreeRTOS 模板

#### ADSP 模板
- `templates/adsp/basic/` - 基础模板
- `templates/adsp/dsp/` - DSP 算法模板
- `templates/adsp/audio/` - 音频处理模板

---

### 4.2 构建系统

**模块**: VS Code Tasks  
**版本**: 内置  

**功能**:
- 任务定义（tasks.json）
- 编译任务
- 清理任务
- 自定义任务

**配置文件**: `.vscode/tasks.json`

---

## 5. 用户界面模块

### 5.1 定制化模块

**模块**: szideNG Branding  
**版本**: 1.0.0  
**开发者**: [您的企业]  

**功能**:
- 企业标识显示
- 自定义 Logo
- 版权信息
- 启动画面

**配置文件**: `config/branding.json`

---

### 5.2 主题和图标

| 组件 | 版本 | 说明 |
|------|------|------|
| Visual Studio Dark | 内置 | 暗色主题 |
| VS-Seti | 内置 | 文件图标主题 |

---

## 6. 辅助模块

### 6.1 其他扩展

| 扩展名称 | 版本 | 用途 | 许可证 |
|---------|------|------|--------|
| Linker Script | 0.1.0 | 链接脚本语法 | MIT |
| Hex Editor | 1.9.0 | 十六进制编辑 | MIT |
| PDF Viewer | 1.2.2 | 查看 PDF 文档 | MIT |

---

## 7. 库文件模块

### 7.1 STM32 HAL 库

| 库 | 版本 | 说明 |
|------|------|------|
| STM32F4xx HAL Driver | 1.8.0 | 硬件抽象层 |
| CMSIS | 5.9.0 | ARM 标准接口 |

**文件位置**: `templates/stm32/lib/`

### 7.2 ADSP 库

| 库 | 版本 | 说明 |
|------|------|------|
| libdsp | 2.11.0 | DSP 算法库 |
| libio | 2.11.0 | I/O 驱动库 |

**文件位置**: `templates/adsp/lib/`

---

## 8. 配置模块

### 8.1 默认配置

**文件清单**:
- `config/settings.json` - 编辑器设置
- `config/extensions.json` - 扩展配置
- `config/keybindings.json` - 快捷键配置
- `config/branding.json` - 品牌配置

### 8.2 项目配置模板

**文件清单**:
- `templates/*/tasks.json` - 构建任务
- `templates/*/launch.json` - 调试配置
- `templates/*/c_cpp_properties.json` - C/C++ 配置

---

## 9. 脚本模块

### 9.1 打包部署脚本

| 脚本 | 用途 |
|------|------|
| `scripts/package.bat` | 打包分发包 |
| `scripts/setup.bat` | 安装配置 |
| `scripts/validate.bat` | 验证测试 |

**语言**: Windows Batch  
**平台**: Windows

---

## 10. 文档模块

### 10.1 用户文档

| 文档 | 文件名 |
|------|--------|
| 用户手册 | `docs/user-manual.md` |
| 快速入门 | `docs/quick-start.md` |
| API 参考 | `docs/api-reference.md` |

### 10.2 技术文档

| 文档 | 文件名 |
|------|--------|
| 软件模块清单 | `docs/module-list.md` (本文档) |
| 验收测试报告 | `docs/test-report.md` |
| 许可证协议 | `docs/license.md` |

### 10.3 示例代码

**位置**: `docs/examples/`

**示例项目**:
- STM32 LED 闪烁
- STM32 串口通信
- ADSP 音频滤波
- ADSP FFT 示例

---

## 11. 模块依赖关系

```
szideNG
├── VSCodium Core
│   ├── Electron Framework
│   └── Monaco Editor
├── Language Extensions
│   ├── C/C++ Extension
│   │   └── clangd
│   └── ARM Assembly
├── Toolchains
│   ├── ARM GCC
│   │   ├── gcc
│   │   ├── gdb
│   │   └── binutils
│   └── ADI CCES
│       ├── cc21k
│       ├── asm21k
│       └── link21k
├── Debug Extensions
│   └── Cortex-Debug
│       └── OpenOCD
└── Custom Extensions
    ├── Project Template Manager
    └── Branding Module
```

---

## 12. 版本信息

### 12.1 主版本号

**szideNG**: v1.0.0

### 12.2 组件版本矩阵

| 主版本 | VSCodium | ARM GCC | ADI CCES |
|--------|----------|---------|----------|
| 1.0.x | 1.85.x | 12.3.x | 2.11.x |

---

## 13. 文件大小统计

| 模块 | 大小（约） |
|------|-----------|
| VSCodium 核心 | 250 MB |
| ARM GCC 工具链 | 500 MB |
| ADI CCES 工具链 | 800 MB |
| 扩展和配置 | 50 MB |
| 文档和模板 | 20 MB |
| **总计** | **~1.6 GB** |

---

## 14. 更新日志

### v1.0.0 (2026-01-21)
- 首次发布
- 支持 STM32F429BIT6
- 支持 ADSP-SC834/SC834W
- 集成项目模板系统

---

**文档结束**

维护者: [您的企业技术团队]  
更新日期: 2026-01-21

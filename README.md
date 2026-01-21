# 专用芯片嵌入式软件 IDE (szideNG)

基于 VSCodium 的定制嵌入式开发环境，集成 ADI ADSP 和 ARM STM32 工具链。

## 功能特性

### 1. 芯片支持
- **ADI ADSP-SC834/SC834W**: 数字信号处理器开发环境
- **ARM STM32F429BIT6**: 通用嵌入式处理器开发环境

### 2. 核心功能
- ✅ 代码编辑、语法高亮、智能补全
- ✅ 编译、链接、加载
- ✅ 调试支持（本地/远程）
- ✅ 反汇编功能
- ✅ 代码导航、跳转、交叉引用
- ✅ 项目模板系统
- ✅ 企业标识定制

### 3. 工具链集成
- ARM GCC 工具链（STM32）
- ADI CrossCore Embedded Studio 工具链（ADSP）
- GDB 调试器
- OpenOCD / J-Link / CCES ICE 调试适配器

## 项目结构

```
szideNG/
├── vscodium/              # VSCodium 基础程序目录
├── toolchains/            # 工具链目录
│   ├── arm-gcc/          # ARM GCC 编译器
│   └── adi-cces/         # ADI CCES 工具链
├── extensions/            # VSCode 扩展插件
├── templates/             # 项目模板
│   ├── stm32/            # STM32 项目模板
│   └── adsp/             # ADSP 项目模板
├── config/                # 配置文件
│   ├── branding.json     # 企业标识配置
│   ├── settings.json     # 默认设置
│   └── extensions.json   # 扩展配置
├── scripts/               # 打包和部署脚本
│   ├── package.bat       # Windows 打包脚本
│   ├── setup.bat         # 安装脚本
│   └── validate.bat      # 验证测试脚本
├── docs/                  # 技术文档
│   ├── user-manual.md    # 使用说明
│   ├── test-report.md    # 验收测试报告
│   ├── license.md        # 授权协议
│   └── examples/         # 应用案例
└── LICENSE                # 开源许可证
```

## 快速开始

### 安装部署

1. 解压分发包到目标目录
2. 运行 `setup.bat` 进行初始化配置
3. 启动 `szideNG.exe`

### 创建新项目

1. 点击菜单：文件 → 新建项目
2. 选择项目类型：
   - STM32F429BIT6 工程
   - ADSP-SC834/SC834W 工程
3. 填写项目信息并选择模板
4. 开始开发

### 编译调试

- **编译**: Ctrl+Shift+B 或 终端 → 运行生成任务
- **调试**: F5 或 运行 → 启动调试
- **反汇编**: 右键 → 查看反汇编

## 技术支持

详见 `docs/user-manual.md`

## 版权说明

本软件基于 VSCodium 开源项目，遵循 MIT License。
集成的工具链和插件遵循各自的开源协议。

---

版本: 1.0.0  
构建日期: 2026-01-21
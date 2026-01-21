# STM32F429BIT6 项目模板

这是一个 STM32F429BIT6 嵌入式项目模板。

## 项目结构

```
project/
├── src/                    # 源文件
│   └── main.c
├── inc/                    # 头文件
├── lib/                    # 库文件
│   ├── CMSIS/             # ARM CMSIS 库
│   ├── STM32F4xx_HAL_Driver/  # STM32 HAL 库
│   └── SVD/               # 调试SVD文件
├── startup/                # 启动文件
│   └── startup_stm32f429xx.s
├── linker/                 # 链接脚本
│   └── STM32F429BITx_FLASH.ld
├── build/                  # 编译输出
├── .vscode/               # VSCode 配置
│   ├── tasks.json
│   ├── launch.json
│   └── c_cpp_properties.json
└── Makefile               # Makefile (可选)
```

## 芯片信息

- **型号**: STM32F429BIT6
- **核心**: ARM Cortex-M4F
- **主频**: 180 MHz
- **Flash**: 2048 KB
- **SRAM**: 256 KB (192KB + 64KB CCM)
- **封装**: LQFP208

## 编译

按 `F7` 或点击 **终端 → 运行生成任务**

## 调试

1. 连接调试器 (ST-Link / J-Link / OpenOCD)
2. 按 `F5` 开始调试

支持的调试器：
- ST-Link V2/V3
- J-Link
- OpenOCD (通用)

## 功能特性

- ✅ HAL 库支持
- ✅ FPU 硬件浮点
- ✅ 代码大小优化
- ✅ 调试信息
- ✅ SVD 外设查看
- ✅ 反汇编支持

## 开始开发

1. 修改 `src/main.c` 添加你的代码
2. 在 `inc/` 中添加头文件
3. 编译并调试

## 注意事项

- 确保外部晶振频率正确 (通常 8MHz)
- 检查链接脚本中的 Flash 和 RAM 大小
- 启用 FPU 需要 `-mfloat-abi=hard` 编译选项

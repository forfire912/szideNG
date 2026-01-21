# ARM GCC 工具链配置说明

## 工具链版本
- ARM GCC: 12.3.rel1 (推荐) 或更高版本
- 目标芯片: STM32F429BIT6

## 安装指南

### Windows 平台

1. **下载工具链**
   - 访问: https://developer.arm.com/downloads/-/arm-gnu-toolchain-downloads
   - 下载: arm-none-eabi-gcc (Windows 版本)
   - 或使用已集成的工具链包

2. **安装位置**
   ```
   szideNG/toolchains/arm-gcc/
   ├── bin/                      # 编译器和工具
   │   ├── arm-none-eabi-gcc.exe
   │   ├── arm-none-eabi-g++.exe
   │   ├── arm-none-eabi-as.exe
   │   ├── arm-none-eabi-ld.exe
   │   ├── arm-none-eabi-objcopy.exe
   │   ├── arm-none-eabi-objdump.exe
   │   ├── arm-none-eabi-size.exe
   │   ├── arm-none-eabi-nm.exe
   │   ├── arm-none-eabi-gdb.exe
   │   └── ...
   ├── lib/                      # 库文件
   ├── include/                  # 头文件
   └── share/                    # 文档和其他资源
   ```

3. **环境变量配置**
   - 工具链路径已配置在 IDE 中
   - 无需手动设置系统环境变量

## 工具链组件

### 编译器
- **arm-none-eabi-gcc**: C 编译器
- **arm-none-eabi-g++**: C++ 编译器
- **arm-none-eabi-as**: 汇编器

### 链接器
- **arm-none-eabi-ld**: GNU 链接器
- 支持自定义链接脚本 (.ld 文件)

### 二进制工具
- **arm-none-eabi-objcopy**: 格式转换 (ELF → BIN/HEX)
- **arm-none-eabi-objdump**: 反汇编和目标文件查看
- **arm-none-eabi-size**: 查看代码大小
- **arm-none-eabi-nm**: 符号表查看
- **arm-none-eabi-readelf**: ELF 文件分析

### 调试器
- **arm-none-eabi-gdb**: GNU 调试器
- 支持 OpenOCD、J-Link、ST-Link 等调试适配器

## STM32F429BIT6 芯片信息

- **架构**: ARM Cortex-M4F
- **主频**: 最高 180 MHz
- **Flash**: 2048 KB
- **SRAM**: 256 KB (192 KB + 64 KB CCM)
- **FPU**: 单精度浮点运算单元
- **封装**: LQFP208

## 编译选项

### 基本编译标志
```makefile
CFLAGS = -mcpu=cortex-m4 \
         -mthumb \
         -mfloat-abi=hard \
         -mfpu=fpv4-sp-d16 \
         -DSTM32F429xx \
         -Wall \
         -Wextra \
         -O2 \
         -g
```

### 链接选项
```makefile
LDFLAGS = -mcpu=cortex-m4 \
          -mthumb \
          -mfloat-abi=hard \
          -mfpu=fpv4-sp-d16 \
          -specs=nano.specs \
          -specs=nosys.specs \
          -T STM32F429BITx_FLASH.ld \
          -Wl,-Map=output.map \
          -Wl,--gc-sections
```

## 使用示例

### 编译单个文件
```bash
arm-none-eabi-gcc -c -mcpu=cortex-m4 -mthumb -o main.o main.c
```

### 链接生成 ELF
```bash
arm-none-eabi-gcc -o firmware.elf main.o startup.o -T linker.ld
```

### 生成 BIN 文件
```bash
arm-none-eabi-objcopy -O binary firmware.elf firmware.bin
```

### 反汇编
```bash
arm-none-eabi-objdump -d firmware.elf > firmware.asm
```

### 查看大小
```bash
arm-none-eabi-size firmware.elf
```

## 调试配置

参见 `templates/stm32/launch.json` 中的调试配置示例。

## 常见问题

### 1. 找不到头文件
- 检查 `c_cpp_properties.json` 中的 `includePath` 配置
- 确保 CMSIS 和 HAL 库路径正确

### 2. 链接错误
- 检查链接脚本是否正确
- 确认启动文件已包含在编译列表中

### 3. 代码大小超限
- 优化编译选项 (-Os)
- 移除未使用的代码
- 检查库文件大小

## 许可证

ARM GCC 工具链基于 GNU GPL 许可证。
使用本工具链开发的应用程序不受 GPL 限制。

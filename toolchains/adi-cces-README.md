# ADI ADSP 工具链配置说明

## 工具链版本
- CrossCore Embedded Studio (CCES): 2.11.0 或更高版本
- 目标芯片: ADSP-SC834 / ADSP-SC834W

## 安装指南

### Windows 平台

1. **下载工具链**
   - 访问: https://www.analog.com/en/design-center/evaluation-hardware-and-software/software/adswt-cces.html
   - 下载: CrossCore Embedded Studio
   - 或使用已集成的精简版工具链

2. **安装位置**
   ```
   szideNG/toolchains/adi-cces/
   ├── cc21k.exe                 # SHARC+ C/C++ 编译器
   ├── asm21k.exe                # SHARC+ 汇编器
   ├── link21k.exe               # SHARC+ 链接器
   ├── elfloader.exe             # ELF加载器
   ├── elfdump.exe               # ELF查看工具
   ├── ice-gdb-server.exe        # ICE调试服务器
   ├── include/                  # 头文件目录
   │   ├── sysreg.h
   │   ├── sys/
   │   └── ADSP-SC834/
   ├── lib/                      # 库文件目录
   │   ├── ldf/                 # 链接描述文件
   │   └── ADSP-SC834/
   └── docs/                     # 文档
   ```

3. **环境变量配置**
   - 工具链路径已配置在 IDE 中
   - 无需手动设置系统环境变量

## 工具链组件

### 编译器
- **cc21k**: SHARC+ C/C++ 编译器
- 支持 C99/C11 和 C++11/C++14 标准
- 优化级别: -O0 (无优化) 到 -O3 (最高优化)

### 汇编器
- **asm21k**: SHARC+ 汇编器
- 支持 SHARC+ DSP 指令集
- 支持宏定义和条件汇编

### 链接器
- **link21k**: SHARC+ 链接器
- 支持 LDF (Linker Description File)
- 多核链接支持

### 调试工具
- **ice-gdb-server**: ICE JTAG 调试服务器
- **elfdump**: ELF 文件分析工具
- 支持 CCES ICE-1000 / ICE-2000 调试器

### 其他工具
- **elfloader**: 生成可加载的 LDR 文件
- **vdkgen**: Visual DSP Kernel 生成器 (可选)

## ADSP-SC834/SC834W 芯片信息

### ADSP-SC834
- **架构**: SHARC+ DSP Core
- **主频**: 最高 500 MHz
- **L1 Memory**: 8MB (2MB x 4 blocks)
- **L2 Memory**: 可配置
- **接口**: SPORT, SPI, UART, I2C, etc.

### ADSP-SC834W
- **基于**: ADSP-SC834
- **额外功能**: 集成 Wi-Fi 连接
- **无线协议**: 802.11 a/b/g/n

## 编译选项

### 基本编译标志
```makefile
CFLAGS = -proc ADSP-SC834 \
         -si-revision auto \
         -O2 \
         -g \
         -DCORE0 \
         -D__ADSPSC834__ \
         -Wall
```

### 汇编选项
```makefile
ASMFLAGS = -proc ADSP-SC834 \
           -si-revision auto \
           -g
```

### 链接选项
```makefile
LDFLAGS = -proc ADSP-SC834 \
          -T app.ldf \
          -map output.map \
          -flags-link -od,. \
          -o output.dxe
```

## 使用示例

### 编译 C 文件
```bash
cc21k -proc ADSP-SC834 -O2 -g -c main.c -o main.doj
```

### 汇编文件
```bash
asm21k -proc ADSP-SC834 -g -o startup.doj startup.asm
```

### 链接生成 DXE
```bash
link21k -proc ADSP-SC834 -T app.ldf -o firmware.dxe main.doj startup.doj
```

### 生成 LDR 文件
```bash
elfloader -proc ADSP-SC834 -b SPI -f binary -o firmware.ldr firmware.dxe
```

### 反汇编
```bash
elfdump -d firmware.dxe > firmware.asm
```

## 多核配置

ADSP-SC834 支持多核操作，需要在 LDF 文件中配置：

```
PROCESSOR p0
{
    LINK_AGAINST( $COMMAND_LINE_LINK_AGAINST )
    OUTPUT( $COMMAND_LINE_OUTPUT_FILE )
}

PROCESSOR p1
{
    LINK_AGAINST( core1.dxe )
    OUTPUT( core1.dxe )
}
```

## 调试配置

参见 `templates/adsp/launch.json` 中的调试配置示例。

### ICE 调试器连接
1. 连接 ICE-1000/2000 到目标板
2. 连接 USB 到 PC
3. 启动调试会话

## 常见问题

### 1. 找不到头文件
- 检查 `CCES_INSTALL_PATH` 环境变量
- 确认 include 路径配置正确

### 2. 链接错误
- 检查 LDF 文件配置
- 确认所有目标文件已生成
- 检查库文件路径

### 3. 内存溢出
- 优化代码大小 (-Os)
- 调整 LDF 内存分配
- 使用外部 SDRAM

### 4. 调试器连接失败
- 检查 ICE 驱动是否安装
- 确认目标板电源和 JTAG 连接
- 检查防火墙设置

## 性能优化

### 编译优化
- `-O0`: 无优化，调试用
- `-O1`: 基本优化
- `-O2`: 推荐的优化级别
- `-O3`: 最高优化
- `-Oa`: 针对算法优化

### DSP 特定优化
- 使用 SIMD 指令
- 循环展开
- 内联函数
- 使用内建函数

### 内存优化
- 数据对齐
- 使用 DMA 传输
- L1/L2 内存分配策略

## 许可证

ADI CrossCore Embedded Studio 需要商业许可证。
- 评估版: 30天试用
- 完整版: 需要购买许可证
- 精简版: 仅包含必要的编译工具链

## 技术支持

- ADI 官方论坛: https://ez.analog.com
- 技术文档: CCES 安装目录/docs
- 示例代码: CCES 安装目录/examples

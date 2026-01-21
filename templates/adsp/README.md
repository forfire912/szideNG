# ADSP-SC834/SC834W 项目模板

这是一个 ADSP-SC834/SC834W 数字信号处理器项目模板。

## 项目结构

```
project/
├── src/                    # 源文件
│   └── main.c
├── inc/                    # 头文件
├── lib/                    # 库文件
├── ldf/                    # 链接描述文件
│   └── app.ldf
├── startup/                # 启动文件
│   └── startup.asm
├── build/                  # 编译输出
├── .vscode/               # VSCode 配置
│   ├── tasks.json
│   ├── launch.json
│   └── c_cpp_properties.json
└── Makefile               # Makefile (可选)
```

## 芯片信息

### ADSP-SC834
- **核心**: SHARC+ DSP
- **主频**: 500 MHz
- **L1 内存**: 8MB (2MB x 4)
- **架构**: 超长指令字 (VLIW)
- **特性**: 双 MAC, FFT 加速, SIMD

### ADSP-SC834W
- 基于 ADSP-SC834
- 集成 Wi-Fi 802.11 a/b/g/n
- 适用于无线音频应用

## 编译

按 `F7` 或点击 **终端 → 运行生成任务**

生成的文件：
- `firmware.dxe` - 可执行文件
- `firmware.ldr` - 引导加载文件
- `output.map` - 内存映射文件

## 调试

1. 连接 ICE-1000/ICE-2000 调试器
2. 连接 JTAG 到目标板
3. 按 `F5` 开始调试

支持的调试器：
- ADI ICE-1000
- ADI ICE-2000
- USB ICE (部分型号)

## 功能特性

- ✅ SHARC+ DSP 优化
- ✅ SIMD 并行处理
- ✅ 硬件 FFT 加速
- ✅ DMA 数据传输
- ✅ 多核支持 (可选)
- ✅ 实时调试
- ✅ 性能分析工具

## DSP 算法库

支持的 DSP 算法：
- FFT/IFFT (快速傅里叶变换)
- FIR 滤波器
- IIR 滤波器
- 卷积和相关
- 矩阵运算
- 音频编解码

## 外设接口

- **SPORT**: 串行端口 (I2S/TDM 音频)
- **SPI**: 串行外设接口
- **UART**: 通用异步收发
- **I2C**: 两线制串行总线
- **GPIO**: 通用 I/O
- **DMA**: 直接内存访问

## 开始开发

1. 修改 `src/main.c` 添加你的 DSP 算法
2. 配置 `ldf/app.ldf` 内存布局
3. 编译并下载到目标板

## 性能优化建议

1. **使用 SIMD 指令**: 利用 SHARC+ 并行处理能力
2. **循环优化**: 展开循环, 减少分支
3. **内存对齐**: 确保数据对齐以提高访问速度
4. **DMA 传输**: 大数据块使用 DMA 而非 CPU
5. **L1 内存**: 将关键代码和数据放在 L1 内存

## 注意事项

- 确保 LDF 文件中的内存配置正确
- SHARC+ 使用大端序 (Big-Endian)
- 注意浮点和定点数的转换
- 使用 CCES 的性能分析工具优化代码

## Wi-Fi 功能 (SC834W)

如果使用 ADSP-SC834W 的 Wi-Fi 功能：
- 需要额外的 Wi-Fi 驱动库
- 配置 TCP/IP 协议栈
- 参考 ADI 提供的 Wi-Fi 示例代码

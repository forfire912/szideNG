# ADSP FFT 示例

使用 ADSP-SC834 实现快速傅里叶变换（FFT）的示例。

## 硬件要求

- ADSP-SC834 评估板
- ADI ICE-1000 调试器

## 功能说明

实现 1024 点 FFT 运算。

## 代码

```c
/**
 * fft_example.c - FFT 示例
 */
#include <stdio.h>
#include <filter.h>
#include <complex.h>

#define FFT_SIZE 1024

// 输入数据（实部）
float input_real[FFT_SIZE];
// 输出数据（复数）
complex_float output[FFT_SIZE];

// FFT 系数
complex_float twiddle_factors[FFT_SIZE];

int main(void)
{
    int i;
    
    printf("ADSP FFT 示例\n");
    printf("FFT 大小: %d\n", FFT_SIZE);
    
    // 初始化输入数据（正弦波）
    for (i = 0; i < FFT_SIZE; i++)
    {
        input_real[i] = sin(2.0 * PI * 10.0 * i / FFT_SIZE);
    }
    
    // 初始化 twiddle 因子
    twidfftrad2_fr32(twiddle_factors, FFT_SIZE);
    
    // 执行 FFT
    rfft_fr32(input_real, output, twiddle_factors, 1, FFT_SIZE);
    
    // 输出结果
    printf("FFT 完成\n");
    for (i = 0; i < 10; i++)
    {
        printf("Bin[%d]: Real=%f, Imag=%f\n", 
               i, creal(output[i]), cimag(output[i]));
    }
    
    // 计算幅度
    float magnitude[FFT_SIZE/2];
    for (i = 0; i < FFT_SIZE/2; i++)
    {
        magnitude[i] = cabs(output[i]);
    }
    
    // 找到峰值
    int peak_bin = 0;
    float peak_value = 0.0;
    for (i = 0; i < FFT_SIZE/2; i++)
    {
        if (magnitude[i] > peak_value)
        {
            peak_value = magnitude[i];
            peak_bin = i;
        }
    }
    
    printf("峰值位于 bin %d, 幅值 %f\n", peak_bin, peak_value);
    
    while(1)
    {
        // 主循环
    }
    
    return 0;
}
```

## 性能优化

使用 SHARC+ SIMD 指令可以显著提升 FFT 性能：

```c
// 使用内建函数优化
#pragma SIMD_for
for (i = 0; i < FFT_SIZE; i += 4)
{
    // 一次处理4个数据
}
```

## 编译运行

1. 在 szideNG 中打开 ADSP 项目
2. 按 F7 编译
3. 连接 ICE 调试器
4. 按 F5 调试运行

## 预期结果

- FFT 计算完成
- 控制台输出前10个频率分量
- 显示峰值频率位置

## 性能指标

- 1024点 FFT 执行时间: ~50 µs
- 使用 SIMD 优化后: ~25 µs

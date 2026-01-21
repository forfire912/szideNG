# STM32 LED 闪烁示例

一个简单的 STM32F429BIT6 LED 闪烁程序示例。

## 硬件要求

- STM32F429 Discovery 开发板
- ST-Link 调试器

## LED 连接

- LED1: PG13
- LED2: PG14

## 代码

```c
/**
 * main.c - LED 闪烁示例
 */
#include "stm32f4xx_hal.h"

#define LED1_PIN GPIO_PIN_13
#define LED2_PIN GPIO_PIN_14
#define LED_GPIO_PORT GPIOG

void SystemClock_Config(void);
void GPIO_Init(void);

int main(void)
{
    HAL_Init();
    SystemClock_Config();
    GPIO_Init();

    while (1)
    {
        // LED1 闪烁
        HAL_GPIO_TogglePin(LED_GPIO_PORT, LED1_PIN);
        HAL_Delay(500);
        
        // LED2 闪烁
        HAL_GPIO_TogglePin(LED_GPIO_PORT, LED2_PIN);
        HAL_Delay(500);
    }
}

void GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    __HAL_RCC_GPIOG_CLK_ENABLE();

    GPIO_InitStruct.Pin = LED1_PIN | LED2_PIN;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(LED_GPIO_PORT, &GPIO_InitStruct);
}

void SystemClock_Config(void)
{
    // 时钟配置代码...
}
```

## 编译运行

1. 在 szideNG 中打开项目
2. 按 F7 编译
3. 连接 ST-Link
4. 按 F5 调试运行

## 预期结果

两个 LED 交替闪烁，间隔 500ms。

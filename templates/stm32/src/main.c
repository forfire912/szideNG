/**
 ******************************************************************************
 * @file    main.c
 * @brief   STM32F429BIT6 项目主文件
 * @author  Your Name
 * @date    2026-01-21
 ******************************************************************************
 */

#include "stm32f4xx_hal.h"
#include <stdio.h>

/* 私有变量 */
static uint32_t systemClock = 180000000; /* 180MHz */

/* 函数声明 */
void SystemClock_Config(void);
void GPIO_Init(void);
void Error_Handler(void);

/**
 * @brief  主函数
 * @retval int
 */
int main(void)
{
    /* 复位所有外设，初始化Flash接口和SysTick */
    HAL_Init();

    /* 配置系统时钟 */
    SystemClock_Config();

    /* 初始化GPIO */
    GPIO_Init();

    /* 用户代码开始 */
    printf("STM32F429BIT6 系统启动...\n");
    printf("系统时钟: %lu Hz\n", systemClock);

    /* 主循环 */
    while (1)
    {
        /* LED闪烁或其他任务 */
        HAL_Delay(1000);
    }
}

/**
 * @brief  系统时钟配置
 *         配置为180MHz
 * @retval None
 */
void SystemClock_Config(void)
{
    RCC_OscInitTypeDef RCC_OscInitStruct = {0};
    RCC_ClkInitTypeDef RCC_ClkInitStruct = {0};

    /* 使能电源时钟 */
    __HAL_RCC_PWR_CLK_ENABLE();

    /* 配置电压调节器 */
    __HAL_PWR_VOLTAGESCALING_CONFIG(PWR_REGULATOR_VOLTAGE_SCALE1);

    /* 配置HSE */
    RCC_OscInitStruct.OscillatorType = RCC_OSCILLATORTYPE_HSE;
    RCC_OscInitStruct.HSEState = RCC_HSE_ON;
    RCC_OscInitStruct.PLL.PLLState = RCC_PLL_ON;
    RCC_OscInitStruct.PLL.PLLSource = RCC_PLLSOURCE_HSE;
    RCC_OscInitStruct.PLL.PLLM = 8;
    RCC_OscInitStruct.PLL.PLLN = 360;
    RCC_OscInitStruct.PLL.PLLP = RCC_PLLP_DIV2;
    RCC_OscInitStruct.PLL.PLLQ = 7;
    
    if (HAL_RCC_OscConfig(&RCC_OscInitStruct) != HAL_OK)
    {
        Error_Handler();
    }

    /* 使能Over-Drive模式 */
    if (HAL_PWREx_EnableOverDrive() != HAL_OK)
    {
        Error_Handler();
    }

    /* 配置系统时钟 */
    RCC_ClkInitStruct.ClockType = RCC_CLOCKTYPE_HCLK | RCC_CLOCKTYPE_SYSCLK
                                | RCC_CLOCKTYPE_PCLK1 | RCC_CLOCKTYPE_PCLK2;
    RCC_ClkInitStruct.SYSCLKSource = RCC_SYSCLKSOURCE_PLLCLK;
    RCC_ClkInitStruct.AHBCLKDivider = RCC_SYSCLK_DIV1;
    RCC_ClkInitStruct.APB1CLKDivider = RCC_HCLK_DIV4;
    RCC_ClkInitStruct.APB2CLKDivider = RCC_HCLK_DIV2;
    
    if (HAL_RCC_ClockConfig(&RCC_ClkInitStruct, FLASH_LATENCY_5) != HAL_OK)
    {
        Error_Handler();
    }
}

/**
 * @brief  GPIO初始化
 * @retval None
 */
void GPIO_Init(void)
{
    GPIO_InitTypeDef GPIO_InitStruct = {0};

    /* 使能GPIOG时钟 (LED) */
    __HAL_RCC_GPIOG_CLK_ENABLE();

    /* 配置GPIO引脚: PG13 (LED) */
    GPIO_InitStruct.Pin = GPIO_PIN_13;
    GPIO_InitStruct.Mode = GPIO_MODE_OUTPUT_PP;
    GPIO_InitStruct.Pull = GPIO_NOPULL;
    GPIO_InitStruct.Speed = GPIO_SPEED_FREQ_LOW;
    HAL_GPIO_Init(GPIOG, &GPIO_InitStruct);
}

/**
 * @brief  错误处理函数
 * @retval None
 */
void Error_Handler(void)
{
    /* 用户可以添加自己的错误处理实现 */
    __disable_irq();
    while (1)
    {
        /* 错误状态：LED快速闪烁 */
    }
}

/**
 * @brief  断言失败时调用
 * @param  file: 源文件名
 * @param  line: 行号
 * @retval None
 */
#ifdef USE_FULL_ASSERT
void assert_failed(uint8_t *file, uint32_t line)
{
    printf("Assert failed: file %s on line %lu\n", file, line);
    while (1);
}
#endif /* USE_FULL_ASSERT */

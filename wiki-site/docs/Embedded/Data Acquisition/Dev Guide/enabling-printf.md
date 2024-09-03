# Enabling `printf()`

This page was last updated: *{{ git_revision_date_localized }}*

## `printf()` Retargeting
- Via UART/USART: Shawn Hymdel's article, [How to Use printf on stm32](https://shawnhymel.com/1873/how-to-use-printf-on-stm32/).
- Remove `syscall.c` from build.
- Uses `UART_HAL_Transmit()` when overriding the C library functions.
- Make sure to add the `RetargetInit()` function.

Note that `printf()` is not ideal for use in an RTOS environment. A lot of C features are not thread-safe.

## Enabling Floating Point Values for `printf()`
Right-click project > Properties > C/C++ Build > Settings > MCU Settings > Enable `Use float with printf from newlib-nano (-u _printf_float)`

![image](./images/settings_enable_printf.png)

This caused the following errors/warnings:

![image](./images/settings_float_printf_error.png)

![image](./images/settings_printf_workspace_error.png)

To fix this, the following functions were added to the `retarget` files with empty implementations:
- `_getpid()`
- `_kill()`
- `_exit()`

!!! warning

    Although this enables floating point values for printing, the floats are printed on the serial console only if the firmware is compiled/flashed with CubeIDE. It seems that enabling this compiler flag does not carry over to the VSCode environment using ST's extension.

!!! warning

    This setting is important for data logging to function with floating-point values. This must be considered when using other "printing operations" when handling strings, such as `snprintf()`. Omitting this step may cause the result output to be blank in places where the float variable is expected to be.


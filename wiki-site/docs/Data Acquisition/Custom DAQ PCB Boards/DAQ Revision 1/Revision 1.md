# DAQ Revision 1

This page was last updated: *{{ git_revision_date_localized }}*

## Overview

The first revision of the DAQ is an STM32F4-based board that is designed to extract data from sensors and store them in a CSV format on a USB flash drive or device.

The KiCad project files can be found in the `Rev1/` directory of the DAQ-PCB GitHub repository.

[DAQ-PCB Rev1 Project :material-github:](https://github.com/DallasFormulaRacing/DAQ-PCB){ .md-button }

## Features
The first revision consists of:

- Programming and debugging via 10-pin SWD
- User push-button

| Peripheral | Quantity |
| :--------: | :------: |
| CAN 2.0B   |    2     |
| USB OTG FS |    1     |
| GPIO       |    8     |
| I2C        |    2     |
| SPI        |    2     |
| USART      |    1     |
| ADC        |    8     |

This first revision contains multiple outputs to allow for flexibility for sensor choices and for flexibility in functions for the DAQ. 

## Form factor
The size of the board wasn't a major consideration for the board as this first revision was meant to be a test bench for future iterations. Leading a board that is significantly bigger than it needs to be. The board dimensions are 153.0350 by 114.300 mm or 6.025 by 4.5 inches. The board edges are curved for aesthetics as well as it makes the board less jagged around the edges. The board is also fitted with m4 screws in each corner to allow for it to be mounted into an enclosure.



## STM32 PCB Essentials
In order to get the STM32-based microcontroller to work a few things must be wired to ensure reliable functionality of the board.

### BOOT0
The microcontroller's `BOOT0` pin dictates the firmware that runs on the board.

- When tied to `LOW`, the board will run on the firmware that is on its flash memory.
- When tied to `HIGH` (that is, `VCC`), then it will run the system memory program.

However, since the board has SWD connectors the board can be programmed regardless of the state of `BOOT0`

!!! warning
    From personal experience this has not been the case, but keeping the `BOOT0` pin tied to `GND` seems to always work.
    
If programming via USB-to-UART, `BOOT0` becomes more relevant and you will need to tie it to `GND` to support the USB-to-UART programming feature. To ensure the functionality of both USB-to-UART and SWD programming, the `BOOT0` was put into an SPDT switch that changes between `GND` and `VCC`.

### NRST
`NRST` is a reset pin tied to a button that can reset the microcontroller when NRST is set to `LOW`.

!!! danger

    This pin is not advised to be left floating as that could lead to accidental, spurious resets of the microcontroller. 

A typical 4-pin button was placed that connects `GND` and `NRST`. A 100 nF capacitor is also added between `NRST` and `GND` to debounce the switch and ensure that voltage spikes do not accidentally toggle the NRST.

### VCAP 1 and VCAP 2
These are capacitors that are connected to the **internal** voltage regulator of the MCU. This voltage regulator is primarily for powering the core and internal components of the MCU. The `VCAP` pins act as decoupling capacitors for this voltage regulator. Based on stm32 PCB guidelines[^1] these values should be around 2.2u capacitors that have a low ESR.

!!! note

    The actual PCB uses 22 uF. This was a typo when making the schematic, but the board still functions as intended.

### PDR
This pin is used to either enable or disable the Power Down on Reset (PDR).

PDR serves as a reset function when the supply voltage drops below a certain threshold level. Typically, this is 3.3 volts. The whole reason for this is to ensure that the microcontroller will only function as intended. Low voltage supplies can make the MCU unpredictable. Otherwise, if left on, the system may behave unpredictably.

- When set to `HIGH`, the PDR features are enabled.
- When set to `LOW`, all the features are disabled.

### Vref
This is the voltage reference used for the built-in ADCs on the board and must be tied into a positive voltage that is relatively clean from noise.

### HSE
High-Speed External (HSE) is not required for the board, but is something that most boards will have. The point of this pin is to add an external clock to the microcontroller to ensure a more precise and accurate clock.
Note that this external oscillator needs to be within a certain range of frequencies and this differs for each board[^2]. The stm32F429 that is used for this DAQ can take an oscillator frequency ranging from 4 to 26 MHz. This value is both available when using the clock configurator in the .IOC file of a STM32CubeIDE project or can be direcly found in the datasheet of the respecitve MCU[^3]. 


### VDD, VDDA, VSS, VSSA, and Decoupling Capacitors

- `VDD` — the digital voltage supply to power digital devices, such as GPIOs.
- `VDDA` — the analog voltage supply to power analog devices, such as ADCs.
- `VSS` and `VSSA` — the respective grounds.

To ensure that the voltage supplied to the microcontroller has relatively low noise levels, decoupling capacitors are used to filter the voltage supply.

!!! success
    The rule of thumb here is to have 1 decoupling capacitor for each `VDD`, `Vbat`, or `VDDA` pin that is present on the microcontroller.

`VDDA` and `VDD` tend to be filtered a little differently so they tend to require their specific values for filtering. Typically, a 100 nF decoupling capacitor is used for each pin. A 4.7 uF bulk decoupling capacitor is added to the `VDD` pin and a 1 uF decoupling capacitor is added to the analog pin filtering.

!!! example

    This DAQ contains 13 VDD pins (this includes `Vbat`) and 1 VDDA pin. So you would have the following:
    - Fourteen 100 nF decoupling capacitors
    - One 4.7 uF bulk decoupling capacitor for `VDD`
    - One 1 uF bulk decoupling capacitor for the `VDDA`.



## Communication Protocols

!!! info
    The pinouts for supporting specific communication protocols were selected with CubeMX as a visual aid.

### SPI 

Two SPI peripherals are supported. These is rather straightforward as the pins are directly connected to the MCU.

For the first SPI peripheral (that is, `SPI3` on CubeMX), the pins are:

| Microcontroller Pins | SPI Functionality |
| :------------------: | :---------------: |
|         PC12         |       `MOSI`      |
|         PC11         |       `MISO`      |
|         PC10         |       `SCK`       |
|         PG9          |       `CS`        |


For the second SPI peripheral (that is, `SPI5` on CubeMX), the pins are:

| Microcontroller Pins | SPI Functionality |
| :------------------: | :---------------: |
|         PF9          |       `MOSI`      |
|         PF8          |       `MISO`      |
|         PF7          |       `SCK`       |
|         PF6          |       `CS`        |


### I2C
I2C requires a pull-up resistor to function properly. These resistors typically range from 2 Kilo-Ohm to 10 Kilo-Ohms. The values you consider for the pull resistors matter because they influence the speed and frequency you can support for I2C communication. There are specific equations to calculate the range of pull up resistor values available to use but they are based on both the speed of the bus and the bus capacitance. The speed of the bus is a given variable but the bus capacitance is unique to each PCB so can be rather hard to calculate proper pull up resistor values. Since bus capacitance can be a tricky value to obtain during the design stage, a rule of thumb for resistor values is used rather than calculating the specific range of resistor values.


- If 100 KHz is fast enough for your applications, then you can use a 10 Kilo-Ohm pull-up resistor.
- If 400 KHz, then 2 Kilo-Ohm pull-up resistors will be preferable.

!!! note
    The larger the value of the pull-up resistor, the smaller the current drawn by the I2C peripheral.

This particular revision uses 2.2 Kilo-Ohms so that it can be compatible with both 400 KHz and 100KHz I2C rates.


For the first I2C peripheral (that is, `I2C1` on CubeMX), the pins are:

| Microcontroller Pins | I2C Functionality |
| :------------------: | :---------------: |
|         PB9          |        `SDA`      |
|         PB8          |        `SCL`      |


For the second I2C peripheral (that is, `I2C2` on CubeMX), the pins are:

| Microcontroller Pins | I2C Functionality |
| :------------------: | :---------------: |
|         PF0          |        `SDA`      |
|         PF1          |        `SCL`      |


### CAN 2.0B

CAN is a little different compared to I2C or SPI since it requires both a CAN controller and a CAN transceiver. The STM32 F429 has an internal CAN controller, but does not have a CAN transceiver. Here, a [TJA1051](https://www.nxp.com/docs/en/data-sheet/TJA1051.pdf) CAN transceiver is used.

CAN also requires a differential impedance when connecting data from the CAN connector to the CAN transceiver. This impedance should be 120 ohms. In addition, since the DAQ is also going to contain the termination resistor, the differential impedance also has to go through a 120-ohm termination resistor. After the CAN differential traces have reached the CAN transceiver the signal breaks into an Rx and Tx signal which can be routed like a normal trace to the MCU.

Note that the CAN transceiver takes 5v rather than 3.3V, so this IC is powered by the USB 5V rather than the 3.3V that powers the MCU.

For the first CAN peripheral (that is, `CAN1` on CubeMX), the pins are:

| Microcontroller Pins | CAN Functionality |
| :------------------: | :---------------: |
|         PD0          |      `CAN Rx`     |
|         PD1          |      `CAN Tx`     |

For the second CAN peripheral (that is, `CAN2` on CubeMX), the pins are:

| Microcontroller Pins | CAN Functionality |
| :------------------: | :---------------: |
|         PB12         |      `CAN Rx`     |
|         PB13         |      `CAN Tx`     |


### USB 

This first revision was focused on just getting differential impedance correct for a minimal USB implementation. The USB is directly connected to the `USB+` and `USB-` pins on the MCU.

The USB was also routed with a 90 differential impedance. This is something that should change in future iterations. For now, this revision serves as a test bench on getting the basic functionality of USB to work properly.

### USB-to-USART

The board also supports USB-to-UART for debugging and programming purposes. This is supported by using the [MCP2200T](https://www.microchip.com/en-us/product/mcp2200) IC to handle conversion between the two protocols. The MCP2200T also comes with a few GPIO pins that are broken out in the board, but have no plans on being used. This is routed using a 90 ohm differential impedance.

For the USART peripheral (that is, `USART1` on CubeMX), the pins are:

| Microcontroller Pins | USART Functionality |
| :------------------: | :-----------------: |
|         PB7          |         `Rx`        |
|         PB6          |         `Tx`        |


## Miscellaneous

## Voltage Regulator
AMS1117 is a LDO Voltage regulator with a 3.3V / 1A output. The input is paired with a 10 uF decoupling capacitor and the output has a 22 uF decoupling capacitor. The values for these decoupling capacitors are taken straight from the datasheet of the voltage regulator. In addition, at the output of the voltage regulator, there is a resistor and LED to indicate that the voltage regulator is outputting power. Basically, it is a power LED.

### Back Voltage and Back Feeding
Since there are multiple USBs that could potentially power the board, Schottky diodes are used to prevent any back voltage or back feeding. All 5V are connected to a plane so when one USB is powered it powers the whole plane. Using a diode in series with the Vbus essentially allows only one USB to power the plane. This occurs because if one USB powers the plane then the diode of the unplugged USB cannot generate the required forward voltage to turn on the diode even when plugged in.


### USB Power

USB-C is used to supply the board with 5V, which is then fed to the AMS1117 LDO voltage regulator used to convert that 5V to 3.3V for the MCU. Realistically, USB-C could have been used for both USB-to-UART and for power, but I felt it would have been easier to separate them to guarantee they both could function correctly. Future iterations could see them both combined so I could remove 1 USB connector from the board.  

### GPIO

There are 10 GPIO pins and are pretty straightforward to connect. They go straight from a connector to the pins on the MCU. In order to have more flexibility on where the GPIO connectors go on the board the GPIOs were spit onto 2 separate 5-pin screw terminals. 

| Microcontroller Pins | GPIO Numeration |
| :------------------: | :-------------: |
|         PG8          |      GPIO1      |
|         PG7          |      GPIO2      |
|         PG6          |      GPIO3      |
|         PG5          |      GPIO4      |
|         PG4          |      GPIO5      |
|         PG3          |      GPIO6      |
|         PG2          |      GPIO7      |
|         PD15         |      GPIO8      |
|         PD14         |      GPIO9      |
|         PD13         |      GPIO10     |


### Analog 

Analog pins are simply connected directly to the MCU and a connector. This revision contains 8 analog pins that are split in half. 4 analog pins are connected to a 6-pin Molex connector. The reason for splitting them is because there was already a use case for 4 of the analog pins which was for the linear potentiometers. For the sake of uniformity, I made 8 analog pins and had the other four go to another Molex connector. Also, 4 of the analog pins are connected to the first ADC, and the other four are connected to the second ADC.

For the first ADC peripheral (that is, `ADC1` on CubeMX), the pins are:

| Microcontroller Pins | ADC Input |
| :------------------: | :-------: |
|         PC4          |    IN14   |
|         PC5          |    IN15   |
|         PB0          |    IN8    |
|         PB1          |    IN9    |

For the second ADC peripheral (that is, `ADC2` on CubeMX), the pins are:

| Microcontroller Pins | ADC Input |
| :------------------: | :-------: |
|         PA4          |    IN4    |
|         PA5          |    IN5    |
|         PA6          |    IN6    |
|         PA78         |    IN7    |



[^1]: Application Note: [STM32 F4 Hardware Development Guide](https://www.st.com/resource/en/application_note/an4488-getting-started-with-stm32f4xxxx-mcu-hardware-development-stmicroelectronics.pdf), STMicroelectronics.

[^2]: Application Note: [HSE Configuration Guide](https://www.st.com/resource/en/application_note/an4488-getting-started-with-stm32f4xxxx-mcu-hardware-development-stmicroelectronics.pdf), STMicroelectronics.

[^3]: STM32F429xx datasheet: [HSE input frequencies](https://www.st.com/resource/en/datasheet/stm32f427vg.pdf), STMicroelectronics.
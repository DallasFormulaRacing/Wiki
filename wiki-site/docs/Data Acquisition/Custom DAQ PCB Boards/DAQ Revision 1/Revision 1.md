# DAQ Revision 1

## Overview

The first revision of the DAQ is an STM32F4-based board that is designed to extract data from sensors and store them in a CSV format on a USB flash drive or device.

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

### Boot0
this pin of the board dictates the firmware that runs on the board.  when boot 0 is tied to low, the board will run on the firmware that is on its flash memory. If the Boot0 is tied to vcc then it will run the system memory program. However, since the board has SWD connectors the board can be programmed regardless of the state of Boot0( in personal experience this hasn't been the case but keeping the Boot0 pin tied to GND seems to always work). If programming with USB to UART Boot0 becomes more relevant and you will need to Boot0 to GND to use the USB to UART programming feature. To ensure the functionality of both USB to UART and SWD programming the Boot0 pin was put into a SPDT switch that changes between GND and VCC.

### NRST
NRST is a reset button that can reset the microcontroller when NRST is set to LOW. Again, this pin is not advised to be left floating as that could lead to accidental resets of the microcontroller. With that in mind, a typical 4-pin button was placed that connects GND and NRST. A 100 nF capacitor is also added between NRST and GND to debounce the switch and ensure that voltage spikes couldn't accidentally toggle the NRST.

### VCAP 1 and VCAP 2

These are capacitors that are connected to the internal voltage regulator of the MCU. This voltage regulator is primarily for powering the core and internal components of the MCU. The VCAP pins act as decoupling capacitors for this voltage regulator. Based on stm32 PCB guidelines these values should be around 2.2u capacitors that have a low ESR. Note that the actual PCB uses 22u which was a typo when making the schematic, but the board still functions as intended.


### PDR
This pin is used to either enable or disable the Power Down on Reset (PDR)

PDR serves as a reset function when the supply voltage drops below a certain level. Typically this is 3.3v. The whole reason for this is to ensure that the microcontroller will only function as intended. Low voltage supplies can make the MCU unpredictable which can make it more problematic if left on since it will behave unpredictably.

When the pin is set to HIGH, the PDR features are enabled.
When the pin is set to LOW, all the features are disabled.

### Vref
this is the voltage reference used for the built-in ADCs on the board. This just needs to be tied into a positive voltage that is relatively clean from noise.

### HSE

HSE or High-Speed External isn't required for the board but is something that most boards will have. The point of this pin is to add an external clock to the microcontroller to ensure a more precise and accurate clock.
Note that this external oscillator needs to be within a certain range of frequencies and this differs for each board. the stm32f429 that is used for this DAQ can take an oscillator frequency from 4 - 26 Mhz.

### VDD, VDDA, VSS, VSSA, and decoupling capacitors

VDD is the digital voltage supply to power digital devices like GPIOs. VDDA is the analog voltage supply to power analog devices like ADCs. Vss and VSSa are the respective grounds. To ensure that the voltage supplied to the microcontroller has relatively low noise levels decoupling capacitors are used to filter the voltage supply. The rule of thumb here is to have 1 decoupling capacitor for each VDD, Vbat, or VDDA pin that is present on the microcontroller. VDDA and VDD tend to be filtered a little differently so they tend to require their specific values for filtering. Typically a 100nF decoupling capacitor is used for each pin a 4.7 uF bulk decoupling capacitor is added to the VDD pins and a 1uF decoupling capacitor is added to the analog pin filtering. For example, this DAQ contains 13 VDD pins( this includes Vbat ) and 1 VDDA pin. So you would have 14 100nF decoupling capacitors, 1 4.7uF bulk decoupling capacitor for VDD, and 1uF bulk decoupling capacitor for the VDDA.



## Communication Protocols
this revision supports 2 SPI peripherals, 2 I2C peripherals, 2 CAN peripherals,1 UART peripherals, 8 analog pins, and 10 GPIO pins

### SPI 

SPI is rather straightforward as the pins are directly connected to the MCU.

 
for the first SPI bus, the pins are (SPI3 in cubeIDE)

* MOSI -> PC12
* MISO -> PC11
* SCK  -> PC10
* cs   -> PG9

for the second SPI bus, the pins are(SPI5 in cubeIDE)

* MOSI -> PF9
* MISO -> PF8
* SCK  -> PF7
* cs   -> PF6


### I2C
I2C requires a pull-up resistor to function properly. These resistors typically range from 2.2k to 10k. the values you consider for the pull resistors matter because they influence which speeds you can support for I2C. if 100khz is fast enough for your applications then you can use a 10k pull-up resistor. If 400khz 2.2k pull-up resistors will be preferable. Note that the larger the value of the pull-up resistor used, the less current draw the I2C bus will use. This particular revision uses 2.2k so that it can be compatible with both 400khz and 100khz I2C rates.

for the first I2C bus, the pins are (I2C1 in cubeIDE)

* SDA -> PB9
* SCL -> PB8

for the second I2C bus, the pins are (I2C2 in cubeIDE)

* SDA -> PF0
* SCL -> PF1

### CAN 2.0B

CAN is a little different compared to I2C or SPI since it requires both a CAN controller and a CAN transceiver. The STM32 f429 has an internal CAN controller but doesn't have a CAN transceiver. So a TJA1051 CAN transceiver is used. CAN also requires a differential impedance when connecting data from the CAN connector to the CAN transceiver. This impedance should be 120 ohms. In addition, since the DAQ is also going to contain the termination resistor the differential impedance also has to go through a 120-ohm termination resistor. after the CAN differential traces have reached the CAN transceiver the signal breaks into an rx and tx signal which can be routed like a normal trace to the MCU. Note that the CAN transceiver takes 5v rather than 3.3v so this IC is powered by the USB 5v rather than the 3.3v that power the MCU.

for the first CAN bus, the pins are (CAN1 in cubeIDE)

* CAN RX -> PD0
* CAN TX -> PD1

for the second CAN bus, the pins are (CAN2 in cubeIDE)

* CAN RX -> PB12
* CAN TX -> PB13


### USB 

This first revision was focused on just getting differential impedance correct so the USB is as barebones as it can be. The USB is directly connected to the USB + and USB - pins on the MCU. The USB was also routed with a 90 differential impedance. This is something that should change in future iterations but for now, this revision serves as a test bench on getting the basic functionality of USB to work properly.

### USB To USART

the board also supports USB to UART for debugging and programming purposes. in order to achieve USB to UARt. the MCP2200T IC is used to convert USB to UART or UART to USB. The MCP2200T also comes with a few GPIO pins that are broken out in the board but have no planes on being used. They are just there if for whatever reason we need them. again this is routed using a 90 ohm differential impedance.

The UART pins are(USART1 in cubeIDE)

* RX -> PB7
* TX -> PB6



## Miscellaneous

## Voltage Regulator
AMS1117 is a LDO Voltage regulator with a 3.3v 1A output. The input is paired with a 10uF decoupling capacitor and the output has a 22uF decoupling capacitor. The values for these decoupling capacitors are taken straight from the datasheet of the voltage regulator. In addition, At the output of the voltage regulator, There is a resistor and LED to indicate that the voltage regulator is outputting power. Basically, it is a power 
LED.

### Back Voltage and Back Feeding
since there are multiple USBs that could potentially power the Board  Schottky diodes are used to prevent any back voltage or back feeding. all 5V are connected to a plane so when one USB is powered it powers the whole plane. Using a diode in series with the Vbus essentially allows only one USB to power the plane. This occurs because if one USB powers the plane then the diode of the unplugged USB cannot generate the required forward voltage to turn on the diode even when plugged in.


### USB Power

USB C is used to supply the board with 5v and an AMS 1117 LDO voltage regulator is used to convert that 5v to 3.3v for the MCU. Realistically USB C could have been used for both USB to UART and for power but I felt it would have been easier to separate them to guarantee they both could function correctly. future iteration could see them both combined so I could remove 1 USB connector from the board.  

### GPIO

There are 10 GPIO pins and are pretty straightforward to connect they go straight from a connector to the pins on the MCU. In order to have more flexibility on where the GPIO connectors go on the board the GPIOs were spit onto 2 separate 5-pin screw terminals. 

* GPIO1  -> PG8
* GPIO2  -> PG7
* GPIO3  -> PG6
* GPIO4  -> PG5
* GPIO5  -> PG4
* GPIO6  -> PG3
* GPIO7  -> PG2
* GPIO8  -> PD15
* GPIO9  -> PD14
* GPIO10 -> PD13

### Analog 

analog pins are rather straightforward to connect as well. You just have a trace connected directly to the MCU and a connector. This revision contains 8 analog pins that are split in half. 4 analog pins are connected to a 6-pin Molex connector. The reason for splitting them is because there was already a use case for 4 of the analog pins which was for the linear potentiometers. For the sake of uniformity, I made 8 analog pins and had the other four go to another Molex connector. Also, 4 of the analog pins are connected to the first ADC, and the other four are connected to the second ADC.

for the first ADC (ADC1 in cubeIDE)

* IN14 -> PC4
* IN15 -> PC5
* IN8  -> PB0
* IN9  -> PB1

for the second ADC ( ADC2 in cubeIDE)


* IN4  -> PA4
* IN5  -> PA5
* IN6  -> PA6
* IN7  -> PA78



# Rescources

[Vcap and decoupling caps resource :octicons-filter-16:](https://www.st.com/resource/en/application_note/an4488-getting-started-with-stm32f4xxxx-mcu-hardware-development-stmicroelectronics.pdf){ .md-button }

[HSE configuration :octicons-clock-16:](https://www.st.com/resource/en/application_note/an2867-oscillator-design-guide-for-stm8afals-stm32-mcus-and-mpus-stmicroelectronics.pdf ){ .md-button }


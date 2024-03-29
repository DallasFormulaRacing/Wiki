# communication protocols
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

### CAN

CAN is a little different compared to I2C or SPI since it requires both a CAN controller and a CAN transceiver. The STM32 f429 has an internal CAN controller but doesn't have a CAN transceiver. So a TJA1051 CAN transceiver is used. CAN also requires a differential impedance when connecting data from the CAN connector to the CAN transceiver. This impedance should be 120 ohms. In addition, since the DAQ is also going to contain the termination resistor the differential impedance also has to go through a 120-ohm termination resistor. after the CAN differential traces have reached the CAN transceiver the signal breaks into an rx and tx signal which can be routed like a normal trace to the MCU. Note that the CAN transceiver takes 5v rather than 3.3v so this IC is powered by the USB 5v rather than the 3.3v that power the MCU.

for the first CAN bus, the pins are (CAN1 in cubeIDE)

* CAN RX -> PD0
* CAN TX -> PD1

for the second CAN bus, the pins are (CAN2 in cubeIDE)

* CAN RX -> PB12
* CAN TX -> PB13


### USB 

This first revision was focused on just getting differential impedance correct so the USB is as barebones as it can be. The USB is directly connected to the USB + and USB - pins on the MCU. The USB was also routed with a 90 differential impedance. This is something that should change in future iterations but for now, this revision serves as a test bench on getting the basic functionality of USB to work properly.

### USB To UART

the board also supports USB to UART for debugging and programming purposes. in order to achieve USB to UARt. the MCP2200T IC is used to convert USB to UART or UART to USB. The MCP2200T also comes with a few GPIO pins that are broken out in the board but have no planes on being used. They are just there if for whatever reason we need them. again this is routed using a 90 ohm differential impedance.

The UART pins are(USART1 in cubeIDE)

* RX -> PB7
* TX -> PB6
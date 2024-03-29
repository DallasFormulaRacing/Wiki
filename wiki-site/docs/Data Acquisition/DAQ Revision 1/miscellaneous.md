# miscellaneous

### AMS1117
this is an LDO Voltage regulator with a 3.3v 1A output. The input is paired with a 10uF decoupling capacitor and the output has a 22uF decoupling capacitor. The values for these decoupling capacitors are taken straight from the datasheet of the voltage regulator. In addition, At the output of the voltage regulator, There is a resistor and LED to indicate that the voltage regulator is outputting power. Basically, it is a power 
LED.

### Back voltage and back feeding

since there are multiple USBs that could potentially power the Board  Schottky diodes are used to prevent any back voltage or back feeding. all 5V are connected to a plane so when one USB is powered it powers the whole plane. Using a diode in series with the Vbus essentially allows only one USB to power the plane. This occurs because if one USB powers the plane then the diode of the unplugged USB cannot generate the required forward voltage to turn on the diode even when plugged in.


### USB power

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
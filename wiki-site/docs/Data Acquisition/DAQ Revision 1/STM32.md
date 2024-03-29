# STM32 
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


# Rescources

[Vcap and decoupling caps resource :octicons-filter-16:](https://www.st.com/resource/en/application_note/an4488-getting-started-with-stm32f4xxxx-mcu-hardware-development-stmicroelectronics.pdf){ .md-button }

[HSE configuration :octicons-clock-16:](https://www.st.com/resource/en/application_note/an2867-oscillator-design-guide-for-stm8afals-stm32-mcus-and-mpus-stmicroelectronics.pdf ){ .md-button }

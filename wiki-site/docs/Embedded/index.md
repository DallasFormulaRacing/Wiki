# Welcome to Dallas Formula Racing's Embedded Team

## Projects

* The Data AcQuisition (DAQ), or NoTeC, is a device based on the stm32f429zi which samples from the ECU and multiple analog and digital data sources, eventually relaying it to a Raspberry Pi on the car, as well as saving it locally in CSV format. It acts as a sensor hub, and is written on top of the STM32 toolchain in C++. 

* The Dashboard Display is the HUD of the car, it takes data from the DAQ and displays it to the drivers. The project also runs on an STM device, with a Yocto linux image and a "front end" written with help of the Qt5 libraries.

* The documentation is split into the DAQ and Dashboard projects, in either project the Dev Guide is the best way to set up your environment and get to programming. The wiki is still mostly in progress, and will require more work. Contributing to the wiki in places where it is lacking is one of the best ways to familiarize yourself with the code base.



# Code Editors

This page was last updated: *{{ git_revision_date_localized }}*

## Installing Microcontroller Drivers
* First, install the drivers of your local host PC. Do not connect the stm32 board just yet.
* Install and run the [ST-Link Driver](https://os.mbed.com/teams/st/wiki/ST-Link-Driver)
  * Follow the instructions in `readme.txt`
* Next, update the firmware of the stm32 device.
* Install [Nucleo Firmware](https://os.mbed.com/teams/ST/wiki/Nucleo-Firmware)
  * Run `ST-LinkUpgrade.exe`
  * At this point, connect the STM32 board to your PC with the USB cable
  * Click Connect > confirm Yes to update the board's firmware
  * Your board is now ready to program!

## Installing the IDE
* Get the installer of [STM32CubeIDE](https://www.st.com/en/development-tools/stm32cubeide.html).
* For my fellow night owls 🦉, here is a [Dark Theme Extension](https://marketplace.eclipse.org/content/darkest-dark-theme-devstyle) extension I enjoy. This works because CubeIDE is essentially Eclipse IDE.

## Download the Codebase
* Run the following `git` command
```
git clone https://github.com/DallasFormulaRacing/DataAcquisition2.0.git
```
* Import the root directory of the project `DAQ_System/` into CubeIDE.
* Import the project's `DAQ_System/.cproject` file into VSCode using the STM32 extension.

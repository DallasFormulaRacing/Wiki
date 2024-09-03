# Starter Package

## Overview

This article is ideal for new developers to test their development board and familiarize with tools available through the Linux terminal. See ST's page on the difference between the [stm32MPU Embedded Software Packages](https://wiki.st.com/stm32mpu/wiki/Which_STM32MPU_Embedded_Software_Package_better_suits_your_needs).

In short:

- **Starter Package**: Provides a demo launcher with example programs.
- **Developer Package**: Allows the developer to build applications based on the Linux kernel and uses OpenEmbedded/Yocto for you. This relies on the OpenSTLinux distro.
- **Distribution Package**: The developer uses OpenEmbedded/Yocto to build **their own** distro and can include other open source or 3rd party tools.

Running the Starter Package also installs the [OpenSTLinux image](https://wiki.st.com/stm32mpu/wiki/OpenSTLinux_distribution) on the board and sets the paritions on the SD card for the file system. This **must** be done for any new SD card being used by the stm32mp1 device.

## USB Serial Link

Install libusb:

```
sudo apt-get install libusb-1.0-0
```

Move into the following CubeProgrammer folder:

```
cd $HOME/cd STMicroelectronics/STM32Cube/STM32CubeProgrammer/Drivers/rules/
```

Allow STM32CubeProgrammer to access the USB port:

```
sudo cp *.* /etc/udev/rules.d/
```

## Download the Image

Here, I will assume your workspace is inside a folder named `dev`.

```
cd $HOME/dev
```

- Download the [starter package](https://www.st.com/en/embedded-software/stm32mp1starter.html#get-software) from ST's website.
- Move the compressed download to your `dev` folder.

Uncompress:

```
tar xvf en.flash-stm32mp1-openstlinux-6.1-yocto-mickledore-mp1-v23.06.21.tar.gz
```

## Flash the Image to the SD Card

Follow the rest of ST's [ST's instructions](https://wiki.st.com/stm32mpu/wiki/Getting_started/STM32MP1_boards/STM32MP157x-DK2/Let%27s_start/Populate_the_target_and_boot_the_image), starting on section *6 Populate the SD Card*.

This [Starter Package page](https://wiki.st.com/stm32mpu/wiki/STM32MP15_Discovery_kits_-_Starter_Package) has more in-depth information. 

Once you flash the SD card, connect an HDMI cable to an external screen and press the RESET button on the board. You should be able to see the OS splash screen and desktop after a couple minutes.

This is the process for installing *any* OS image to the stm32mp1 device.

!!! tip

    Other Linux-capable devices will require a similar process. Here, ST provides us tools to flash and partition the SD card. Other vendors may or may not require you to [manually](https://www.embedded.pub/linux/tools/fdisk-partitioning.html#google_vignette) do this using Linux commands or other tools.

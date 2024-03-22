# LSM303DLHC

## Details

[Sensor Datasheet :octicons-book-16:](https://cdn-shop.adafruit.com/datasheets/LSM303DLHC.PDF){ .md-button }

![SLS 1322-3](./images/LSM303DLHC_product_pic.jpg){ width="300"; align=right }

- **Sensor**: [LSM303DLHC](https://www.adafruit.com/product/1714) Accelerometer.
    - Sensor is made by ST.
    - Breakout board is provided by Adafruit.
- **Frequency**:
- **Communication**: I2C.

## Pinout

## Firmware

[Library API Docs :material-library:](#){ .md-button }

### Calibration

- Digitally Representing 1G
- Averaged the magnitude of the sensor output for a period where it was not touched to find a correcting factor that would theoretically translate to 1.0G. After the program ran for several minutes, the average value for 1.0G was 1024. 
- Note that at this point, firmware has already been developed for converting raw data to m/s^2 and Gs
- This solution was by comparing the data read by the accelerometer to the data read from an iPhone accelerometer

### Addressing Drift
- Testing the sensor another day for drift, we found that the average output that day was less than when we first started testing than after running the accelerometer for a few minutes. 
- The correction value could change due to unknown external and internal conditions, it was decided that the sensor would need to be recalibrated during start-up and after running for certain periods of time. 
- The calibration function was created by taking the idea that an average of data taken for 100 loops while the sensor was restarted could be used as a correction value. If the minimum and maximum values of those samples had a deviation above 0.1G then the newly produced calibration factor would be thrown out on the assumption that the accelerometer is moving, and the calculated gravitational correction factor is incorrect. The calculated factor will then be thrown out and a predetermined default value will be used.
- This calibration value is produced by dividing the averaged array by the amount of samples as a conversion factor to "raw data per single G-force".

### How to Use

!!! example
    How to initialize the `LSM303DLHC` object and read the acceleration of each axis by interacting with the `IAccelerometer` interface.

```c++
#include <iostream>
#include <memory>
#include "mbed.h"
#include "../iaccelerometer.hpp"
#include "../accelerometer_lsm303dlhc.hpp"

int main() {
    float* acceleration = nullptr;
    std::unique_ptr<adapter::IAccelerometer> accelerometer
        = std::make_unique<adapter::Accelerometer_LSM303DLHC>(I2C_SDA, I2C_SCL);

    accelerometer->init();

    while (true) {
        accelerometer->ComputeAcceleration();
        acceleration = accelerometer->GetAcceleration();

        //accelerometer values must be 
        std::cout << "ACC:" << 
                     "\tX: " << acceleration[0] <<
                     "\tY: " << acceleration[1] <<
                     "\tZ: " << acceleration[2] << std::endl;
        
        ThisThread::sleep_for(500ms);
    }
}
```

# Architecture Overview

This codebase utilizes the Layered Architecture. In practice, this is reflected in the firmware by separating each layer with folder directories and C++ namespaces while encouraging loosed coupling between components.

## Application Layer
  - High-level code.
  - Will mostly consist of logic rather than nitty-gritty details.
  - Will not be constrained to a particular product.

## Sensor Layer
  - Low-level code.
  - Consists of drivers. That is, libraries to support sensors and external devices.
  - Product-specific code.

## Platform Layer
  - Low-level code.
  - Access to microcontroller peripherals.
  - Platform-specific code. Such as, making use of I2C on an STM32 with the HAL library vs. on a TI microcontroller.

## Diagrams

```mermaid
---
title: Simplified Architecture Diagram
---
classDiagram
direction TB

namespace Application Layer {
    class DAQ {
        bool file_is_open
        char file_name_[16]
        char write_buffer
        uint8_t status
        void Init()
        void Read()
        void Write()
    }

    class IDataLogger {
        <<interface>>
        char write_buffer_;

        uint8_t Mount(BlockDevice*)*
        uint8_t Unmount()*
        uint8_t FileOpen(char*)*
        uint8_t FileClose()*
        uint8_t FileWrite(cost char*)*
    }
}

namespace SensorLayer {
    class IEcu {
        <<interface>>
    }

    class IAccelerometer {
        <<interface>>
        GetAcceleration()*
        ComputeAcceleration()*
    }

    class GenericSensor {
        <<interface>>
    }
}

namespace Platform Layer {
    class ISpi {
        <<interface>>
    }

    class IUsb {
        <<interface>>
    }

    class ICan {
        <<interface>>
    }

    class II2c {
        <<interface>>
    }

    class GenericPeripheral {
        <<interface>>
    }
}
        
DAQ --> IDataLogger
DAQ --> IAccelerometer
DAQ --> GenericSensor

IEcu --> ICan
IDataLogger --> ISpi
IDataLogger --> IUsb
IAccelerometer --> II2c
GenericSensor --> GenericPeripheral

end
```

!!! note

    This diagram is simplified by removing the concrete/implementation classes. In reality, the concrete classes (i.e., the implementation of the abstract interfaces) utilize the abstract interfaces of the Platform layer. For instance, a specific implementation of the Accelerometer (not `IAccelerometer`) may utilize the `II2C` interface.

    The complete, more accurate illustration of the architecture is shown below.

Coming soon...

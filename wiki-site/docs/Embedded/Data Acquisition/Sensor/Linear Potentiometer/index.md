# Suspension Travel Potentiometers

This page was last updated: *{{ git_revision_date_localized }}*

## Description

* **Stakeholder**: Suspension lead
* **Use Case**: Reading the displacement to measure measure the suspension travel and shock absorption. A total of 4 potentiometers must be mounted on the vehicle.

## Supported Sensors

```mermaid
classDiagram

namespace SensorLayer {
    class ILinearPotentiometer {
        <<interface>> 
        +DisplacementInches()* float
        +DisplacementMillimeters()* float
    }

    class SLS1322 { }
}

namespace Platform Layer {
    class IAdc {
        <<interface>>
    }
}

ILinearPotentiometer <-- SLS1322
SLS1322 ..> IAdc

link SLS1322 "SLS_1322-3/"

end
```
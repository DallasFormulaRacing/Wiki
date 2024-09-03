# File Structure

## Overall Repo
* The `DAQ_System` folder will be the workspace intended to be the final deliverable. This is the actual codebase we are working towards.

```mermaid
flowchart LR
    %% Colors %%
    classDef blue fill:#66deff,stroke:#000,color:#000
    classDef green fill:#6ad98b,stroke:#000,color:#000
    classDef yellow fill:#f2d994,stroke:#000,color:#000

    root["DataAcquisition2.0"]-->Project("Project")
    Project-->DAQ_System("DAQ_System")
    Project-->Docs;
    Project-->Tests
    

    subgraph DAQ_System Workspace
        direction LR
        DAQ_System:::blue
        DAQ_System-->Source("Program/Src")
        Source-->Application("Application")
        Source-->Sensor("Sensor")
        Source-->Platform("Platform")
        Source-->DAQ_Main("app.cpp"):::green
    end

```
#### Legend
* Blue — Root of the workspace
* Green — Main file of the workspace

## DAQ_System Workspace
```mermaid
flowchart LR
    %% Colors %%
    classDef blue fill:#66deff,stroke:#000,color:#000
    classDef green fill:#6ad98b,stroke:#000,color:#000
    classDef yellow fill:#f2d994,stroke:#000,color:#000

    DAQ_System:::blue
    DAQ_System-->Source("Program/Src")

    Source-->Application("Application")
    Source-->Sensor("Sensor")
    Source-->Platform("Platform")
    Source-->DAQ_Main("app.cpp"):::green
    
    Application-->Application_Interfaces("Interfaces")
    Application-->Application_Logging("Logging"):::yellow
    Application-->Application_Concurrency("Concurrency"):::yellow

    Sensor-->Sensor_Interfaces("Interfaces")
    Sensor-->Sensor_Ecu("ECU_Model_xxx")-->Sensor_Acc_Lib("ECU Low-Level Library Code"):::yellow

    
    Platform-->Platform_Interfaces("Interfaces")
    Platform-->Platform_Can("CAN Protocol")-->Platform_Dependent_Code("Platform (Board) Dependent Code"):::yellow
    Platform-->Abstracted_Peripherals("Abstracted Peripherals"):::yellow

```

#### Legend
* Blue — Root of the workspace
* Green — Main file of the workspace
* Yellow — Key differences among the layers of code
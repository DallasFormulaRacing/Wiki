# Mutex

## Description

- Functions as a typical mutex.
- If the shared resource is not available, the requesting thread is put into a blocked state.
- Conforms to the `IMutex` interface to work with the `CircularQueue` and `DataPayload`.

### Firmware Component Library

[Library API Docs :material-library:](#){ .md-button }

[Source Code :material-file-code:](hhttps://github.com/DallasFormulaRacing/DAQ-Firmware-Libraries/blob/2c4a025f68137ac56061339a43fcc1cc42d8c74e/Application/Mutex/mutex_cmsisv2.hpp){ .md-button }

!!! info
    This is a common data structure. You can find plenty of information online, such as Shawn Hymel's [Introduction to RTOS - Mutex](https://www.youtube.com/watch?v=I55auRpbiTs).


!!! warning
    Note that CMSIS-RTOS V2 wrapper class implementation must be created **after** calling `osKernelInitalize()`. For this reason, this implementation has a separate `Create()` method.

!!! example
    Creating a mutex.

    ```C++
    #include "../DFR_Libraries/Application/Mutex/mutex_cmsisv2.hpp"

    const osMutexAttr_t mutex_attributes = {
        "myThreadMutex",
        osMutexRecursive | osMutexPrioInherit,
        NULL,
        0U
    };

    auto m = std::make_shared<application::MutexCmsisV2>(mutex_attributes);


    int main() {
        osKernelInitialize();
        m->Create();

        // Request to use resource shared with other thread
        m->Lock();

        // ...
        // Use the shared resource

        // Release the shared resource for other threads to use
        m->Unlock();

        return 0;
    }
    ```


For more examples, the firmware currently uses two mutexes to share the `CircularQueue` and `DataPayload` among multiple threads.
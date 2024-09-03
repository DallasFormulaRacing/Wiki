# Circular Queue

## Description

- Functions as a regular queue.
- When full, the next new entry overwrites the oldest entry.
- Implemented with C++ generics to support any data type.
- The following functionalities are supported:
    - Inserting
    - Removing
    - Checking whether it is empty or full
    - Clearing
    - Locking and unlocking an internal mutex


### Firmware Component Library

[Library API Docs :material-library:](#){ .md-button }

[Source Code :material-file-code:](https://github.com/DallasFormulaRacing/DAQ-Firmware-Libraries/blob/main/Application/circular_queue.hpp){ .md-button }

!!! info
    This is a common data structure. You can find plenty of information online, such as GeeksForGeek's [Introduction to Circular Queue](https://www.geeksforgeeks.org/introduction-to-circular-queue/).

!!! example
    Creating a circular queue of integers.

    ```C++
    #include "../DFR_Libraries/Application/circular_queue.hpp"

    int main() {
        int size = 5;
        pplication::CircularQueue<int> queue(size);

        queue.Enqueue(8);
        queue.Enqueue(2);
        queue.Enqueue(11);
        queue.Enqueue(9);
        queue.Enqueue(4);

        if (queue.IsFull()) {
            printf("Queue is full!\n");
        }

        // Overwrite entry of number 8
        queue.Enqueue(33);

        return 0;
    }
    ```


!!! example
    Creating a circular queue of `DataPayload`s.

    ```C++
    #include "../DFR_Libraries/Application/circular_queue.hpp"
    #include "../DFR_Libraries/Application/data_payload.hpp"

    int main() {
        int size = 5;
        pplication::CircularQueue<application::DataPayload> queue(size);

        DataPayload data;
        data.timestamp_ = 2.0f;

        // Insert a copy of the data payload at this instant
        queue.Enqueue(data);

        if (!queue.IsEmpty()) {
            // Receive from the queue
            DataPayload data = queue.Dequeue();
            printf("Timestamp: %f\n", data.timestamp_);
        }

        return 0;
    }
    ```

The `CircularQueue` also has an additional constructor for accepting a mutex, if this were to be used as a shared component among threads in an RTOS environment.

!!! example
    Sharing a circular queue between threads using FreeRTOS through CMSIS-RTOS v2.

    Assume that the Kernel is already initialized and running.

    ```C++
    #include "../DFR_Libraries/Application/circular_queue.hpp"
    #include "../DFR_Libraries/Application/data_payload.hpp"

    const osMutexAttr_t queue_mutex_attributes = {
        "myThreadMutex",
        osMutexRecursive | osMutexPrioInherit,
        NULL,
        0U
    };

    auto mutex = std::make_shared<application::MutexCmsisV2>(queue_mutex_attributes);

    int size = 5;
    application::CircularQueue<int> queue(size, mutex);

    void ProducerThread() {
        int num = 2;

        for(;;) {
            num *= 2;

            queue.Lock();
            queue.Enqueue(num);
            queue.Unlock();
        }
    }

    void ConsumerThread() {
        for(;;) {
            queue.Lock();
            int received_num = queue.Dequeue();
            queue.Unlock();

            printf("Received: %d\n", received_num);
        }
    }
    ```
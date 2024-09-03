# Data Payload

## Description

- A simple struct that collects data across the DAQ.
- A centralized point of providing newly updated data.
- Converts all fields to a null-terminated string in the CSV format.
- Provides what the length of the string may be. This is useful for dynamically allocating a buffer before converting the data to a string. A size is necessary when creating the buffer.
- Has an additional constructor for accepting a mutex if to be used as a shared component among threads.

[Library API Docs :material-library:](#){ .md-button }

[Source Code :material-file-code:](https://github.com/DallasFormulaRacing/DAQ-Firmware-Libraries/blob/main/Application/data_payload.hpp){ .md-button }

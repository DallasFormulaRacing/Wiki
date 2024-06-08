# Timing and Concurrency

Coming soon...



## Hardware Timers

if 168 mhz
	ARR = 64515
	Prescaler = 5207

	2 sec (168 mhz / 8000)

if 84 MHz
	ARR = 64515
	Prescaler = 2603
	


if 42 MHz
	ARR = 64515
	Prescaler = 1301
	



The larger the prescaler, the slower the clock frequency and the longer time we can measure.
[Time][Clock rate after bus prescaling] = steps or ticks

steps / clock rate = time

Inc both prescaler and steps -> longer time

## RTOS


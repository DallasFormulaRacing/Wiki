# Environment Troubleshooting

This page was last updated: *{{ git_revision_date_localized }}*

## Error when trying to flash the board (run/debug): No ST-LINK detected! Reconnect
- Not to be confused with build/clean
- Restart the ST-LINK server. For me, this was found in the following Windows directory: `C:\ST\STM32CubeCLT\STLinkServer\st-link-server.2.1.1-1.msi`

## Error in initializing st link device. Reason: st-link dll error
* Download stm32 Cube Programmer
* On the ST-LINK configuration area:
  * Click the refresh button for the Serial Number field
  * Mode: Under reset
  * Reset mode: Core reset
* Click Firmware Upgrade
* A pop-up window will appear to upgrade ST-Link on your dev board — go ahead and upgrade. This will be successful after the red & green debugging lights are done flashing

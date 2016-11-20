# HydroPal: iOS Branch

## Description
An iOS app that allows communication between the HydroPal intelligent water bottle and a device running iOS.

## Current Functionality
- [x] Bluetooth communication using the HM-10 module
- [x] Ability to log water consumption
- [x] Sends latest date time data to the Arduino
- [x] Settings to change reminder times etc. on the Arduino

## To-do

- [ ] Calculate recommended water intake values
- [ ] Parse multiple day data
- [ ] Reset total water counter at 12:00 AM and save to yesterday's data
- [ ] Nicer UI

## Credit
@hoiberg's Bluetooth serial helper class found here: https://github.com/hoiberg/swiftBluetoothSerial

## Changelog
### Release 1.0
- Bluetooth functionality implemented
- Sends data to Arduino
- Parses water consumed from Arduino
- Persistent settings

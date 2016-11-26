# HydroPal: iOS Branch
<img src="https://raw.githubusercontent.com/Hydropal/Hydropal-iOS/master/img/dashboard.png" width="45%"></img> <img src="https://raw.githubusercontent.com/Hydropal/Hydropal-iOS/master/img/settings.png" width="45%"></img> 


## Description
An iOS app that allows communication between the HydroPal intelligent water bottle and a device running iOS.

## Current Functionality
- [x] Bluetooth communication using the HM-10 module
- [x] Ability to log water consumption
- [x] Sends latest date time data to the Arduino
- [x] Settings to change reminder times etc. on the Arduino
- [x] Calculate recommended water intake values
- [x] Parse multiple day data

## To-do
- [ ] Reset total water counter at 12:00 AM and save to yesterday's data
- [ ] Sync on settings update
- [ ] Persistent volume
- [ ] Working iPad UI
- [ ] Fix sex selection

## Credit
@hoiberg's Bluetooth serial helper class found here: https://github.com/hoiberg/swiftBluetoothSerial

## Changelog
### Alpha 2.0
- Multi-day sync (past four days)
- Calculate recommended water intake
- Much prettier UI

### Alpha 1.0
- Bluetooth functionality implemented
- Sends data to Arduino
- Parses water consumed from Arduino
- Persistent settings

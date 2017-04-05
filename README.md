# Hydropal: iOS
An iOS app that allows communication between the Hydropal intelligent water bottle and a device running iOS.
<img src="https://raw.githubusercontent.com/Hydropal/Hydropal-iOS/develop/img/dashboard.png" width="49%"></img> </img> <img src="https://raw.githubusercontent.com/Hydropal/Hydropal-iOS/develop/img/settings.png" width="49%"></img>

<img src="https://raw.githubusercontent.com/Hydropal/Hydropal-iOS/develop/img/serial_setup.png" width="16%"></img> <img src="https://raw.githubusercontent.com/Hydropal/Hydropal-iOS/develop/img/sex_setup.png" width="16%"></img> </img> <img src="https://raw.githubusercontent.com/Hydropal/Hydropal-iOS/develop/img/birthday_setup.png" width="16%"></img> </img> <img src="https://raw.githubusercontent.com/Hydropal/Hydropal-iOS/develop/img/wake_setup.png" width="16%"></img> <img src="https://raw.githubusercontent.com/Hydropal/Hydropal-iOS/develop/img/sleeptime_setup.png" width="16%"></img> <img src="https://raw.githubusercontent.com/Hydropal/Hydropal-iOS/develop/img/help_setup.png" width="16%"></img> </img> 

## Current Functionality
- [x] Bluetooth communication using the HM-10 module
- [x] Ability to log water consumption
- [x] Sends latest date time data to the Arduino
- [x] Settings to change reminder times etc. on the Arduino
- [x] Calculate recommended water intake values
- [x] Parse multiple day data
- [x] Reset total water counter at 12:00 AM and save to yesterday's data
- [x] Persistent volume
- [x] Set up screens with birthday selection and serial numbers
- [x] Working iPad UI
- [x] Reminds for sync on settings update
- [x] Animated sync icon
- [x] Device attempts to sync multiple times

## To-do
- [ ] Chinese localisation
- [ ] Option to disable update setting sync reminder permanently

## Credit
@hoiberg's Bluetooth serial helper class found here: https://github.com/hoiberg/swiftBluetoothSerial
 
## Changelog
### Release 1.1.1
- Animated sync button
- Device attempts to sync multiple times
- Reminds user to sync if settings changed that only updates on sync
- 🐞 Fixed wake and sleep times breaking when locale is not en_US

### Alpha 5.0
- UI should be iPad friendly now
- UI is also friendly with smaller devices such as the iPhone 5
- Added status bar fade animations to make transitions less awkward

### Alpha 4.0
- Fully functional setup screens
- Implemented help screen
- Finally fixed sex selection

### Alpha 3.0
- Persistent volume
- Shifts volume as day changes
- Wake and sleep times now work

### Alpha 2.0
- Multi-day sync (past four days)
- Calculate recommended water intake
- Much prettier UI

### Alpha 1.0
- Bluetooth functionality implemented
- Sends data to Arduino
- Parses water consumed from Arduino
- Persistent settings

//
//  HomeViewController.swift
//  HydroPal
//
//  Created by Shao Qian MAH on 15/11/2016.
//  Copyright © 2016 Hydropal. All rights reserved.
// TO-DO:
// Reset at 12
// Parse multiple day data

import Foundation
import UIKit
import CoreBluetooth

let storyboard = UIStoryboard(name: "Main", bundle: nil)

class HomeViewController: UIViewController, BluetoothSerialDelegate, CALayerDelegate, CAAnimationDelegate {
    
    
    //Goal label, i.e. "of 3700 ml"
    @IBOutlet weak var goalLabel: UILabel!
    
    // Circle outlets
    @IBOutlet weak var goalView0: UIView!
    @IBOutlet weak var goalView1: UIView!
    @IBOutlet weak var goalView2: UIView!
    @IBOutlet weak var goalView3: UIView!
    
    // Labels with actual volumes
    @IBOutlet weak var volumeLabel1: UILabel!
    @IBOutlet weak var volumeLabel2: UILabel!
    @IBOutlet weak var volumeLabel3: UILabel!
    @IBOutlet weak var volumeLabel4: UILabel!
    
    
    @IBOutlet weak var syncButton: UIButton!
    
    @IBAction func clickSyncButton(_ sender: Any) {
        buttonEnabled = false
        bluetoothSync()
    }
    
    /// The peripherals that have been discovered (no duplicates and sorted by asc RSSI)
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = [] {
        didSet {
            // Triggers on array change
            let peripheralName = "Hydropal" + defaults.string(forKey: "serial")!
            for i in 0..<peripherals.count {
                if peripherals[i].peripheral.name == peripheralName {
                    serial.stopScan()
                    serial.connectToPeripheral(peripherals[i].peripheral) // Connects to peripheral with name that is "Hydropal"
                    
                    //Reset scanned peripherals
                    peripherals = []
                    
                    //Schedule connection error alert
                    Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(HomeViewController.connectTimeOut), userInfo: nil, repeats: false)
                }
            }
        }
    }
    
    // Variable to check if serial recently disconnected
    
    var serialDisconnected : Bool = false
    
    var serialNominalDisconnect : Bool = false
    
    var goal : Int = 0
    
    var serialString: String = ""
    
    var volumeString: String = ""
    
    var arrayShift: Bool = false
    
    var loopCounter = 0
    
    var isRotating = false
    var shouldStopRotating = false
    var timer: Timer!
    var connectTimer: Timer!

    
    var buttonEnabled = true {
        didSet {
            if buttonEnabled == true {
                syncButton.isEnabled = true
                shouldStopRotating = true
                
            } else {
                shouldStopRotating = false
                self.syncButton.isEnabled = false
                if isRotating == false {
                    syncButton.rotate360Degrees(completionDelegate: self)
                    self.isRotating = true
                }
            }
        }
    }
    
    func animationDidStop(_ anim: CAAnimation, finished flag: Bool) {
        if shouldStopRotating == false {
            syncButton.rotate360Degrees(completionDelegate: self)
        } else {
            self.reset()
        }
    }
    
    func reset() {
        self.isRotating = false
        self.shouldStopRotating = false
    }
    
    var volumeArray = ["0","0","0","0"] {
        didSet {
            volumeLabel1.text = "\(volumeArray[3]) ml"
            volumeLabel2.text = volumeArray[2]
            volumeLabel3.text = volumeArray[1]
            volumeLabel4.text = volumeArray[0]
            
            refreshGoals()
            
            // Save changes to array
            UserDefaults.standard.set(volumeArray, forKey: "volumeArray")
        }
    }
    
    let screenSize = UIScreen.main.bounds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init serial
        serial = BluetoothSerial(delegate: self)
        serial.writeType = .withResponse // This HM-10 module requires it
        
        // get array and set to volumeArray
        let savedArray = UserDefaults.standard.stringArray(forKey: "volumeArray")
        volumeArray = savedArray!
        
        // set up every 1 second timer
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(HomeViewController.checkTime), userInfo: nil, repeats: true)
        
        // trigger sync
        bluetoothSync()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        // refresh goals
        refreshGoals()
        
        if defaults.bool(forKey: "needSync") == true {
            // Settings updated
            
            let alert = UIAlertController(title: "Settings updated", message: "Some of the settings you changed will only take effect in the next sync", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            }
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true) {
            }
        } else {
            // do nothing
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshGoals() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let calendar : NSCalendar = NSCalendar.current as NSCalendar
        
        let birthday = dateFormatter.date(from: defaults.string(forKey: "birthday")!)
        let now = NSDate()
        
        let ageComponents = calendar.components(.year, from: birthday!, to: now as Date, options: [])
        let age: Int = ageComponents.year!
        
        if defaults.bool(forKey: "customGoalSwitch") == true {
            goal = Int(defaults.string(forKey: "customGoal")!)!
        } else {
            if defaults.string(forKey: "selectedSex") == "Male" /* male */ {
                
                switch age {
                case 0..<3:
                    goal = 1300
                case 3..<8:
                    goal = 1700
                case 8..<13:
                    goal = 2400
                case 13..<18:
                    goal = 3300
                case 18..<150:
                    goal = 3700
                default:
                    goal = 3700
                }
                
            } else /* female */ {
                
                switch age {
                case 0..<3:
                    goal = 1300
                case 3..<8:
                    goal = 1700
                case 8..<13:
                    goal = 2100
                case 13..<18:
                    goal = 2300
                case 18..<150:
                    goal = 2700
                default:
                    goal = 2700
                }
                
            }
        }
        
        goalLabel.text = "of \(String(goal)) ml"
        var goalFraction0: Double = Double(volumeArray[3])! / Double(goal)
        var goalFraction1: Double = Double(volumeArray[2])! / Double(goal)
        var goalFraction2: Double = Double(volumeArray[1])! / Double(goal)
        var goalFraction3: Double = Double(volumeArray[0])! / Double(goal)
        
        // If 0.0, won't be visible, so make it tiny
        if goalFraction0 == 0.0 {
            goalFraction0 = 0.01
        }
        if goalFraction1 == 0.0 {
            goalFraction1 = 0.01
        }
        if goalFraction2 == 0.0 {
            goalFraction2 = 0.01
        }
        if goalFraction3 == 0.0 {
            goalFraction3 = 0.01
        }
        
        drawCircles(fraction: goalFraction0, subView: goalView0, staticColor: hexStringToUIColor(hex: "#3F4651"),adaptColor: hexStringToUIColor(hex: "#19B9C3"), strokeWidth: Int(Double(screenSize.width) * 0.033))
        drawCircles(fraction: goalFraction1, subView: goalView1, staticColor: hexStringToUIColor(hex: "#3F4651"),adaptColor: hexStringToUIColor(hex: "#19B9C3"), strokeWidth: Int(Double(screenSize.width) * 0.015))
        drawCircles(fraction: goalFraction2, subView: goalView2, staticColor: hexStringToUIColor(hex: "#3F4651"),adaptColor: hexStringToUIColor(hex: "#19B9C3"), strokeWidth: Int(Double(screenSize.width) * 0.015))
        drawCircles(fraction: goalFraction3, subView: goalView3, staticColor: hexStringToUIColor(hex: "#3F4651"),adaptColor: hexStringToUIColor(hex: "#19B9C3"), strokeWidth: Int(Double(screenSize.width) * 0.015))
        
        
    }
    
    // Check if there is a day change and shift array
    func checkTime() {
        let defaults = UserDefaults.standard
        let dateFormatter = DateFormatter()
        let calendar = Calendar(identifier: .gregorian)
        
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        // Set last quit date to 12:00 am to compare 12:00 of next day
        let lastQuitString = defaults.string(forKey: "lastQuitDate")!
        let lastQuitDate = dateFormatter.date(from: lastQuitString)
        let startOfLastQuitString: String = String(describing: calendar.startOfDay(for: lastQuitDate!))
        let startOfLastQuitDate = dateFormatter.date(from: startOfLastQuitString)
        
        // Find days since last quit
        let daysSinceLastQuit = (Calendar.current.dateComponents([.day], from: startOfLastQuitDate!, to: Date()).day!)
        var localVolumeArray = defaults.stringArray(forKey: "volumeArray")
        
        if daysSinceLastQuit < 1 {
            // Don't shift
        } else if daysSinceLastQuit >= 1 && daysSinceLastQuit < 2 {
            // Shift one
            localVolumeArray![0] = localVolumeArray![1]
            localVolumeArray![1] = localVolumeArray![2]
            localVolumeArray![2] = localVolumeArray![3]
            localVolumeArray![3] = "0"
        } else if daysSinceLastQuit >= 2 && daysSinceLastQuit < 3 {
            // Shift twice
            localVolumeArray![0] = localVolumeArray![2]
            localVolumeArray![1] = localVolumeArray![3]
            localVolumeArray![2] = "0"
            localVolumeArray![3] = "0"
        } else if daysSinceLastQuit >= 3 && daysSinceLastQuit < 4 {
            // Shift thrice
            localVolumeArray![0] = localVolumeArray![3]
            localVolumeArray![1] = "0"
            localVolumeArray![2] = "0"
            localVolumeArray![3] = "0"
        } else if daysSinceLastQuit >= 4 {
            // Shift four times
            localVolumeArray![0] = "0"
            localVolumeArray![1] = "0"
            localVolumeArray![2] = "0"
            localVolumeArray![3] = "0"
        } else {
            // Do nothing
        }
        defaults.set(localVolumeArray, forKey: "volumeArray")
        
        let dateString = dateFormatter.string(from: Date())
        
        defaults.set(dateString, forKey: "lastQuitDate")
        volumeArray = localVolumeArray!
        
        
    }
    
    func drawCircles(fraction: Double, subView: UIView, staticColor: UIColor, adaptColor: UIColor, strokeWidth: Int) {
        subView.layer.sublayers?.forEach {
            $0.removeFromSuperlayer()
        }
        
        //Static circle
        let staticCirclePath = UIBezierPath(arcCenter: CGPoint(x: subView.bounds.size.width / 2 ,y: subView.bounds.size.height / 2), radius: CGFloat(subView.bounds.size.width / 2), startAngle: CGFloat(-Double.pi / 2), endAngle:CGFloat(Double.pi * 2 * 1 - Double.pi/2), clockwise: true)
        
        let staticLayer = CAShapeLayer()
        staticLayer.path = staticCirclePath.cgPath
        
        //change the fill color
        staticLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        staticLayer.strokeColor = staticColor.cgColor
        //you can change the line width
        staticLayer.lineWidth = CGFloat(strokeWidth)
        
        subView.layer.addSublayer(staticLayer)
        
        //Adaptive circle
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: subView.bounds.size.width / 2 ,y: subView.bounds.size.height / 2), radius: CGFloat(subView.bounds.size.width / 2), startAngle: CGFloat(-Double.pi/2), endAngle:CGFloat(Double.pi * 2 * fraction - Double.pi/2), clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        
        //change the fill color
        circleLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        circleLayer.strokeColor = adaptColor.cgColor
        //you can change the line width
        circleLayer.lineWidth = CGFloat(strokeWidth)
        
        subView.layer.addSublayer(circleLayer)
    }
    
    //Allows hex colour to be turned into a UIColor object
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
// MARK: Bluetooth functions
    
    func bluetoothSync() {
        if serial.centralManager.state != .poweredOn {
            buttonEnabled = true
            let alert = UIAlertController(title: "Turn on Bluetooth", message: "Turn on Bluetooth to sync with Hydropal", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            }
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true) {
            }
        } else {
            serial.startScan()
            serialDisconnected = false
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.scanTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    /// Should be called 5s after we've begun scanning
    
    func scanTimeOut() {
        // if peripheral is connected do nothing
        if let _ = serial.connectedPeripheral {
        // if peripheral recently disconnected do nothing
        } else if serialDisconnected == true {
        } else {
        // otherwise, timeout has occurred, stop scanning and give the user the option to try again
        serial.stopScan()
        let alert = UIAlertController(title: "Hydropal not found", message: "Your Hydropal water bottle could not be found, please bring your bottle closer or charge it and retry", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        self.present(alert, animated: true) {}
        }

        buttonEnabled = true
        
    }
    
    /// Find Bluetooth peripherals
    func serialDidDiscoverPeripheral(_ peripheral: CBPeripheral, RSSI: NSNumber?) {
        // check whether it is a duplicate
        for exisiting in peripherals {
            if exisiting.peripheral.identifier == peripheral.identifier { return }
        }
        
        // add to the array, next sort & reload
        let theRSSI = RSSI?.floatValue ?? 0.0
        peripherals.append(peripheral: peripheral, RSSI: theRSSI)
        peripherals.sort { $0.RSSI < $1.RSSI }
    }
    
    /// Should be called 3s after we've begun connecting
    func connectTimeOut() {
        
        // don't if we've already connected (if connectedPeripheral does not = nil)
        if let _ = serial.connectedPeripheral {
            return
        }
        
        // don't if serial recently disconnected
        if serialDisconnected == true {
            return
        }
        
        // this runs if connection timed out
        let alert = UIAlertController(title: "Connection timed out", message: "Could not connect to your Hydropal water bottle, please retry", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        self.present(alert, animated: true) {
        }
        buttonEnabled = true
    }
    
    // Called when Serial is ready to communicate
    
    func serialIsReady(_ peripheral: CBPeripheral) {
        connectTimer = Timer.scheduledTimer(timeInterval: 1.6, target: self, selector: #selector(HomeViewController.connect), userInfo: nil, repeats: true)
    }
    
    // Called when Serial gets message
    
    func connect() {
        if loopCounter < 8 {
            let currentDate = NSDate()
            let timeFormatter = DateFormatter()
            
            // Formats time to Arduino readable format -> hours,minutes,seconds,days,months,years
            timeFormatter.dateFormat = "H,m,s,d,M,yyyy"
            
            let dateString = timeFormatter.string(from: currentDate as Date)
            
            // Get user defaults
            let bottleState = defaults.bool(forKey: "bottleState")
            var bottleStateString: String = "ON"
            if bottleState {
                bottleStateString = "ON"
            } else {
                bottleStateString = "OFF"
            }
            let ledSwitchState = defaults.bool(forKey: "ledSwitch")
            var remindersState: String = "ON"
            if ledSwitchState == true {
                remindersState = "ON"
            } else {
                remindersState = "OFF"
            }
            
            let reminderTime = defaults.string(forKey: "reminderTime")
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let wakeDate = dateFormatter.date(from: defaults.string(forKey: "wakeTime")!)
            let sleepDate = dateFormatter.date(from: defaults.string(forKey: "sleepTime")!)
            
            let wakeSleepFormatter = DateFormatter()
            wakeSleepFormatter.dateFormat = "H,m"
            wakeSleepFormatter.calendar = Calendar(identifier: .iso8601)
            wakeSleepFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let wakeString = wakeSleepFormatter.string(from: wakeDate!)
            let sleepString = wakeSleepFormatter.string(from: sleepDate!)
            
            serial.sendMessageToDevice("<\(dateString),\(remindersState),\(reminderTime!),\(wakeString),\(sleepString),\(self.volumeArray[3]),\(self.volumeArray[2]),\(self.volumeArray[1]),\(self.volumeArray[0]),\(bottleStateString)>")
            loopCounter += 1
            print("try no: \(loopCounter)")
            
            buttonEnabled = false
        } else {
            // Loop count exceeded
            // Disconnect and sync failed
            serialNominalDisconnect = false
            serial.disconnect()
            print("loop finished")
            loopCounter = 0
            connectTimer.invalidate()
            connectTimer = nil
            
            buttonEnabled = true
        }
    }
    
    func serialDidReceiveString(_ message: String) {
        if message.contains(">") {
            //stop connect loop
            connectTimer.invalidate()
            connectTimer = nil
            loopCounter = 0
            
            //settings have been synced to Hydropal
            defaults.set(false, forKey: "needSync")
            
            // Message has ended, process packet
            serialString += message
            print(serialString)
            serialNominalDisconnect = true
            serial.disconnect()
            
            let letters = serialString.characters.map { String($0) } // turns message string into array
            var startIndex:Int = 0
            var endIndex:Int = 0
            var volumeArrayEdit = ["0", "0", "0", "0"]
            volumeString = ""
            
            // Find start and end packet
            for i in 0..<letters.count {
                //Find start packet
                if letters[i] == "<" {
                    startIndex = i
                    //Find end packet
                } else if letters [i] == ">" {
                    endIndex = i
                } else {
                    // random packet data
                }
            }

            // Process packet
            for i in startIndex + 1..<endIndex {
                // Adds non-start and end packet chars to volume string
                volumeString = volumeString + letters[i]
            }
            
            // Update with array
            volumeArrayEdit = volumeString.components(separatedBy: ",")
            volumeArray = volumeArrayEdit
            serialString = ""
            
            // Enable syncButton
            buttonEnabled = true
        } else {
            connectTimer.invalidate()
            loopCounter = 0
            
            // Packet is incomplete
            serialString += message
            print(serialString)
            // Add function to check if packet incomplete for more than 3 seconds
        }
    }
    
    /// Called when the state of the CBCentralManager changes (e.g. when Bluetooth is turned on/off)
    func serialDidChangeState() {
        
    }
    
    /// Called when a peripheral disconnected
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        serialDisconnected = true
        if serialNominalDisconnect == true {
            // do nothing, everything is fine!
        } else {
            // Uh-oh Hydropal randomly disconnected
            let alert = UIAlertController(title: "Sync failed", message: "The sync failed, please try to sync again", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            }
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true) {
            }
            buttonEnabled = true
        }
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    @IBAction func settingstoHome(segue:UIStoryboardSegue) {
        // refresh goals when Home is shown
        refreshGoals()
        
    }
}

extension String {
    func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
}


//
//  HomeViewController.swift
//  HydroPal
//
//  Created by Shao Qian MAH on 15/11/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
// TO-DO:
// Reset at 12
// Parse multiple day data

import UIKit
import CoreBluetooth

final class HomeViewController: UIViewController, BluetoothSerialDelegate {
    
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var goalLabel: UILabel!
    
    @IBOutlet weak var goalView1: UIView!
    
    @IBOutlet weak var syncButton: UIButton!
    
    @IBAction func clickSyncButton(_ sender: Any) {
        if serial.centralManager.state != .poweredOn {
            let alert = UIAlertController(title: "Turn on Bluetooth", message: "Turn on Bluetooth to sync with Hydropal", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true) {
            }
        } else {
            serialDisconnected = false
            serial.startScan()
            Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(HomeViewController.scanTimeOut), userInfo: nil, repeats: false)
        }
    }
    
    /// The peripherals that have been discovered (no duplicates and sorted by asc RSSI)
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = [] {
        didSet {
            // Triggers on array change
            for i in 0..<peripherals.count {
                if peripherals[i].peripheral.name == "Hydropal" {
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
    
    var goal : Int = 0
    
    var volumeString:String = "1500"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init serial
        serial = BluetoothSerial(delegate: self)
        serial.writeType = .withResponse // This HM-10 module requires it
        
        refreshGoals()
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func refreshGoals() {
        let defaults = UserDefaults.standard
        if defaults.bool(forKey: "customGoalSwitch") == true {
            goal = Int(defaults.string(forKey: "customGoal")!)!
        } else {
            if defaults.string(forKey: "selectedSex") == "Male" {
                goal = 3700
            } else {
                goal = 2700
            }
        }
        goalLabel.text = "of \(String(goal)) ml"
        let volumeInt: Double = Double(volumeString)!
        var goalFraction: Double = volumeInt / Double(goal)
        
        // If 0.0, won't be visible, so make it tiny
        if goalFraction == 0.0 {
            goalFraction = 0.01
        }
        
        //Static circle
        let staticCirclePath = UIBezierPath(arcCenter: CGPoint(x: goalView1.bounds.size.width / 2 ,y: goalView1.bounds.size.height / 2), radius: CGFloat(goalView1.bounds.size.width / 2), startAngle: CGFloat(-M_PI_2), endAngle:CGFloat(M_PI * 2 * 1 - M_PI_2), clockwise: true)
        
        let staticLayer = CAShapeLayer()
        staticLayer.path = staticCirclePath.cgPath
        
        //change the fill color
        staticLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        staticLayer.strokeColor = UIColor.lightGray.cgColor
        //you can change the line width
        staticLayer.lineWidth = 10.0
        
        goalView1.layer.addSublayer(staticLayer)
        
        //Adaptive circle
        
        let circlePath = UIBezierPath(arcCenter: CGPoint(x: goalView1.bounds.size.width / 2 ,y: goalView1.bounds.size.height / 2), radius: CGFloat(goalView1.bounds.size.width / 2), startAngle: CGFloat(-M_PI_2), endAngle:CGFloat(M_PI * 2 * goalFraction - M_PI_2), clockwise: true)
        
        let circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        
        let lightBlue = hexStringToUIColor(hex: "#19B9C3")
        
        //change the fill color
        circleLayer.fillColor = UIColor.clear.cgColor
        //you can change the stroke color
        circleLayer.strokeColor = lightBlue.cgColor
        //you can change the line width
        circleLayer.lineWidth = 10.0
        
        goalView1.layer.addSublayer(circleLayer)
    }
    
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
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        self.present(alert, animated: true) {}
        }
        
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
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        self.present(alert, animated: true) {
        }
    }
    
    // Called when Serial is ready to communicate
    
    func serialIsReady(_ peripheral: CBPeripheral) {
        let currentDate = NSDate()
        let timeFormatter = DateFormatter()
        
        // Formats time to Arduino readable format -> hours,minutes,seconds,days,months,years
        timeFormatter.dateFormat = "H,m,s,d,M,yyyy"
        
        let dateString = timeFormatter.string(from: currentDate as Date)
        
        // Get user defaults
        let defaults = UserDefaults.standard
        let ledSwitchState = defaults.bool(forKey: "ledSwitch")
        var remindersState: String = "ON"
        if ledSwitchState == true {
            remindersState = "ON"
        } else {
            remindersState = "OFF"
        }
        
        let reminderTime = defaults.string(forKey: "reminderTime")
        
        serial.sendMessageToDevice("<" + dateString + "," + remindersState + "," + reminderTime! + ">")
    }
    
    // Called when Serial gets message
    
    func serialDidReceiveString(_ message: String) {
        let letters = message.characters.map { String($0) } // turns message string into array
        var startIndex:Int = 0
        var endIndex:Int = 0
        
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
        
        // Change label
        volumeLabel.text = volumeString + " ml"
        serial.disconnect()
        refreshGoals()
    }
    
    /// Called when de state of the CBCentralManager changes (e.g. when Bluetooth is turned on/off)
    func serialDidChangeState() {
        
    }
    
    /// Called when a peripheral disconnected
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        serialDisconnected = true
        
    }
    
    @IBAction func settingstoHome(segue:UIStoryboardSegue) {
        // refresh goals when Home is shown
        refreshGoals()
    }
}


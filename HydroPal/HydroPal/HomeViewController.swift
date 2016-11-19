//
//  HomeViewController.swift
//  HydroPal
//
//  Created by Shao Qian MAH on 15/11/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

import UIKit
import CoreBluetooth

final class HomeViewController: UIViewController, BluetoothSerialDelegate {
    
    @IBOutlet weak var syncButton: UIButton!
    @IBAction func clickSyncButton(_ sender: Any) {
        if serial.centralManager.state != .poweredOn {
            let alert = UIAlertController(title: "Turn on Bluetooth", message: "Turn on Bluetooth to sync with your water bottle", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            }
            
            alert.addAction(OKAction)
            
            self.present(alert, animated: true) {
            }
        } else {
            serial.startScan()
            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(HomeViewController.scanTimeOut), userInfo: nil, repeats: false)
            return
        }
    }
    
    /// The peripherals that have been discovered (no duplicates and sorted by asc RSSI)
    var peripherals: [(peripheral: CBPeripheral, RSSI: Float)] = []
    
    /// The peripheral the user has selected
    var selectedPeripheral: CBPeripheral?
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // init serial
        serial = BluetoothSerial(delegate: self)
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Should be called 10s after we've begun scanning
    func scanTimeOut() {
        // timeout has occurred, stop scanning and give the user the option to try again
        serial.stopScan()
        let alert = UIAlertController(title: "Hydropal not found", message: "Your Hydropal water bottle could not be found, please bring your bottle closer and retry", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        self.present(alert, animated: true) {
        }
        
    }
    
    /// Called when de state of the CBCentralManager changes (e.g. when bluetooth is turned on/off)
    func serialDidChangeState() {
        
    }
    
    /// Called when a peripheral disconnected
    func serialDidDisconnect(_ peripheral: CBPeripheral, error: NSError?) {
        
    }
    
    @IBAction func settingstoHome(segue:UIStoryboardSegue) {
    }
}


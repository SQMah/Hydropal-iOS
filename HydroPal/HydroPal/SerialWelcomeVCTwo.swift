//
//  SerialWelcomeVCTwo.swift
//  HydroPal
//
//  Created by Cheuk Lun Ko on 8/12/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

import UIKit

class SerialWelcomeVCTwo: UIViewController {

    @IBOutlet weak var serialTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        serialTextField.text = defaults.string(forKey: "serial")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backWelcome(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func advanceSex(_ sender: Any) {
        let alert = UIAlertController(title: "Serial Error", message: "Please enter a valid 4-digit serial not beginning with 0.", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        func serialAlert() {
            self.present(alert, animated: true)
        }
        
        // Checks if serial is 4-digit number, if so saves
        if let serialText = serialTextField.text {
            if let serialNumber = Int(serialText) {
                if serialNumber > 999 && serialNumber < 10000 {
                    defaults.set(serialText, forKey: "serial")
                    // print("Serial set to \(serialNumber)")
                } else {
                    serialAlert()
                }
            } else {
                serialAlert()
            }
        } else {
            serialAlert()
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

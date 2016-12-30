//
//  SexWelcomeVCThree.swift
//  HydroPal
//
//  Created by Cheuk Lun Ko on 8/12/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

import UIKit

let lightBlue = UIColor(red: 112/255, green: 200/255, blue: 224/255, alpha: 1.0)

class SexWelcomeVCThree: UIViewController {
    
    @IBOutlet weak var maleButton: UIButton!
    @IBOutlet weak var femaleButton: UIButton!

    // (Male, female)
    var highlighted: (Bool, Bool) = (false, false)
    
    @IBAction func tapMale(_ sender: Any) {
        if highlighted.0 {
            highlighted.0 = false
        } else {
            highlighted.0 = true
            highlighted.1 = false
        }
        refreshSex()
    }
    
    @IBAction func tapFemale(_ sender: Any) {
        if highlighted.1 {
            highlighted.1 = false
        } else {
            highlighted.1 = true
            highlighted.0 = false
        }
        refreshSex()
    }
    
    func refreshSex() {
        maleOnOff(bool: highlighted.0)
        femaleOnOff(bool: highlighted.1)
    }
    
    func maleOnOff(bool: Bool) {
        if bool {
            maleButton.backgroundColor = UIColor.white
            maleButton.setTitleColor(lightBlue, for: UIControlState.normal)
        } else {
            maleButton.backgroundColor = UIColor.clear
            maleButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
    }
    
    
    func femaleOnOff(bool: Bool) {
        if bool {
            femaleButton.backgroundColor = UIColor.white
            femaleButton.setTitleColor(lightBlue, for: UIControlState.normal)
        } else {
            femaleButton.backgroundColor = UIColor.clear
            femaleButton.setTitleColor(UIColor.white, for: UIControlState.normal)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Buttons
        maleButton.layer.cornerRadius = 44
        maleButton.layer.borderWidth = 2
        maleButton.layer.borderColor = UIColor.white.cgColor
        femaleButton.layer.cornerRadius = 44
        femaleButton.layer.borderWidth = 2
        femaleButton.layer.borderColor = UIColor.white.cgColor
        
        refreshSex()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func backSerial(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func advanceAge(_ sender: Any) {
        let alert = UIAlertController(title: "Nothing selected!", message: "Please select your sex", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        func sexAlert() {
            self.present(alert, animated: true)
        }
        
        if highlighted != (false,false) {
            if highlighted.0 {
                defaults.set("Male", forKey: "selectedSex")
            } else {
                defaults.set("Female", forKey: "selectedSex")
            }
        } else {
            sexAlert()
        }
        // print("Sex set to \(defaults.string(forKey: "selectedSex"))")
    }

}

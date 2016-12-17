//
//  AgeWelcomeVCFour.swift
//  HydroPal
//
//  Created by Cheuk Lun Ko on 8/12/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

import UIKit

let dateFormatter = DateFormatter()

class AgeWelcomeVCFour: UIViewController {
    
    @IBOutlet weak var datepicker: UIDatePicker!
    var datepickerChanged: Bool = false
    
    @IBAction func datepickerAction(_ sender: Any) {
        datepickerChanged = true
    }
    
    func updateBirthday() {
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        let date = defaults.string(forKey: "birthday")!
        datepicker.setDate(dateFormatter.date(from: date)!, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //load datepicker: font, colour
        datepicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        datepicker.maximumDate = NSDate() as Date
        updateBirthday()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backSex(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func advanceWake(_ sender: Any) {
        let alert = UIAlertController(title: "Age Error", message: "Please enter your birthday", preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
        }
        
        alert.addAction(OKAction)
        
        func ageAlert() {
            self.present(alert, animated: true)
        }
    
        if datepickerChanged {
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")

            let birthdayString = dateFormatter.string(from: datepicker.date)
            defaults.set(birthdayString, forKey: "birthday")
            
            //FIXME: date should not be today
        } else {
            ageAlert()
        }
        
    }
    
}
    


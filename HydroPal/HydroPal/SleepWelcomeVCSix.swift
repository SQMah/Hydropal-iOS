//
//  SleepWelcomeVCSix.swift
//  HydroPal
//
//  Created by Cheuk Lun Ko on 8/12/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

import UIKit

class SleepWelcomeVCSix: UIViewController {

    //FIXME: Update outlets
    @IBOutlet weak var datepicker: UIDatePicker!

    func updateSleepTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        let date = dateFormatter.date(from: defaults.string(forKey: "sleepTime")!)
        
        datepicker.setDate(date!, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        updateSleepTime()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backWakeTime(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    //FIXME: Create IBAction and confirm working
    
    @IBAction func advanceUsage(_ sender: Any) {
        
        let wakeTime = defaults.object(forKey: "wakeTime")!
        if datepicker.date.timeIntervalSince(wakeTime as! Date) > 0 {
            // Sleep time is larger than wake time
            defaults.set(datepicker.date, forKey: "sleepTime")
        } else {
            // Wake time is larger than sleep time
            
            let alert = UIAlertController(title: "Choose a valid time", message: "Choose a sleep time later than the wake time.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            }
            
            alert.addAction(OKAction)
            self.present(alert, animated: true) {
            }
        }
        
    }
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

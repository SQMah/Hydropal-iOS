//
//  WakeWelcomeWCFive.swift
//  HydroPal
//
//  Created by Cheuk Lun Ko on 8/12/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

import UIKit

class WakeWelcomeWCFive: UIViewController {

    
    @IBOutlet weak var datepicker: UIDatePicker!

    func updateWakeTime() {
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        let date = dateFormatter.date(from: (defaults.string(forKey: "wakeTime"))!)
        //FIXME: Crashes when set to future
        
        datepicker.setDate(date!, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        datepicker.setValue(UIColor.white, forKeyPath: "textColor")
        
        updateWakeTime()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func backAge(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func advanceSleep(_ sender: Any) {
        defaults.set(datepicker.date, forKey: "wakeTime")
    }
    

}

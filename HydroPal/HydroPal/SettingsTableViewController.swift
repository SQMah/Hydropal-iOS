//
//  SettingsTableViewController.swift
//  HydroPal
//
//  Created by Shao Qian MAH on 15/11/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

import Foundation
import UIKit

class SettingsTableViewController: UITableViewController {
    @IBOutlet weak var waterSwitch: UISwitch!
    @IBOutlet weak var customWaterTextField: UITextField!
    @IBOutlet weak var customWaterIntakeCell: UITableViewCell!
    
    @IBOutlet weak var sexCell: UITableViewCell!
    @IBOutlet weak var sexLabel: UILabel!
    
    @IBOutlet weak var ledSwitch: UISwitch!
    @IBOutlet weak var reminderCell: UITableViewCell!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderTimeCell: UITableViewCell!
    @IBOutlet weak var timeLabel: UILabel!
    
<<<<<<< HEAD
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var sleepLabel: UILabel!
    
    @IBOutlet weak var wakeTimeLabel: UILabel!
    @IBOutlet weak var sleepTimeLabel: UILabel!
    
    @IBOutlet weak var wakeTimePicker: UIDatePicker!
    @IBOutlet weak var sleepTimePicker: UIDatePicker!
    
=======
    //Wake time and sleep time
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var wakeTimeLabel: UILabel!
    @IBOutlet weak var wakeTimePicker: UIDatePicker!
    
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var sleepTimeLabel: UILabel!
    @IBOutlet weak var sleepTimePicker: UIDatePicker!
    
    @IBAction func wakeTimePickerChanged(_ sender: Any) {
        // On date picker change, update label
        timePickerChanged(label: wakeTimeLabel, timePicker: wakeTimePicker)
    }
    
    @IBAction func sleepTimePickerChanged(_ sender: Any) {
        // On date picker change, update label
        timePickerChanged(label: sleepTimeLabel, timePicker: sleepTimePicker)
    }
    
>>>>>>> origin/master
    @IBAction func waterSwitchValue(_ sender: UISwitch) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
        if waterSwitch.isOn {
            customWaterTextField.becomeFirstResponder()
        } else {
            customWaterTextField.resignFirstResponder()
        }
    }
    
    @IBAction func ledSwitchValue(_ sender: UISwitch) {
        self.tableView.beginUpdates()
        self.tableView.endUpdates()
    }
    
    @IBAction func wakeTimePickerChanged(_ sender: Any) {
        timePickerChanged(label: wakeTimeLabel, picker: wakeTimePicker)
    }
    
    @IBAction func sleepTimePickerChanged(_ sender: Any) {
        timePickerChanged(label: sleepTimeLabel, picker: sleepTimePicker)
    }
    
    
    
    var time: String = "60" {
        didSet {
            timeLabel.text? = time
        }
    }
    
    var sex: String = "Select" {
        didSet {
            sexLabel.text? = sex
        }
    }
    
<<<<<<< HEAD
    var wakeTimePickerHidden = true
    var sleepTimePickerHidden = true
=======
    var wakeTimePickerHidden = false
    var sleepTimePickerHidden = false
>>>>>>> origin/master

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load userdefaults
        let defaults = UserDefaults.standard
        waterSwitch.setOn(defaults.bool(forKey: "customGoalSwitch"), animated: false)
        customWaterTextField.text = defaults.string(forKey: "customGoal")
        sexLabel.text = defaults.string(forKey: "selectedSex")
        ledSwitch.setOn(defaults.bool(forKey: "ledSwitch"), animated: false)
        timeLabel.text = defaults.string(forKey: "reminderTime")
       
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        addDoneButton() // Adds done button to num pad
        
<<<<<<< HEAD
        //Check timepicker
        toggleTimePickerColor(label: wakeLabel, timePickerHidden: wakeTimePickerHidden)
        toggleTimePickerColor(label: sleepLabel, timePickerHidden: sleepTimePickerHidden)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = ""
        let date = dateFormatter.date(from: )
        
        timePickerChanged(label: wakeTimeLabel, picker: wakeTimePicker)
        timePickerChanged(label: sleepTimeLabel, picker: sleepTimePicker)
=======
        // Time picker setup
        let wakeTime = defaults.string(forKey: "wakeTime")!
        let sleepTime = defaults.string(forKey: "sleepTime")!
        
        
        wakeTimePicker.setDate(dateFormatter.date(from: wakeTime)!, animated: false)
        sleepTimePicker.setDate(dateFormatter.date(from: sleepTime)!, animated: false)
        
        timePickerChanged(label: wakeTimeLabel, timePicker: wakeTimePicker)
        timePickerChanged(label: sleepTimeLabel, timePicker: sleepTimePicker)
        
        toggleTimePickerColor(titleLabel: wakeLabel, timePickerHidden: wakeTimePickerHidden)
        toggleTimePickerColor(titleLabel: sleepLabel, timePickerHidden: sleepTimePickerHidden)
>>>>>>> origin/master
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
<<<<<<< HEAD
        tableView.deselectRow(at: indexPath, animated: true)
        if indexPath.section == 1 && indexPath.row == 2 {
            // Wake cell
=======
        // Animates selection
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Toggles wake date picker when when cell for time is clicked
        if indexPath.section == 1 && indexPath.row == 2 {
            
>>>>>>> origin/master
            // Shows and hides time picker: toggleTimePicker()
            wakeTimePickerHidden = !wakeTimePickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
            
<<<<<<< HEAD
            toggleTimePickerColor(label: wakeLabel, timePickerHidden: wakeTimePickerHidden)
        }
        if indexPath.section == 1 && indexPath.row == 4 {
            // Sleep cell
            // Wake cell
=======
            toggleTimePickerColor(titleLabel: wakeLabel, timePickerHidden: wakeTimePickerHidden)
        }
        // Toggles wake date picker when when cell for time is clicked
        if indexPath.section == 1 && indexPath.row == 4 {
            
>>>>>>> origin/master
            // Shows and hides time picker: toggleTimePicker()
            sleepTimePickerHidden = !sleepTimePickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
            
<<<<<<< HEAD
            toggleTimePickerColor(label: sleepLabel, timePickerHidden: sleepTimePickerHidden)
=======
            toggleTimePickerColor(titleLabel: sleepLabel, timePickerHidden: sleepTimePickerHidden)
>>>>>>> origin/master
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 && indexPath.row == 1{
            if waterSwitch.isOn {
                customWaterIntakeCell.isHidden = false
                return 55.0
            } else {
                customWaterIntakeCell.isHidden = true
                return 0.0
            }
        } else if indexPath.section == 0 && indexPath.row == 2 {
            if waterSwitch.isOn {
                sexCell.isHidden = true
                return 0.0
            } else {
                sexCell.isHidden = false
                return 55.0
            }
        } else if indexPath.section == 1 && indexPath.row == 1 {
            if ledSwitch.isOn {
                reminderCell.isHidden = false
                return 55.0
            } else {
                reminderCell.isHidden = true
                return 0.0
            }
        } else if wakeTimePickerHidden && indexPath.section == 1 && indexPath.row == 3 {
<<<<<<< HEAD
                return 0.0
        } else if sleepTimePickerHidden && indexPath.section == 1 && indexPath.row == 5 {
            return 0.0
=======
            return 0
        } else if sleepTimePickerHidden && indexPath.section == 1 && indexPath.row == 5 {
            return 0
>>>>>>> origin/master
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

// MARK: Functions
    
    // Sets cell background colour according to active state
    func toggleTimePickerColor(label: UILabel, timePickerHidden: Bool) {
        if timePickerHidden == false {
            label.textColor = UIColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1)
        }
        if timePickerHidden == true {
            label.textColor = UIColor.black
        }
    }
    
    // If timePickerChanged
    func timePickerChanged (label: UILabel, picker: UIDatePicker) {
        label.text = DateFormatter.localizedString(from: picker.date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
    }
    
    // Add done button to numpad
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        customWaterTextField.inputAccessoryView = keyboardToolbar
    }
    
<<<<<<< HEAD
    func timePickerChanged(timepicker: UIDatePicker, label: UILabel) {
        label.text = DateFormatter.localizedString(from: timepicker.date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
=======
    // Set label text to time picked
    
    func timePickerChanged (label: UILabel, timePicker: UIDatePicker) {
        label.text = DateFormatter.localizedString(from: timePicker.date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
    }
    
    // Change time picker colour
    
    func toggleTimePickerColor(titleLabel: UILabel, timePickerHidden: Bool) {
        if timePickerHidden == false {
            titleLabel.textColor = UIColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1)
        }
        if timePickerHidden == true {
            titleLabel.textColor = UIColor.black
        }
>>>>>>> origin/master
    }
    
    @IBAction func helptoSettings(segue:UIStoryboardSegue) {
    }
    
    // Sex selection is passed to this view controller
    @IBAction func unwindWithSelectedSex(_ segue:UIStoryboardSegue) {
        if let sexTableViewController = segue.source as? SexTableViewController,
            let selectedSex = sexTableViewController.selectedSex {
            sex = selectedSex
        }
    }
    
    // Reminder time information is passed to this view controller
    @IBAction func unwindWithSelectedTime(_ segue:UIStoryboardSegue) {
        if let timeTableViewController = segue.source as? TimeTableViewController,
            let selectedTime = timeTableViewController.selectedTime {
            time = selectedTime
        }
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "saveSettings" {
            if sleepTimePicker.date.timeIntervalSince(wakeTimePicker.date) > 0 {
                // Sleep time is larger than wake time
                return true
            } else {
                // Wake time is larger than sleep time
                
                let alert = UIAlertController(title: "Choose a valid time", message: "Choose a sleep time later than the wake time.", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                }
                
                alert.addAction(OKAction)
                
                self.present(alert, animated: true) {
                }
                return false
            } 
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickTime" {
            if let timeTableViewController = segue.destination as? TimeTableViewController {
                timeTableViewController.selectedTime = time
            }
        } else if segue.identifier == "pickSex" {
            if let sexTableViewController = segue.destination as? SexTableViewController {
                sexTableViewController.selectedSex = sex
            }
        } else if segue.identifier == "saveSettings" {
            
            // Save all of the user settings
            
            let defaults = UserDefaults.standard
            if waterSwitch.isOn == true {
                defaults.set(true, forKey: "customGoalSwitch")
            } else {
                defaults.set(false, forKey: "customGoalSwitch")
            }
            defaults.set(customWaterTextField.text, forKey: "customGoal")
            defaults.set(sexLabel.text, forKey: "selectedSex")
            
            if ledSwitch.isOn == true {
                defaults.set(true, forKey: "ledSwitch")
            } else {
                defaults.set(false, forKey: "ledSwitch")
            }
            
            defaults.set(timeLabel.text, forKey: "reminderTime")
            
<<<<<<< HEAD
            defaults.set(DateFormatter.localizedString(from: wakeTimePicker.date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short), forKey: "wakeTime")
            defaults.set(DateFormatter.localizedString(from: sleepTimePicker.date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short), forKey: "sleepTime")
=======
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let wakeString = dateFormatter.string(from: wakeTimePicker.date)
            let sleepString = dateFormatter.string(from: sleepTimePicker.date)
            
            defaults.set(wakeString, forKey: "wakeTime")
            defaults.set(sleepString, forKey: "sleepTime")
>>>>>>> origin/master
        }
    }
}

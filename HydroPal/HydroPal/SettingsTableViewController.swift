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
    //MARK: IB references

    // Hydropal
    @IBOutlet weak var stateSwitch: UISwitch!
    @IBOutlet weak var serialTextField: UITextField!
    
    //Personal details
    @IBOutlet weak var sexCell: UITableViewCell!
    @IBOutlet weak var sexLabel: UILabel!
    @IBOutlet weak var birthLabel: UILabel!
    @IBOutlet weak var birthdayLabel: UILabel!
    @IBOutlet weak var birthdayPicker: UIDatePicker!
    
    //Recommended intake
    @IBOutlet weak var waterSwitch: UISwitch!
    @IBOutlet weak var customWaterTextField: UITextField!
    @IBOutlet weak var customWaterIntakeCell: UITableViewCell!
    
    // LED reminders
    @IBOutlet weak var ledSwitch: UISwitch!
    @IBOutlet weak var reminderCell: UITableViewCell!
    @IBOutlet weak var reminderLabel: UILabel!
    @IBOutlet weak var reminderTimeCell: UITableViewCell!
    @IBOutlet weak var timeLabel: UILabel!
    
    //Wake time and sleep time (part of LED)
    @IBOutlet weak var wakeLabel: UILabel!
    @IBOutlet weak var wakeTimeLabel: UILabel!
    @IBOutlet weak var wakeTimePicker: UIDatePicker!
    
    @IBOutlet weak var sleepLabel: UILabel!
    @IBOutlet weak var sleepTimeLabel: UILabel!
    @IBOutlet weak var sleepTimePicker: UIDatePicker!
    
    //MARK: Action value changes / Label updates
    
    @IBAction func birthdayPickerChanged(_ sender: Any) {
        // On date picker change, update label
        timePickerChanged(label: birthdayLabel, timePicker: birthdayPicker, isTime: false)
    }
    
    @IBAction func wakeTimePickerChanged(_ sender: Any) {
        // On date picker change, update label
        timePickerChanged(label: wakeTimeLabel, timePicker: wakeTimePicker, isTime: true)
    }
    
    
    @IBAction func sleepTimePickerChanged(_ sender: Any) {
        timePickerChanged(label: sleepTimeLabel, timePicker: sleepTimePicker, isTime: true)
    }
    
    
    @IBAction func stateSwitchValue(_ sender: UISwitch) {
        if stateSwitch.isOn != true {
            let alert = UIAlertController(title: "Deactivated", message: "Your Hydropal has been turned off.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            }
            
            alert.addAction(OKAction)
            self.present(alert, animated: true)
        }
    }
    
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
    
    var birthdayPickerHidden = false
    var wakeTimePickerHidden = false
    var sleepTimePickerHidden = false
    
    var shouldHide = false

    //MARK: viewDidLoad setup
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Load userdefaults
        let defaults = UserDefaults.standard
        stateSwitch.setOn(defaults.bool(forKey: "bottleState"), animated: false)
        serialTextField.text = defaults.string(forKey: "serial")
        waterSwitch.setOn(defaults.bool(forKey: "customGoalSwitch"), animated: false)
        customWaterTextField.text = defaults.string(forKey: "customGoal")
        sex = defaults.string(forKey: "selectedSex")!
        ledSwitch.setOn(defaults.bool(forKey: "ledSwitch"), animated: false)
        time = defaults.string(forKey: "reminderTime")!
       
        let dateFormatter = DateFormatter()
        dateFormatter.calendar = Calendar(identifier: .iso8601)
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        
        addDoneButton() // Adds done button to num pad
        
        // Time picker setup
        
        birthdayPickerHidden = true
        wakeTimePickerHidden = true
        sleepTimePickerHidden = true
        
        let birthday = String(describing: defaults.object(forKey: "birthday")!)
        let wakeTime = String(describing: defaults.object(forKey: "wakeTime")!)
        let sleepTime = String(describing: defaults.object(forKey: "sleepTime")!)
        
        birthdayPicker.setDate(dateFormatter.date(from: birthday)!, animated: false)
        wakeTimePicker.setDate(dateFormatter.date(from: wakeTime)!, animated: false)
        sleepTimePicker.setDate(dateFormatter.date(from: sleepTime)!, animated: false)
        
        timePickerChanged(label: birthdayLabel, timePicker: birthdayPicker, isTime: false)
        timePickerChanged(label: wakeTimeLabel, timePicker: wakeTimePicker, isTime: true)
        timePickerChanged(label: sleepTimeLabel, timePicker: sleepTimePicker, isTime: true)
        
        toggleTimePickerColor(titleLabel: birthLabel, timePickerHidden: birthdayPickerHidden)
        toggleTimePickerColor(titleLabel: wakeLabel, timePickerHidden: wakeTimePickerHidden)
        toggleTimePickerColor(titleLabel: sleepLabel, timePickerHidden: sleepTimePickerHidden)
    }

    override func viewDidAppear(_ animated: Bool) {
        shouldHide = true
        UIView.animate(withDuration: 0.3) { () -> Void in
            self.setNeedsStatusBarAppearanceUpdate()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    //MARK: Datepicker setup
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Animates selection
        tableView.deselectRow(at: indexPath, animated: true)
        
        // Toggles birthday picker when when cell for time is clicked
        if indexPath.section == 1 && indexPath.row == 1 {
            
            // Shows and hides time picker: toggleTimePicker()
            birthdayPickerHidden = !birthdayPickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
            
            toggleTimePickerColor(titleLabel: birthLabel, timePickerHidden: birthdayPickerHidden)
        }
        
        // Toggles wake date picker when when cell for time is clicked
        if indexPath.section == 3 && indexPath.row == 2 {
            
            // Shows and hides time picker: toggleTimePicker()
            wakeTimePickerHidden = !wakeTimePickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
            
            toggleTimePickerColor(titleLabel: wakeLabel, timePickerHidden: wakeTimePickerHidden)
        }
        // Toggles wake date picker when when cell for time is clicked
        if indexPath.section == 3 && indexPath.row == 4 {
            
            // Shows and hides time picker: toggleTimePicker()
            sleepTimePickerHidden = !sleepTimePickerHidden
            tableView.beginUpdates()
            tableView.endUpdates()
            
            toggleTimePickerColor(titleLabel: sleepLabel, timePickerHidden: sleepTimePickerHidden)
        }
    }
    
    //MARK: Hidden cell setup
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 2 && indexPath.row == 1 {
            if waterSwitch.isOn {
                customWaterIntakeCell.isHidden = false
                return 55.0
            } else {
                customWaterIntakeCell.isHidden = true
                return 0.0
            }
        } else if indexPath.section == 3 && indexPath.row == 1 {
            if ledSwitch.isOn {
                reminderCell.isHidden = false
                return 55.0
            } else {
                reminderCell.isHidden = true
                return 0.0
            }
        } else if birthdayPickerHidden && indexPath.section == 1 && indexPath.row == 2 {
            return 0
        } else if wakeTimePickerHidden && indexPath.section == 3 && indexPath.row == 3 {
            return 0
        } else if sleepTimePickerHidden && indexPath.section == 3 && indexPath.row == 5 {
            return 0
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

// MARK: Functions
    
    // Add done button to numpad
    
    func addDoneButton() {
        let keyboardToolbar = UIToolbar()
        keyboardToolbar.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: view, action: #selector(UIView.endEditing(_:)))
        keyboardToolbar.items = [flexBarButton, doneBarButton]
        serialTextField.inputAccessoryView = keyboardToolbar
        customWaterTextField.inputAccessoryView = keyboardToolbar
    }
    
    // Set label text to time/date picked
    
    func timePickerChanged (label: UILabel, timePicker: UIDatePicker, isTime: Bool) {
        if isTime {
            label.text = DateFormatter.localizedString(from: timePicker.date, dateStyle: DateFormatter.Style.none, timeStyle: DateFormatter.Style.short)
        } else if isTime == false {
            label.text = DateFormatter.localizedString(from: timePicker.date, dateStyle: DateFormatter.Style.medium, timeStyle: DateFormatter.Style.none)
        }
    }
    
    // Change time picker colour
    
    func toggleTimePickerColor(titleLabel: UILabel, timePickerHidden: Bool) {
        if timePickerHidden == false {
            titleLabel.textColor = UIColor(red: 21/255, green: 126/255, blue: 251/255, alpha: 1)
        }
        if timePickerHidden == true {
            titleLabel.textColor = UIColor.black
        }
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
    
    //MARK: Segues
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        if identifier == "saveSettings" {
            
            // Serial checker
            let alert = UIAlertController(title: "Serial Error", message: "Please enter a valid 4-digit serial not beginning with 0.", preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
            }
            
            alert.addAction(OKAction)
            
            func serialAlert() {
                self.present(alert, animated: true)
            }

            if let serialText = serialTextField.text {
                if let serialNumber = Int(serialText) {
                    if serialNumber > 999 && serialNumber < 10000 {
                        defaults.set(serialText, forKey: "serial")
                        // print("Serial set to \(serialNumber)")
                    } else {
                        serialAlert()
                        return false
                    }
                } else {
                    serialAlert()
                    return false
                }
            } else {
                serialAlert()
                return false
            }
            
            // Sleep Time checker
            if sleepTimePicker.date.timeIntervalSince(wakeTimePicker.date) > 0 {
                // Sleep time is larger than wake time
                return true
            } else {
                // Wake time is larger than sleep time
                
                let alert = UIAlertController(title: "Choose a valid time", message: "Choose a sleep time later than the wake time.", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "Dismiss", style: .default) { (action) in
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
            
            if stateSwitch.isOn {
                defaults.set(true, forKey: "bottleState")
            } else {
                defaults.set(false, forKey: "bottleState")
            }
            defaults.set(serialTextField.text, forKey: "serial")
            
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
            
            let dateFormatter = DateFormatter()
            dateFormatter.calendar = Calendar(identifier: .iso8601)
            dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss +zzzz"
            dateFormatter.locale = Locale(identifier: "en_US_POSIX")
            
            let birthdayString = dateFormatter.string(from: birthdayPicker.date)
            let wakeString = dateFormatter.string(from: wakeTimePicker.date)
            let sleepString = dateFormatter.string(from: sleepTimePicker.date)
            
            defaults.set(birthdayString, forKey: "birthday")
            defaults.set(wakeString, forKey: "wakeTime")
            defaults.set(sleepString, forKey: "sleepTime")
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .fade
    }
    
    override var prefersStatusBarHidden : Bool {
        return shouldHide
    }
}

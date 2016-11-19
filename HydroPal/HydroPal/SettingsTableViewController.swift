//
//  SettingsTableViewController.swift
//  HydroPal
//
//  Created by Shao Qian MAH on 15/11/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

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

    override func viewDidLoad() {
        super.viewDidLoad()
        addDoneButton() // Adds done button to keyboard
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
                return 10.0
            }
        } else {
            return 55.0
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "pickTime" {
            if let timeTableViewController = segue.destination as? TimeTableViewController {
                timeTableViewController.selectedTime = time
            }
        } else if segue.identifier == "pickSex" {
            if let sexTableViewController = segue.destination as? SexTableViewController {
                sexTableViewController.selectedSex = sex
            }
        }
    }
}

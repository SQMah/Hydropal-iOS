//
//  SexTableViewController.swift
//  HydroPal
//
//  Created by Shao Qian MAH on 17/11/2016.
//  Copyright © 2016 HydroPal. All rights reserved.
//

import UIKit

class SexTableViewController: UITableViewController {

    var sexes:[String] = [
        "Male",
        "Female"
    ]
    
    var selectedSex:String? {
        didSet {
            if selectedSex == "Select" {
                // Do nothing
            } else if let sex = selectedSex {
                selectedSexIndex = sexes.index(of: sex)!
            }
        }
    }
    
    var selectedSexIndex:Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sexes.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sexSelectCell", for: indexPath)
        cell.textLabel?.text = sexes[(indexPath as NSIndexPath).row]
        
        if (indexPath as NSIndexPath).row == selectedSexIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        //Other row is selected - need to deselect it
        if let index = selectedSexIndex {
            let cell = tableView.cellForRow(at: IndexPath(row: index, section: 0))
            cell?.accessoryType = .none
        }
        
        selectedSex = sexes[(indexPath as NSIndexPath).row]
        
        //update the checkmark for the current row
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        //FIXME: Sex tick
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SaveSelectedSex" {
            if let cell = sender as? UITableViewCell {
                let indexPath = tableView.indexPath(for: cell)
                if let index = (indexPath as NSIndexPath?)?.row {
                    selectedSex = sexes[index]
                }
            }
        }
        //FIXME: Sex tick glitch
    }
}

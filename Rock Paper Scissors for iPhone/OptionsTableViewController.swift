//
//  OptionsTableViewController.swift
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 7/29/17.
//  Copyright © 2017 Anant Jain. All rights reserved.
//

import UIKit

class OptionsTableViewController: UITableViewController {
    
    // Sound toggles
    let weaponsSoundSwitch = UISwitch()
    let clicksSoundSwitch = UISwitch()
    
    // Score steppers
    let pvcScoreStepper = UIStepper()
    let pvpScoreStepper = UIStepper()
    
    let userDefaults = UserDefaults.standard

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        // Configures controls
        pvcScoreStepper.minimumValue = 3
        pvcScoreStepper.maximumValue = 25
        pvcScoreStepper.stepValue = 1
        pvpScoreStepper.minimumValue = 3
        pvpScoreStepper.maximumValue = 25
        pvpScoreStepper.stepValue = 1
        
        // Configures inital control values
        weaponsSoundSwitch.isOn = Universal.weaponsSoundsOn
        clicksSoundSwitch.isOn  = Universal.clicksSoundsOn
        pvcScoreStepper.value   = Double(Universal.pvcWinningScore)
        pvpScoreStepper.value   = Double(Universal.pvpWinningScore)
        
        // Sets up callbacks
        weaponsSoundSwitch.addTarget(Universal.self, action: #selector(Universal.playClickSound), for: .valueChanged)
        clicksSoundSwitch.addTarget(Universal.self, action: #selector(Universal.playClickSound), for: .valueChanged)
        pvcScoreStepper.addTarget(self, action: #selector(OptionsTableViewController.updateTable), for: .valueChanged)
        pvpScoreStepper.addTarget(self, action: #selector(OptionsTableViewController.updateTable), for: .valueChanged)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 2
        }
        else if section == 1 || section == 2 {
            return 1
        }
        else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Sounds"
        }
        else if section == 1 {
            return "Player vs. Computer Mode"
        }
        else if section == 2 {
            return "Player vs. Player Mode"
        }
        else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, titleForFooterInSection section: Int) -> String? {
        if section == 1 {
            return "Player vs. Computer mode will end after one side reaches \(Int(pvcScoreStepper.value)) points."
        }
        else if section == 2 {
            return "Player vs. Player mode will end after one side reaches \(Int(pvpScoreStepper.value)) points."
        }
        else {
            return nil
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .default, reuseIdentifier: nil)

        if indexPath.section == 0 {
            if indexPath.row == 0 {
                cell.textLabel?.text = "Weapons"
                cell.accessoryView = weaponsSoundSwitch
            }
            else if indexPath.row == 1 {
                cell.textLabel?.text = "Clicks"
                cell.accessoryView = clicksSoundSwitch
            }
        }
        else if indexPath.section == 1 {
            cell.textLabel?.text = "Winning Score"
            cell.accessoryView = pvcScoreStepper
        }
        else if indexPath.section == 2 {
            cell.textLabel?.text = "Winning Score"
            cell.accessoryView = pvpScoreStepper
        }
        
        cell.selectionStyle = .none

        return cell
    }
    
    // Stepper callback
    
    @objc func updateTable() {
        Universal.playClickSound()
        tableView.reloadData()
    }
    
    // Closing options menu

    @IBAction func closeOptions(_ sender: Any) {
        Universal.playClickSound()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func saveOptions(_ sender: Any) {
        Universal.playClickSound()
        Universal.updatePreferences(weaponsSounds: weaponsSoundSwitch.isOn, clickSounds: clicksSoundSwitch.isOn, pvc: Int(pvcScoreStepper.value), pvp: Int(pvpScoreStepper.value))
        dismiss(animated: true, completion: nil)
    }
    
    
}

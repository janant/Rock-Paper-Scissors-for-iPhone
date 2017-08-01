//
//  MenuViewController.swift
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 7/29/17.
//  Copyright © 2017 Anant Jain. All rights reserved.
//

import UIKit

protocol MenuViewControllerDelegate: class {
    func updateDifficulty(difficulty: Int)
    func exitToMainMenu()
}

class MenuViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuTable: UITableView!
    @IBOutlet weak var difficultyControl: UISegmentedControl!
    
    weak var delegate: MenuViewControllerDelegate?
    
    var currentGameMode: String!
    var currentDifficulty: Int!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if currentGameMode == Constants.GameModes.PvP {
            difficultyControl.isEnabled = false
        }
        
        difficultyControl.selectedSegmentIndex = currentDifficulty
        
        // Updates the width of the segmented control
        let frame = difficultyControl.frame
        difficultyControl.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: self.view.frame.width - 82, height: frame.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func closeMenu(_ sender: Any) {
        // Update difficulty if the user changes the difficulty
        if currentDifficulty != difficultyControl.selectedSegmentIndex {
            self.delegate?.updateDifficulty(difficulty: difficultyControl.selectedSegmentIndex)
        }
        Universal.playClickSound()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func updatedDifficulty(_ sender: Any) {
        Universal.playClickSound()
    }
    
    // MARK: - Table view data source
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = "Exit to Main Menu"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dismiss(animated: true) {
            self.delegate?.exitToMainMenu()
        }
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        Universal.playClickSound()
    }
    
    // MARK: - View transition methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Updates the width of the segmented control
        let frame = difficultyControl.frame
        difficultyControl.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: size.width - 82, height: frame.height)
    }

}

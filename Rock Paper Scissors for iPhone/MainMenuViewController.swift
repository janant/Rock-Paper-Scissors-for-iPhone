//
//  MainMenuViewController.swift
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 7/29/17.
//  Copyright © 2017 Anant Jain. All rights reserved.
//

import UIKit

class MainMenuViewController: UIViewController {
    
    @IBOutlet weak var pvcButton: UIButton!
    @IBOutlet weak var pvpButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Loads and prepares sounds and preferences
        Universal.initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func startGame(_ sender: Any) {
        performSegue(withIdentifier: "Start Game", sender: sender)
    }
    
    @IBAction func playClickSound(_ sender: Any) {
        Universal.playClickSound()
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Start Game" {
            guard
                let gameModeButton = sender as? UIButton,
                let gameVC = segue.destination as? GameViewController
            else {
                return
            }
            
            if gameModeButton == pvcButton {
                gameVC.gameMode = Constants.GameModes.PvC
            }
            else if gameModeButton == pvpButton {
                gameVC.gameMode = Constants.GameModes.PvP
            }
        }
    }
    

}

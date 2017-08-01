//
//  GameViewController.swift
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 7/29/17.
//  Copyright © 2017 Anant Jain. All rights reserved.
//

import UIKit

class GameViewController: UIViewController, MenuViewControllerDelegate, UIViewControllerTransitioningDelegate {
    
    // Player views
    @IBOutlet weak var player1NameLabel: UILabel!
    @IBOutlet weak var player2NameLabel: UILabel!
    @IBOutlet weak var player1ImageView: UIImageView!
    @IBOutlet weak var player2ImageView: UIImageView!
    
    // General game views
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    
    // Weapon buttons
    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var paperButton: UIButton!
    @IBOutlet weak var scissorsButton: UIButton!
    
    // Toolbar
    @IBOutlet weak var difficultySegmentedControl: UISegmentedControl!
    
    var gameMode: String!
    
    var player1Weapon: Int!
    var player2Weapon: Int!
    
    var player1Score = 0
    var player2Score = 0
    
    var player1Name = "Player 1"
    var player2Name = "Player 2"
    var isPlayer1Turn = true

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if gameMode == Constants.GameModes.PvP {
            difficultySegmentedControl.isEnabled = false
        }
        
        // Updates the width of the segmented control
        let frame = difficultySegmentedControl.frame
        difficultySegmentedControl.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: self.view.frame.width - 82, height: frame.height)
        
        // Prompts for player names, in case this is Player vs. Player mode
        if gameMode == Constants.GameModes.PvP {
            let player1NamePrompt = UIAlertController(title: "Enter Player 1 name:", message: nil, preferredStyle: .alert)
            let player2NamePrompt = UIAlertController(title: "Enter Player 2 name:", message: nil, preferredStyle: .alert)
            player1NamePrompt.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Player 1"
            })
            player2NamePrompt.addTextField(configurationHandler: { (textField) in
                textField.placeholder = "Player 2"
            })
            player1NamePrompt.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                if let player1NameTextFieldText = player1NamePrompt.textFields?[0].text {
                    if player1NameTextFieldText.characters.count > 0 {
                        self.player1Name = player1NameTextFieldText
                    }
                }
                self.player1NameLabel.text = self.player1Name
                self.promptPlayer1()
                self.present(player2NamePrompt, animated: true, completion: nil)
                
                Universal.playClickSound()
            }))
            player2NamePrompt.addAction(UIAlertAction(title: "Done", style: .default, handler: { (action) in
                if let player2NameTextFieldText = player2NamePrompt.textFields?[0].text {
                    if player2NameTextFieldText.characters.count > 0 {
                        self.player2Name = player2NameTextFieldText
                    }
                }
                self.player2NameLabel.text = self.player2Name
                
                Universal.playClickSound()
            }))
            present(player1NamePrompt, animated: true, completion: nil)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func changedDifficulty(_ sender: Any) {
        Universal.playClickSound()
        startNewGame()
    }
    
    @IBAction func choseWeapon(_ sender: Any) {
        guard let weaponButton = sender as? UIButton else {
            return
        }
        
        if gameMode == Constants.GameModes.PvC {
            // Determines which weapon the player chose
            if weaponButton == rockButton {
                player1Weapon = Constants.Weapons.Rock
                player1ImageView.image = #imageLiteral(resourceName: "Rock")
            }
            else if weaponButton == paperButton {
                player1Weapon = Constants.Weapons.Paper
                player1ImageView.image = #imageLiteral(resourceName: "Paper")
            }
            else if weaponButton == scissorsButton {
                player1Weapon = Constants.Weapons.Scissors
                player1ImageView.image = #imageLiteral(resourceName: "Scissors")
            }
            
            determineComputerChoice()
            determineOutcome()
        }
        else if gameMode == Constants.GameModes.PvP {
            if isPlayer1Turn { // First player
                if weaponButton == rockButton {
                    player1Weapon = Constants.Weapons.Rock
                }
                else if weaponButton == paperButton {
                    player1Weapon = Constants.Weapons.Paper
                }
                else if weaponButton == scissorsButton {
                    player1Weapon = Constants.Weapons.Scissors
                }
                
                player1ImageView.image = #imageLiteral(resourceName: "Waiting")
                player2ImageView.image = #imageLiteral(resourceName: "Pick Weapon")
                
                promptPlayer2()
            }
            else { // Second player
                if weaponButton == rockButton {
                    player2Weapon = Constants.Weapons.Rock
                }
                else if weaponButton == paperButton {
                    player2Weapon = Constants.Weapons.Paper
                }
                else if weaponButton == scissorsButton {
                    player2Weapon = Constants.Weapons.Scissors
                }
                
                player1ImageView.image = imageForWeapon(weapon: player1Weapon)
                player2ImageView.image = imageForWeapon(weapon: player2Weapon)
                
                perform(#selector(GameViewController.promptPlayer1), with: nil, afterDelay: 1.5)
                
                determineOutcome()
            }
            
            isPlayer1Turn = !isPlayer1Turn
        }
    }
    
    func promptPlayer1() {
        updateStatus(message: "Pick a weapon, \(player1Name)!")
    }
    
    func promptPlayer2() {
        updateStatus(message: "Pick a weapon, \(player2Name)!")
    }
    
    func determineComputerChoice() {
        if difficultySegmentedControl.selectedSegmentIndex == Constants.Difficulties.Easy { // Easy mode
            let i = (arc4random() % 100) + 1
            if i > 0 && i <= 20 { // 20% chance of purposefully losing
                player2Weapon = (player1Weapon + 2) % 3
                player2ImageView.image = imageForWeapon(weapon: player2Weapon)
            }
            else { // 80% random chance
                randomComputerChoice()
            }
        }
        else if difficultySegmentedControl.selectedSegmentIndex == Constants.Difficulties.Medium {
            let i = (arc4random() % 100) + 1
            if i > 0 && i <= 20 { // 20% chance of purposefully losing
                player2Weapon = (player1Weapon + 2) % 3
                player2ImageView.image = imageForWeapon(weapon: player2Weapon)
            }
            else if i > 20 && i <= 35 { // 15% chance of purposefully winning
                player2Weapon = (player1Weapon + 1) % 3
                player2ImageView.image = imageForWeapon(weapon: player2Weapon)
            }
            else { // 65% random chance
                randomComputerChoice()
            }
        }
        else if difficultySegmentedControl.selectedSegmentIndex == Constants.Difficulties.Hard {
            let i = (arc4random() % 100) + 1
            if i > 0 && i <= 20 { // 20% chance of purposefully winning
                player2Weapon = (player1Weapon + 1) % 3
                player2ImageView.image = imageForWeapon(weapon: player2Weapon)
            }
            else { // 80% random chance
                randomComputerChoice()
            }
        }
    }
    
    func randomComputerChoice() {
        let i = arc4random() % 3
        if i == 0 { // Rock
            player2Weapon = Constants.Weapons.Rock
            player2ImageView.image = #imageLiteral(resourceName: "Rock")
        }
        else if i == 1 {
            player2Weapon = Constants.Weapons.Paper
            player2ImageView.image = #imageLiteral(resourceName: "Paper")
        }
        else if i == 2 {
            player2Weapon = Constants.Weapons.Scissors
            player2ImageView.image = #imageLiteral(resourceName: "Scissors")
        }
    }
    
    func imageForWeapon(weapon: Int) -> UIImage? {
        if weapon == Constants.Weapons.Rock {
            return #imageLiteral(resourceName: "Rock")
        }
        else if weapon == Constants.Weapons.Paper {
            return #imageLiteral(resourceName: "Paper")
        }
        else if weapon == Constants.Weapons.Scissors {
            return #imageLiteral(resourceName: "Scissors")
        }
        else {
            return nil
        }
    }
    
    func determineOutcome() {
        // Determines which player won
        if player1Weapon == player2Weapon { // Same weapon picked by both
            updateStatus(message: Constants.StatusMessages.NothingHappens)
            Universal.playTieSound()
        }
        else if player1Weapon == (player2Weapon + 1) % 3 { // Player 1 wins
            updateStatus(message: statusForWeapon(weapon: player1Weapon))
            playSoundForWeapon(weapon: player1Weapon)
            
            player1Score += 1
            updateScore()
            
            // Determine if the game is over
            if gameMode == Constants.GameModes.PvC {
                if player1Score == Universal.pvcWinningScore {
                    let youWinDialog = UIAlertController(title: "You Win!", message: "You got to \(Universal.pvcWinningScore) points first.", preferredStyle: .alert)
                    youWinDialog.addAction(UIAlertAction(title: "New Game", style: .default, handler: { (action) in
                        self.startNewGame()
                    }))
                    present(youWinDialog, animated: true, completion: nil)
                }
            }
            else if gameMode == Constants.GameModes.PvP {
                if player1Score == Universal.pvpWinningScore {
                    let player1WinsDialog = UIAlertController(title: "\(player1Name) Wins!", message: "\(player1Name) got to \(Universal.pvpWinningScore) points first.", preferredStyle: .alert)
                    player1WinsDialog.addAction(UIAlertAction(title: "New Game", style: .default, handler: { (action) in
                        self.startNewGame()
                    }))
                    present(player1WinsDialog, animated: true, completion: nil)
                }
            }
        }
        else if player1Weapon == (player2Weapon + 2) % 3 { // Player 2 wins
            updateStatus(message: statusForWeapon(weapon: player2Weapon))
            playSoundForWeapon(weapon: player2Weapon)
            
            player2Score += 1
            updateScore()
            
            // Determine if the game is over
            if gameMode == Constants.GameModes.PvC {
                if player2Score == Universal.pvcWinningScore {
                    let computerWinsDialog = UIAlertController(title: "Computer Wins!", message: "The computer got to \(Universal.pvcWinningScore) points first.", preferredStyle: .alert)
                    computerWinsDialog.addAction(UIAlertAction(title: "New Game", style: .default, handler: { (action) in
                        self.startNewGame()
                    }))
                    present(computerWinsDialog, animated: true, completion: nil)
                }
            }
            else if gameMode == Constants.GameModes.PvP {
                if player2Score == Universal.pvpWinningScore {
                    let player2WinsDialog = UIAlertController(title: "\(player2Name) Wins!", message: "\(player2Name) got to \(Universal.pvpWinningScore) points first.", preferredStyle: .alert)
                    player2WinsDialog.addAction(UIAlertAction(title: "New Game", style: .default, handler: { (action) in
                        self.startNewGame()
                    }))
                    present(player2WinsDialog, animated: true, completion: nil)
                }
            }
        }
    }
    
    func updateStatus(message: String?) {
        UIView.transition(with: statusLabel, duration: 0.2, options: .transitionCrossDissolve, animations: { 
            self.statusLabel.text = message
        }, completion: nil)
    }
    
    func updateScore() {
        UIView.transition(with: scoreLabel, duration: 0.2, options: .transitionCrossDissolve, animations: {
            self.scoreLabel.text = "\(self.player1Score) — \(self.player2Score)"
        }, completion: nil)
    }
    
    func playSoundForWeapon(weapon: Int) {
        if weapon == Constants.Weapons.Rock {
            Universal.playRockSound()
        }
        else if weapon == Constants.Weapons.Paper {
            Universal.playPaperSound()
        }
        else if weapon == Constants.Weapons.Scissors {
            Universal.playScissorsSound()
        }
    }
    
    func statusForWeapon(weapon: Int) -> String? {
        if weapon == Constants.Weapons.Rock {
            return Constants.StatusMessages.RockSmashesScissors
        }
        else if weapon == Constants.Weapons.Paper {
            return Constants.StatusMessages.PaperCoversRock
        }
        else if weapon == Constants.Weapons.Scissors {
            return Constants.StatusMessages.ScissorsCutPaper
        }
        else {
            return nil
        }
    }
    
    func startNewGame() {
        player1Score = 0
        player2Score = 0
        updateScore()
        
        player1ImageView.image = #imageLiteral(resourceName: "Pick Weapon")
        player2ImageView.image = #imageLiteral(resourceName: "Waiting")
        
        if gameMode == Constants.GameModes.PvC {
            updateStatus(message: "Pick your weapon")
        }
        else if gameMode == Constants.GameModes.PvP {
            promptPlayer1()
        }
    }
    
    // MARK: - MenuViewController delegate methods
    
    func updateDifficulty(difficulty: Int) {
        difficultySegmentedControl.selectedSegmentIndex = difficulty
        startNewGame()
    }
    
    func exitToMainMenu() {
        self.navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Transitioning delegate methods
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if presented is MenuViewController {
            return SlideUpTransition(presenting: true)
        }
        else {
            return nil
        }
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        if dismissed is MenuViewController {
            return SlideUpTransition(presenting: false)
        }
        else {
            return nil
        }
    }
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        if presented is MenuViewController {
            return SlideUpPresentation(presentedViewController: presented, presenting: presenting)
        }
        else {
            return nil
        }
    }
    
    // MARK: - View transition methods
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        // Updates the width of the segmented control
        let frame = difficultySegmentedControl.frame
        difficultySegmentedControl.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: size.width - 82, height: frame.height)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "Show Menu" {
            Universal.playClickSound()
            if let menuVC = segue.destination as? MenuViewController {
                // Sets up data and delegate
                menuVC.currentDifficulty = difficultySegmentedControl.selectedSegmentIndex
                menuVC.currentGameMode = gameMode
                menuVC.delegate = self
                
                // Sets up transition
                menuVC.modalPresentationStyle = .custom
                menuVC.transitioningDelegate = self
            }
        }
    }
    

}

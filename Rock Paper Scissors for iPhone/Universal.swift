//
//  Universal.swift
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 7/30/17.
//  Copyright © 2017 Anant Jain. All rights reserved.
//

import Foundation
import AVFoundation

class Universal: NSObject {
    
    private static let userDefaults = UserDefaults.standard
    
    // Preferences for user
    static var weaponsSoundsOn: Bool!
    static var clicksSoundsOn: Bool!
    static var pvcWinningScore = 0
    static var pvpWinningScore = 0
    
    // Weapon and outcome sounds
    private static let rockSound     = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Rock", withExtension: "m4a")!)
    private static let paperSound    = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Paper", withExtension: "m4a")!)
    private static let scissorsSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Scissors", withExtension: "mp3")!)
    private static let tieSound      = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Tie", withExtension: "mp3")!)
    
    // Click sound
    private static let clickSound = try! AVAudioPlayer(contentsOf: Bundle.main.url(forResource: "Click", withExtension: "mp3")!)
    
    static func initialSetup() {
        // Prepares sounds
        rockSound.prepareToPlay()
        paperSound.prepareToPlay()
        scissorsSound.prepareToPlay()
        clickSound.prepareToPlay()
        tieSound.prepareToPlay()
        
        // Sets up initial user defaults if doesn't already exist
        if userDefaults.object(forKey: Constants.UserDefaultsKeys.WeaponsSoundsOn) == nil {
            userDefaults.set(true, forKey: Constants.UserDefaultsKeys.WeaponsSoundsOn)
        }
        if userDefaults.object(forKey: Constants.UserDefaultsKeys.ClicksSoundsOn) == nil {
            userDefaults.set(true, forKey: Constants.UserDefaultsKeys.ClicksSoundsOn)
        }
        if userDefaults.object(forKey: Constants.UserDefaultsKeys.PvCWinningScore) == nil {
            userDefaults.set(10, forKey: Constants.UserDefaultsKeys.PvCWinningScore)
        }
        if userDefaults.object(forKey: Constants.UserDefaultsKeys.PvPWinningScore) == nil {
            userDefaults.set(10, forKey: Constants.UserDefaultsKeys.PvPWinningScore)
        }
        userDefaults.synchronize()
        
        // Loads user defaults values
        weaponsSoundsOn = userDefaults.bool(forKey: Constants.UserDefaultsKeys.WeaponsSoundsOn)
        clicksSoundsOn = userDefaults.bool(forKey: Constants.UserDefaultsKeys.ClicksSoundsOn)
        pvcWinningScore = userDefaults.integer(forKey: Constants.UserDefaultsKeys.PvCWinningScore)
        pvpWinningScore = userDefaults.integer(forKey: Constants.UserDefaultsKeys.PvPWinningScore)
    }
    
    // Playing sounds
    
    static func playRockSound() {
        if weaponsSoundsOn {
            rockSound.play()
        }
    }
    
    static func playPaperSound() {
        if weaponsSoundsOn {
            paperSound.play()
        }
    }
    
    static func playScissorsSound() {
        if weaponsSoundsOn {
            scissorsSound.play()
        }
    }
    
    static func playTieSound() {
        if weaponsSoundsOn {
            tieSound.play()
        }
    }
    
    static func playClickSound() {
        if clicksSoundsOn {
            clickSound.play()
        }
    }
    
    // Updating preferences
    
    static func updatePreferences(weaponsSounds: Bool, clickSounds: Bool, pvc: Int, pvp: Int) {
        weaponsSoundsOn = weaponsSounds
        clicksSoundsOn = clickSounds
        pvcWinningScore = pvc
        pvpWinningScore = pvp
        
        userDefaults.set(weaponsSounds, forKey: Constants.UserDefaultsKeys.WeaponsSoundsOn)
        userDefaults.set(clickSounds, forKey: Constants.UserDefaultsKeys.ClicksSoundsOn)
        userDefaults.set(pvc, forKey: Constants.UserDefaultsKeys.PvCWinningScore)
        userDefaults.set(pvp, forKey: Constants.UserDefaultsKeys.PvPWinningScore)
        
        userDefaults.synchronize()
    }
    
}

//
//  Constants.swift
//  Rock Paper Scissors for iPhone
//
//  Created by Anant Jain on 7/30/17.
//  Copyright © 2017 Anant Jain. All rights reserved.
//

import Foundation

struct Constants {
    
    // Preference keys
    struct UserDefaultsKeys {
        static let WeaponsSoundsOn = "kWeaponsSoundsOn"
        static let ClicksSoundsOn  = "kClicksSoundsOn"
        static let PvCWinningScore = "kPvCWinningScore"
        static let PvPWinningScore = "kPvPWinningScore"
    }
    
    struct GameModes {
        static let PvC = "PvC"
        static let PvP = "PvP"
    }
    
    struct Difficulties {
        static let Easy   = 0
        static let Medium = 1
        static let Hard   = 2
    }
    
    struct Weapons {
        static let Rock     = 0
        static let Paper    = 1
        static let Scissors = 2
    }
    
    struct StatusMessages {
        static let PaperCoversRock = "Paper covers Rock!"
        static let ScissorsCutPaper = "Scissors cut Paper!"
        static let RockSmashesScissors = "Rock smashes Scissors!"
        static let NothingHappens = "Nothing happens!"
    }
    
}

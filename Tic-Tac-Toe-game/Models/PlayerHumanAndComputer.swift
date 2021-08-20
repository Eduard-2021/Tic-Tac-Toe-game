//
//  PlayerHumanAndComputer.swift
//  Tic-Tac-Toe-game
//
//  Created by Eduard on 18.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

public enum PlayerHumanAndComputer: CaseIterable {
    case human
    case computer
    
    var next: PlayerHumanAndComputer {
        switch self {
        case .human: return .computer
        case .computer: return .human
        }
    }
}

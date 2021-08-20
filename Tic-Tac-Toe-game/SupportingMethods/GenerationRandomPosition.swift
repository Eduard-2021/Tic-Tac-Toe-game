//
//  GenerationRandomPosition.swift
//  Tic-Tac-Toe-game
//
//  Created by Eduard on 18.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class GenerationRandomPosition {
    func funcGenerationRandomPosition() -> GameboardPosition {
        let randomNumberColumn = Int(arc4random_uniform(UInt32(GameboardSize.columns)))
        let randomNumberRow = Int(arc4random_uniform(UInt32(GameboardSize.rows)))
        return GameboardPosition(column: randomNumberColumn, row: randomNumberRow)
    }
}

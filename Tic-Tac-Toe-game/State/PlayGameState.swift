//
//  PlayGameState.swift
//  XO-game
//
//  Created by Veaceslav Chirita on 16.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

protocol PlayGameState {
    var isMoveCompleted: Bool { get set }
    func addSign(at position: GameboardPosition)
    func begin()
}

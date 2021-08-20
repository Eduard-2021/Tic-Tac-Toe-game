//
//  FiveMovesCommand.swift
//  Tic-Tac-Toe-game
//
//  Created by Eduard on 19.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

protocol Command {
    var player: Player {get}
    var position: GameboardPosition {get}
    var gameBoard: Gameboard  {get}
    var gameBoardView: GameboardView  {get}
    func execute(needLog: Bool)
}

class CreateXViewCommand: Command {
    var player: Player
    var position: GameboardPosition
    var gameBoard: Gameboard
    var gameBoardView: GameboardView
    
    init(player: Player, position: GameboardPosition, gameBoard: Gameboard, gameBoardView: GameboardView) {
        self.player = player
        self.position = position
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
    }
    
    func execute(needLog: Bool) {
        let markView = XView()
        gameBoard.setPlayer(player, at: position)
        gameBoardView.placeMarkView(markView, at: position)
        if needLog {Logger.shared.log(action: .playerSetSign(player: player, position: position))}
    }
}

class CreateOViewCommand: Command {
    var player: Player
    var position: GameboardPosition
    var gameBoard: Gameboard
    var gameBoardView: GameboardView
    
    init(player: Player, position: GameboardPosition, gameBoard: Gameboard, gameBoardView: GameboardView) {
        self.player = player
        self.position = position
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
    }
    
    func execute(needLog: Bool) {
        let markView = OView()
        gameBoard.setPlayer(player, at: position)
        gameBoardView.placeMarkView(markView, at: position)
        if needLog {Logger.shared.log(action: .playerSetSign(player: player, position: position))}
    }
}

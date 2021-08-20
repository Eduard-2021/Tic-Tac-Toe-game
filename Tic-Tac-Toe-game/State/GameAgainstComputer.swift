//
//  GameAgainstComputer.swift
//  Tic-Tac-Toe-game
//
//  Created by Eduard on 18.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class GameAgainstComputer: PlayGameState {
    var isMoveCompleted: Bool = false
    
    public var player: Player
    
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameBoard: Gameboard?
    private(set) weak var gameBoardView: GameboardView?
    public var markView: MarkView
    
    init(player: Player, gameViewController: GameViewController?, gameBoard: Gameboard?, gameBoardView: GameboardView?, markView: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
        self.markView = markView
    }
    
    
    func addSign(at position: GameboardPosition) {
        GameViewController.counter += 1
        _ = onlyAddSing(at: position)
        var isComputerWent = false
        while !isComputerWent && !(GameViewController.counter >= 9) {
            let positionSelectedComputer = GenerationRandomPosition().funcGenerationRandomPosition()
            isComputerWent = onlyAddSing(at: positionSelectedComputer)
        }
        isMoveCompleted = true
        GameViewController.counter += 1
    }
    
    private func onlyAddSing(at position: GameboardPosition) -> Bool {
        guard let gameBoardView = gameBoardView,
              gameBoardView.canPlaceMarkView(at: position)
        else { return false}
        gameBoard?.setPlayer(player, at: position)
        Logger.shared.log(action: .playerSetSign(player: player, position: position))
        gameBoardView.placeMarkView(markView.copy(), at: position)
        if (player == .first) && !(GameViewController.counter >= 9) {
            player = .second
            begin()
            markView = (gameViewController?.getMarkView(player: player))!
        }
        return true
    }
    
    func begin() {
        switch player {
        case .first:
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            gameViewController?.firstPlayerTurnLabel.isHidden = true
            gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        
        gameViewController?.winnerLabel.isHidden = true
    }
    
    
}

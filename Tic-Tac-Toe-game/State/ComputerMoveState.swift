//
//  ComputerMoveState.swift
//  Tic-Tac-Toe-game
//
//  Created by Eduard on 19.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//


import Foundation

class ComputerMoveState: PlayGameState {
    var isMoveCompleted: Bool = false
    
    public var player: Player
    
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameBoard: Gameboard?
    private(set) weak var gameBoardView: GameboardView?
    public let markView: MarkView
    
    init(player: Player, gameViewController: GameViewController?, gameBoard: Gameboard?, gameBoardView: GameboardView?, markView: MarkView) {
        self.player = player
        self.gameViewController = gameViewController
        self.gameBoard = gameBoard
        self.gameBoardView = gameBoardView
        self.markView = markView
    }
    
    
    func addSign(at position: GameboardPosition) {
        var isComputerWent = false
        while !isComputerWent {
            //Генерация случайной позиции
            let positionSelectedComputer = GenerationRandomPosition().funcGenerationRandomPosition()
            //Проверка не занята ли эта позиция и сразу размещение нолика, которым играет компьютер
            isComputerWent = onlyAddSing(at: positionSelectedComputer)
        }
        isMoveCompleted = true
    }
    
    private func onlyAddSing(at position: GameboardPosition) -> Bool {
        guard let gameBoardView = gameBoardView,
              gameBoardView.canPlaceMarkView(at: position)
        else { return false}
        gameBoard?.setPlayer(player, at: position)
        Logger.shared.log(action: .playerSetSign(player: player, position: position))
        gameBoardView.placeMarkView(markView.copy(), at: position)
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

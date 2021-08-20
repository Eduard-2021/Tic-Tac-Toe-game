//
//  PlayerMakes5Moves.swift
//  Tic-Tac-Toe-game
//
//  Created by Eduard on 19.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class PlayerMakes5MovesState: PlayGameState {
    var isMoveCompleted: Bool = false
    public let player: Player
    
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
        guard let gameBoardView = gameBoardView,
              gameBoardView.canPlaceMarkView(at: position)
        else { return }
        
        //Наполнение массива команд
        if player == .first {
            let xViewCommand = CreateXViewCommand(player: player, position: position, gameBoard: gameBoard!, gameBoardView: gameBoardView)
            FiveMovesInvoker.shared.addCommands(command: xViewCommand)
        }
        else {
            let oViewCommand = CreateOViewCommand(player: player, position: position,  gameBoard: gameBoard!, gameBoardView: gameBoardView)
            FiveMovesInvoker.shared.addCommands(command: oViewCommand)
        }
        //Размещение крестика или нолика на экране
        gameBoard?.setPlayer(player, at: position)
        Logger.shared.log(action: .playerSetSign(player: player, position: position))
        gameBoardView.placeMarkView(markView.copy(), at: position)
        
        //Проверка, если первый игрок сделал 5 ходов (количество команд достигает 5), то isMoveCompleted стает true и ход переходит к следующему игроку и количество его ходов считается по количеству команд в архиве и при достижении 10 isMoveCompleted переходит в true, а в основном gameViewController меняется State на GameExecutionState
        if (FiveMovesInvoker.shared.commands.count == 5) || (FiveMovesInvoker.shared.commands.count == 10) {
            if FiveMovesInvoker.shared.commands.count == 5 {
                gameViewController?.secondPlayerTurnLabel.isHidden = true
            }
            gameBoardView.isUserInteractionEnabled = false
            DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [self] in
                gameBoardView.isUserInteractionEnabled = true
                //Очистка доски и массива с занятыми позициями на этой доске после секундной задержки
                clearBoard()
                gameBoardView.markViewForPosition = [:]
                if FiveMovesInvoker.shared.commands.count != 10 {
                    gameViewController?.firstPlayerTurnLabel.isHidden = true
                    gameViewController?.secondPlayerTurnLabel.isHidden = false
                }
                })
            isMoveCompleted = true
        }
    }
    
    func begin() {
        if player == .first {
            gameViewController?.firstPlayerTurnLabel.isHidden = false
            gameViewController?.secondPlayerTurnLabel.isHidden = true
        }
        gameViewController?.winnerLabel.isHidden = true
    }
    
    private func clearBoard(){
        gameBoardView?.clear()
        gameBoard?.clear()
        GameViewController.counter = 0
    }
    
}

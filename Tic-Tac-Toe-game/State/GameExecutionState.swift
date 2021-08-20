//
//  GameExecutionState.swift
//  Tic-Tac-Toe-game
//
//  Created by Eduard on 20.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class GameExecutionState: PlayGameState {
    var isMoveCompleted: Bool = false
    var movesOfPlayerNumber = 1
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
        //Отображение 5 ходов первого игрока
        FiveMovesInvoker.shared.startShowAndCalculate(from: 0, to: 4, shouldDeterminedWinner: false, gameViewController: gameViewController!)
        //Секундная задержка, очистка экрана и массива занятых крестиками клеток, после чего отображение ходов второго игрока
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: { [self] in
            clearBoard()
            gameBoardView!.markViewForPosition = [:]
            begin()
            FiveMovesInvoker.shared.startShowAndCalculate(from: 5, to: 9, shouldDeterminedWinner: false, gameViewController: gameViewController!)
            })
       
        //Двухсекундная задержка, очистка экрана и массива занятых нулями клеток, после чего вычисление окончательного набора команд так, если бы игроки ходили последовательно и видели ходы друг друга. Вывод этого набора команд на экран с одновременной проверкой в Invoker нет ли победителя
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(2), execute: { [self] in
            clearBoard()
            gameBoardView!.markViewForPosition = [:]
        
            FiveMovesInvoker.shared.commands = choosingRightCommand()
            FiveMovesInvoker.shared.startShowAndCalculate(from: 0, to: FiveMovesInvoker.shared.commands.count-1, shouldDeterminedWinner: true, gameViewController: gameViewController!)
            })
        isMoveCompleted = true
    }
    
    func begin() {
        if gameViewController?.winnerLabel.text == "Ходы первого игрока" {
            gameViewController?.winnerLabel.text = "Ходы второго игрока"
        }
        gameViewController?.firstPlayerTurnLabel.isHidden = true
        gameViewController?.secondPlayerTurnLabel.isHidden = true
    }
    
    private func clearBoard(){
        gameBoardView?.clear()
        gameBoard?.clear()
        GameViewController.counter = 0
    }
    
    //Метод установления команд (ходов), которые при последовательной, открытой игре были бы отображены на доске
    private func choosingRightCommand() -> [Command] {
        var resultCommands = [Command]()
        var markViewForPosition: [GameboardPosition: Int] = [:]
        for index in 0 ... 4 {
            if markViewForPosition[FiveMovesInvoker.shared.commands[index].position] == nil {
                markViewForPosition[FiveMovesInvoker.shared.commands[index].position] = 1
                resultCommands.append(FiveMovesInvoker.shared.commands[index])
            }
            if markViewForPosition[FiveMovesInvoker.shared.commands[index+5].position] == nil {
                markViewForPosition[FiveMovesInvoker.shared.commands[index+5].position] = 1
                resultCommands.append(FiveMovesInvoker.shared.commands[index+5])
            }
        }
        return resultCommands
    }
}

//
//  FiveMovesInvoker.swift
//  Tic-Tac-Toe-game
//
//  Created by Eduard on 19.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class FiveMovesInvoker {
    
    public static let shared = FiveMovesInvoker()
    
    private init(){}
    
    var commands: [Command] = []
    
    func addCommands(command: Command){
        commands.append(command)
    }
    
    func startShowAndCalculate(from: Int, to: Int, shouldDeterminedWinner: Bool, gameViewController: GameViewController) {
        var i = from
        var isWinner = false
        while (i <= to) && !isWinner {
        //Инициализация выполнения команд и определение победителя
            commands[i].execute(needLog: shouldDeterminedWinner)
            if shouldDeterminedWinner {
                if let winner = gameViewController.referee.determineWinner() {
                    gameViewController.currentState = GameEndState(winnerPlayer: winner, gameViewController: gameViewController)
                    isWinner = true
                }
            }
            i += 1
        }
        // Проверка условия если нет победителя
        if shouldDeterminedWinner && !isWinner {
            gameViewController.currentState = GameEndState(winnerPlayer: nil, gameViewController: gameViewController)
        }
    }
}

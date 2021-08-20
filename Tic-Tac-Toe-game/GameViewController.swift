//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    @IBOutlet weak var showResultsButton: UIButton!

    
    static var counter = 0
    var typeOfGame: TypeOfGame = .gameAgainstHuman
    
    private let gameBoard = Gameboard()
    lazy var referee = Referee(gameboard: gameBoard)
    
    var currentState: PlayGameState! {
        didSet {
            currentState.begin()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        firstPlayerTurn()
        gameboardView.onSelectPosition = { [weak self] position in
            guard let self = self else { return }
            self.callAddSingAndChangePlayer(position: position)
        }
    }
    
    private func callAddSingAndChangePlayer(position: GameboardPosition){
        currentState.addSign(at: position)
            GameViewController.counter += 1

        if self.currentState.isMoveCompleted {
            nextPlayerTurn()
        }
    }
    
    //Кнопка вызова показа ходов игроков (вызова стейта GameExecutionState) и последующего вычисления победителя и отображения результатов на игровой доске
    @IBAction func showResultsButton(_ sender: Any) {
        currentState.addSign(at: GameboardPosition(column: 0, row: 0))
        winnerLabel.isHidden = false
        winnerLabel.text = "Ходы первого игрока"
        showResultsButton.isHidden = true
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Logger.shared.log(action: .restartGame)
        gameboardView.clear()
        gameBoard.clear()
        GameViewController.counter = 0
        //Очистка массива команд
        FiveMovesInvoker.shared.commands = []
        firstPlayerTurn()
    }
    
    
    private func firstPlayerTurn() {
        let firstPlayer: Player = .first
        let markView = getMarkView(player: firstPlayer)
        switch typeOfGame {
        case .gameAgainstComputer:
            firstPlayerTurnLabel.text = "Human"
            secondPlayerTurnLabel.text = "Computer"
            currentState = HumanMoveState(player: firstPlayer,
                                           gameViewController: self,
                                           gameBoard: gameBoard,
                                           gameBoardView: gameboardView, markView: markView)
        case .gameAgainstHuman:
            currentState = HumanMoveState(player: firstPlayer,
                                           gameViewController: self,
                                           gameBoard: gameBoard,
                                           gameBoardView: gameboardView, markView: markView)
        case .blindGame:
            firstPlayerTurnLabel.text = "Первый игрок, сделайте 5 ходов"
            secondPlayerTurnLabel.text = "Второй игрок, сделайте 5 ходов"
            currentState = PlayerMakes5MovesState(player: firstPlayer,
                                           gameViewController: self,
                                           gameBoard: gameBoard,
                                           gameBoardView: gameboardView, markView: markView)
        }
    }
    
    private func nextPlayerTurn() {
        if let winner = referee.determineWinner() {
            //Исключение варианта т.н. победы одного из игроков при последовательном выполнение 5 ходов
            if (currentState as? PlayerMakes5MovesState) == nil {
                currentState = GameEndState(winnerPlayer: winner, gameViewController: self)
                return
            }
        }
        
        if GameViewController.counter >= 9 {
            Logger.shared.log(action: .gameFinished(won: nil))
            currentState = GameEndState(winnerPlayer: nil, gameViewController: self)
            return
        }
        
        if let playerState = currentState as? HumanMoveState {
            let next = playerState.player.next
            let markView = getMarkView(player: next)
            if typeOfGame == .gameAgainstHuman {
            currentState = HumanMoveState(player: next, gameViewController: self,
                                                  gameBoard: gameBoard, gameBoardView: gameboardView, markView: markView)}
            else {
                //Переход из состояния HumanMoveState в ComputerMoveState при игре против компьютера
                currentState = ComputerMoveState(player: next, gameViewController: self,
                                                      gameBoard: gameBoard, gameBoardView: gameboardView, markView: markView)
                //Задержка для создания эффекта игры против живого человека, которому надо время чтобы подумать
                DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(500), execute: { [self] in
                        callAddSingAndChangePlayer(position: GameboardPosition(column: 0, row: 0))
                    })
            }
            }
        else if let playerState = currentState as? ComputerMoveState {
            let next = playerState.player.next
            let markView = getMarkView(player: next)
            currentState = HumanMoveState(player: next, gameViewController: self,
                                           gameBoard: gameBoard, gameBoardView: gameboardView, markView: markView)
        }
        else if let playerState = currentState as? PlayerMakes5MovesState {
            if playerState.player == .first {
                let next = playerState.player.next
                let markView = getMarkView(player: next)
                currentState = PlayerMakes5MovesState(player: next, gameViewController: self,
                                              gameBoard: gameBoard, gameBoardView: gameboardView, markView: markView)
                
            }
            //Переход в состояние GameExecutionState
            else {
                let next = playerState.player.next
                let markView = getMarkView(player: next)
                showResultsButton.isHidden = false
                currentState = GameExecutionState(player: next, gameViewController: self,
                                              gameBoard: gameBoard, gameBoardView: gameboardView, markView: markView)
            }
        }
    }
    
    func getMarkView(player: Player) -> MarkView {
        switch player {
        case .first:
            return XView()
        case .second:
            return OView()
        }
    }
}


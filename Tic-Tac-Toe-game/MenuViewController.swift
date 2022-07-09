//
//  MenuViewController.swift
//  Tic-Tac-Toe-game
//
//  Created by Eduard on 18.08.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if #available(iOS 13.0, *) {
            overrideUserInterfaceStyle = .light
        } 
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard
                let gameViewController = segue.destination as? GameViewController
                else {return}
       
                switch segue.identifier {
                case "SegueGameAgainstComputer":
                    gameViewController.typeOfGame = .gameAgainstComputer
                case "SegueGameAgainstHuman":
                    gameViewController.typeOfGame = .gameAgainstHuman
                case "SegueBlindGame":
                    gameViewController.typeOfGame = .blindGame
                default:
                    break
                }
    }
}

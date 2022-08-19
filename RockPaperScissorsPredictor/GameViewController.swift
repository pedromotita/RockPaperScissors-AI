//
//  ViewController.swift
//  RockPaperScissorsPredictor
//
//  Created by Pedro Mota on 17/08/22.
//

import UIKit

enum RPSMove: CaseIterable {
    case rock
    case paper
    case scissors
    
    static func chooseRandomElement() -> RPSMove {
        return self.allCases.randomElement()!
    }
}

class GameViewController: UIViewController {
    
    @IBOutlet weak var rockButton: UIButton!
    @IBOutlet weak var paperButton: UIButton!
    @IBOutlet weak var scissorsButton: UIButton!
    @IBOutlet weak var aiMoveLabel: UILabel!
    
    private var playerMoveMaker: PlayerMoveMaker = PlayerMoveMaker()
    private var aiMoveMaker: AIMoveMaker = AIMoveMaker()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerMoveMaker.delegate = self
        self.aiMoveMaker.delegate = self
        
        self.rockButton.addTarget(self, action: #selector(self.playRock), for: .touchUpInside)
        self.paperButton.addTarget(self, action: #selector(self.playPaper), for: .touchUpInside)
        self.scissorsButton.addTarget(self, action: #selector(self.playScissors), for: .touchUpInside)
    }
    
    @objc
    func playRock() {
        self.playerMoveMaker.makeMove(.rock)
    }
    
    @objc
    func playPaper() {
        self.playerMoveMaker.makeMove(.paper)
    }
    
    @objc
    func playScissors() {
        self.playerMoveMaker.makeMove(.scissors)
    }
    
    func computeResult() {
        guard let playerMove = self.playerMoveMaker.move, let aiMove = aiMoveMaker.move else { return }

        if playerMove == aiMove {
            print("Draw!")
        } else if playerMove == .rock {
            aiMove == .scissors ? print("You won!") : print("You lost!")
        } else if playerMove == .paper {
            aiMove == .rock ? print("You won!") : print("You lost!")
        } else if playerMove == .scissors {
            aiMove == .scissors ? print("You won!") : print("You lost!")
        }
    }
}

extension GameViewController: PlayerMoveMakerDelegate {
    func playerDidMakeMove() {
        self.aiMoveMaker.makeMove()
        
    }
}

extension GameViewController: AIMoveMakerDelegate {
    func aiDidMakeMove() {
        self.computeResult()
    }
}


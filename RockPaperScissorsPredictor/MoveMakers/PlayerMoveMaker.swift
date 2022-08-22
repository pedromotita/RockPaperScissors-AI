//
//  PlayerMoveMaker.swift
//  RockPaperScissorsPredictor
//
//  Created by Pedro Mota on 17/08/22.
//

import Foundation

class PlayerMoveMaker {
    
    private(set) var move: RPSMove?
    private var movesHistory = [RPSMove]()
    public weak var delegate: PlayerMoveMakerDelegate?
    
    public func makeMove(_ move: RPSMove) {
        print("You played \(move)")
        self.move = move
        self.addMoveToHistory(move)
        delegate?.playerDidMakeMove()
    }
    
    private func addMoveToHistory(_ move: RPSMove) {
        self.movesHistory.append(move)
    }
}

protocol PlayerMoveMakerDelegate: AnyObject {
    func playerDidMakeMove()
}

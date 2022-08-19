//
//  PlayerMoveMaker.swift
//  RockPaperScissorsPredictor
//
//  Created by Pedro Mota on 17/08/22.
//

import Foundation

class PlayerMoveMaker {
    
    private(set) var move: RPSMove?
    public weak var delegate: PlayerMoveMakerDelegate?
    
    public func makeMove(_ move: RPSMove) {
        print("You played \(move)")
        self.move = move
        delegate?.playerDidMakeMove()
    }
}

protocol PlayerMoveMakerDelegate: AnyObject {
    func playerDidMakeMove()
}

//
//  AIMoveMaker.swift
//  RockPaperScissorsPredictor
//
//  Created by Pedro Mota on 17/08/22.
//

import Foundation

class AIMoveMaker {
    
    private(set) var move: RPSMove?
    public weak var delegate: AIMoveMakerDelegate?
    
    public func makeMove() {
        let aiMove = RPSMove.chooseRandomElement()
        print("AI played \(aiMove)")
        self.move = aiMove
        delegate?.aiDidMakeMove()
    }
}

protocol AIMoveMakerDelegate: AnyObject {
    func aiDidMakeMove()
}

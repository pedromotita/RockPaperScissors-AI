//
//  RPSDecisionTree.swift
//  RockPaperScissorsPredictor
//b
//  Created by Pedro Mota on 19/08/22.
//

import Foundation
import TabularData
import CreateML

struct RPSMatch {
    var playerMove: RPSMove
    var aiMove: RPSMove
    var outcome: Int
}

struct RPSMatchHistory {
    var playerMoveHistory: [RPSMove]
    var aiMoveHistory: [RPSMove]
    var outcomeHistory: [Int]
}

class RPSDecisionTree {
    
    private var matchHistory: RPSMatchHistory
    private var trainingData: DataFrame
    private var decisionTreeModel: MLDecisionTreeRegressor?
    
    init(for matchHistory: RPSMatchHistory) {
        self.matchHistory = matchHistory
        self.trainingData = DataFrame()
    }
    
    public func createDataFrame(from matchHistory: RPSMatchHistory) -> DataFrame {
        var dataFrame = DataFrame()
        dataFrame.append(column: Column(name: "PlayerMove", contents: matchHistory.playerMoveHistory))
        dataFrame.append(column: Column(name: "AIMove", contents: matchHistory.aiMoveHistory))
        dataFrame.append(column: Column(name: "Outcome", contents: matchHistory.outcomeHistory))
        
        return dataFrame
    }
    
    
    public func predictPlayerNextMove() {
        self.trainingData = self.createDataFrame(from: self.matchHistory)
        self.decisionTreeModel = try? MLDecisionTreeRegressor(trainingData: self.trainingData, targetColumn: "Outcome")
        
        let prediction = try? self.decisionTreeModel?.predictions(from: <#T##DataFrame#>)
    }
    
    
}

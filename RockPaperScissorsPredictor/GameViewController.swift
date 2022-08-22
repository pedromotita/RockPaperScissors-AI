//
//  ViewController.swift
//  RockPaperScissorsPredictor
//
//  Created by Pedro Mota on 17/08/22.
//

import UIKit
import ARKit

//MARK: - RPSMove

enum RPSMove: CaseIterable {
    case rock
    case paper
    case scissors
    
    static func chooseRandomElement() -> RPSMove {
        return self.allCases.randomElement()!
    }
    
    static func stringToRPSMove(_ value: String) -> RPSMove? {
        switch value {
            case "paper": return .paper
            case "rock": return .rock
            case "scissors": return .scissors
            default: return nil
        }
    }
}

//MARK: - GameViewController

class GameViewController: UIViewController {
    
    @IBOutlet weak var aiMoveLabel: UILabel!
    @IBOutlet weak var arView: ARSCNView!
    
    private var playerMoveMaker: PlayerMoveMaker = PlayerMoveMaker()
    private var aiMoveMaker: AIMoveMaker = AIMoveMaker()
    private let handPoseDetector = HandPoseDetectorModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.playerMoveMaker.delegate = self
        self.aiMoveMaker.delegate = self
        self.setARView()
    }

    @IBAction func onCameraTap(_ sender: UIBarButtonItem) {
        handPoseDetector.detect()
    }
    
    private func computeResult() {
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
    
    private func setARView() {
        self.handPoseDetector.delegate = self
        arView.session.delegate = handPoseDetector
        arView.session.run(ARWorldTrackingConfiguration())
        arView.debugOptions = [.showSkeletons, .showCameras, .showCreases, .showWireframe, .showConstraints, .showBoundingBoxes, .showFeaturePoints]
        arView.allowsCameraControl = true
    }
}

//MARK: - PlayerMoveMakerDelegate

extension GameViewController: PlayerMoveMakerDelegate {
    func playerDidMakeMove() {
        self.aiMoveMaker.makeMove()
        
    }
}

//MARK: - AIMoveMakerDelegate

extension GameViewController: AIMoveMakerDelegate {
    func aiDidMakeMove() {
        self.computeResult()
    }
}

//MARK: - HandPoseDetectorModelDelegate

extension GameViewController: HandPoseDetectorModelDelegate {
    func onHandPoseDetection(move: RPSMove) {
        self.playerMoveMaker.makeMove(move)
    }
}

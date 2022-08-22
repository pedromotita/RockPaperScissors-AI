//
//  HandPoseDetectorModel.swift
//  RockPaperScissorsPredictor
//
//  Created by Gabriel Oliveira Borges on 19/08/22.
//

import Foundation
import ARKit

protocol HandPoseDetectorModelDelegate {
    func onHandPoseDetection(move: RPSMove)
}

class HandPoseDetectorModel: NSObject, ARSessionDelegate {
    private let model = HandPoseDetector().model
    private let PROBABILITY_THRESHOLD = 0.9
    private var lastFrame: ARFrame? = nil
    
    var delegate: HandPoseDetectorModelDelegate? = nil
    
    private func onHandDetected(label: String, probability: Double) {
        guard let move = RPSMove.stringToRPSMove(label) else { return }
        if (probability > PROBABILITY_THRESHOLD) {
            self.delegate?.onHandPoseDetection(move: move)
        }
    }
    
    func detect() {
        guard let frame = self.lastFrame else { return }
        let handPoseRequest = VNDetectHumanHandPoseRequest()
        handPoseRequest.maximumHandCount = 1
        handPoseRequest.revision = VNDetectHumanHandPoseRequestRevision1
        
        let pixelBuffer = frame.capturedImage
        let handler = VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:])
        
        do {
            try handler.perform([handPoseRequest])
        } catch {
            assertionFailure("Hand pose reques failed: \(error)")
        }
        
        guard let handPoses = handPoseRequest.results, let handObservation = handPoses.first else {
            print("No results")
            return
        }
        
        
        guard let keypointsMultiArray = try? handObservation.keypointsMultiArray() else {
            fatalError("Could not get keypoints")
        }
        
        do {
            let handPosePrediction = try model.prediction(from: HandPoseDetectorInput(poses: keypointsMultiArray))
            guard let poseLabel = handPosePrediction.featureValue(for: "label")?.stringValue, let posesProbabilities = handPosePrediction.featureValue(for: "labelProbabilities")?.dictionaryValue, let poseProbability = posesProbabilities[poseLabel] else {
                print("Nil pose label or posProbability")
                return
            }
            
            self.onHandDetected(label: poseLabel, probability: poseProbability.doubleValue)
        } catch {
            print("Prediction error \(error)")
        }
    }
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        self.lastFrame = frame
    }
}

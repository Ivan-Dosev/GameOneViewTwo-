//
//  ArdaScene.swift
//  Tree1700
//
//  Created by Ivan Dimitrov on 19.12.20.
//

import SwiftUI
import SpriteKit

class MagicScene: SKScene {
    
//    let boy = SKSpriteNode(imageNamed: "zaek8")
    var logo = SKSpriteNode()
    var shatterNode: ShatterNode?
    var animationTimer: Timer?
    var resolutionXTextField = 10
    var resolutionYTextField = 30
    var animationSlider  : CGFloat = 0
    
    var isShow : Bool = false

    override func didMove(to view: SKView) {
        super.didMove(to: view)
        let  background = SKSpriteNode(imageNamed: "Treva")
             background.position = CGPoint(x: 150, y: 150)
             addChild(background)
        if UserDefaults.standard.bool(forKey: "ViewEnemy") {
            loadScene()
        }
      
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        logo.removeAllActions()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
            resetAndPlayDemoAnimation()
        }
       
    }
    
    func loadScene() {

        logo = SKSpriteNode(imageNamed: "Enemy\(Int.random(in: 1..<16))")
        logo.position = CGPoint(x: 200, y: 200)
        logo.setScale(0.5)
        addChild(logo)
        let moveBottomLeft = SKAction.move(to: CGPoint(x: 150, y: 115), duration: 2.0)

        let moveRight = SKAction.move(to: CGPoint(x: 350, y: 115), duration: 2.0)

        let sequence = SKAction.sequence([ moveBottomLeft, .wait(forDuration: 1), .run { [self] in
            logo.xScale = abs(logo.yScale) * 1 } ,moveRight, .wait(forDuration: 1), .run { [self] in
            logo.xScale = abs(logo.yScale) * -1 } ])
        let rep = SKAction.repeatForever(sequence)

        logo.run(rep)
        Random.seed()

    }

    
     func updateAnimation() {
         let progress = CGFloat(animationSlider)
         if let shatterPieces = shatterNode?.pieces {
             for piece in shatterPieces {
                 if let animationMetadata = piece.shatterAnimationMetadata {
                    animationMetadata.applyPositionAndRotation(for: progress , to: piece )
                 }
             }
         }
     }
     

     func resetAndPlayDemoAnimation() {
         shatterNode?.removeFromParent()
         shatterNode = nil
         animationTimer?.invalidate()
         animationSlider = 0
         let resolutionX = max(min(resolutionXTextField, 2), 2)
         let resolutionY = max(min(resolutionYTextField, 2), 2)
//         shatterNode = boy.shatter(into: CGSize(width: resolutionX, height: resolutionY), animation: .manual, showHeatmap: true)
        shatterNode = logo.shatter(into: CGSize(width: resolutionX, height: resolutionY), animation: .manual, showHeatmap: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3, execute: { [weak self] in
             self?.runDemoAnimation()
         
         })
        DispatchQueue.main.asyncAfter(deadline: .now() + 10) { [self] in
            shatterNode?.removeFromParent()
        }
        
       
     }
     
     func runDemoAnimation() {
         animationTimer?.invalidate()
         animationTimer = Timer.scheduledTimer(withTimeInterval: 1.0 / 20.0, repeats: true, block: { [weak self] timer in
             if let blockSelf = self {
                 if blockSelf.animationSlider < CGFloat(1.0) {
                     blockSelf.animationSlider += CGFloat(0.008)
                    if blockSelf.animationSlider > 1 {
                        blockSelf.animationSlider = 1
                    }
                     blockSelf.updateAnimation()
                 } else {
                    blockSelf.animationSlider = 0
                     timer.invalidate()
                 }
             }
         })
     }
    
}

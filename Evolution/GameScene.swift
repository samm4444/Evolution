//
//  GameScene.swift
//  Evolution
//
//  Created by Samuel Miller on 17/06/2021.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene {
    let goal = SKSpriteNode.init(color: .green, size: CGSize(width: 25, height: 25))
    let startingPos = CGPoint(x: 200, y: 80)
    let population = Population.init(Size: 100, Position: CGPoint(x: 200, y: 80))
    var obstacles = Array<SKSpriteNode>()
    override func sceneDidLoad() {
        
        goal.position = CGPoint(x: 200, y: 640)
        addChild(goal)
        
        let r = GKRandomSource()
        for _ in 0...5 {
            let o = SKSpriteNode.init(color: .gray, size: CGSize(width: 60, height: 20))
            let x = r.nextInt(upperBound: 400)
            let y = r.nextInt(upperBound: 720)
            o.position = .init(x: x, y: y)
            addChild(o)
            obstacles.append(o)
        }
        
        
        
        
        population.createPositions(obstacles: obstacles)
        for i in population.players {
            addChild(i.node)
        }
        
    }
    
    override func didMove(to view: SKView) {
        let bestPlayer = population.fittestPlayer(goal: goal.position)
        population.reproduce(Parent: bestPlayer, Size: 100)
        population.createPositions(obstacles: obstacles)
        population.draw()
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        population.draw()
        for i in population.players {
            i.node.removeFromParent()
        }
        /*
        for i in children {
            if (i.name ?? "").contains("player") {
                i.removeFromParent()
            }
        }*/
        for i in population.players {
            //addChild(i.node)
        }
    }
}

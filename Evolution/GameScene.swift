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
    let population = Population.init(Size: 250, Position: CGPoint(x: 200, y: 80), Steps: 1000)
    var obstacles = Array<SKSpriteNode>()
    let popSize = 250
    let steps = 1000
    var currentStep = 0
    var gameState: State = .Reproducing
    var generation = 0
    let mutationChance = 2
    var skipTo = 0
    var skippingNo = 0
    
    func skip(generations: Int) {
        skipTo = generation + generations
        skippingNo = generations
        gameState = .Background
    }
    
    var setProgress:((Float) -> (Void))?
    var setGeneration:((Int) -> (Void))?
    
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
        
        
        
        
        population.createPositions(obstacles: obstacles, goal: goal)
        for i in population.players {
            addChild(i.node)
        }
        gameState = .Running
        
    }
    
    override func didMove(to view: SKView) {
        
    }
    
    
    func touchDown(atPoint pos : CGPoint) {
        
    }
    
    func touchMoved(toPoint pos : CGPoint) {
        
    }
    
    func touchUp(atPoint pos : CGPoint) {
        /*
        if gameState == .Running {
            gameState = .Background
        } else if gameState == .Background{
            gameState = .Running
        }*/
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
    
    func regen() {
        let initialState = gameState
        gameState = .Reproducing
        
        for player in population.players {
            player.node.removeFromParent()
        }
        
        
        let bestPlayer = population.fittestPlayer(goal: goal.position)
        population.reproduce(Parent: bestPlayer, Size: popSize, MutationChance: mutationChance)
        population.createPositions(obstacles: obstacles, goal: goal)
        //print(population.players[0].positions.last)
        
        for i in population.players {
            addChild(i.node)
        }
        
        
        currentStep = 0
        generation += 1
        
        gameState = initialState
        
        if gameState == .Running {
            setProgress?(0)
        }
        
        if gameState == .Background {
            
            let percentage: Float = 1 - Float((Float(skipTo - generation)) / Float(skippingNo))
            setProgress?(percentage)
            
            if generation == skipTo {
                gameState = .Running
            }
            
        }
        
        
    }
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
        //print(population.players[0].positions.last)
        setGeneration?(generation)
        
        if gameState == .Running {
            for player in population.players {
                if currentStep < player.positions.count {
                    player.node.position = player.positions[currentStep]
                }
            }
            if currentStep < steps {
                currentStep += 1
            } else {
                regen()
            }
        } else if gameState == .Background {
            regen()
        }
        
        
        
        
        
    }
}

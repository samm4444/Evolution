//
//  Player.swift
//  Evolution
//
//  Created by Samuel Miller on 17/06/2021.
//

import UIKit
import GameKit

class Player: NSObject {
    
    var path: Array<Direction>
    var positions: Array<CGPoint>
    var stepSize: CGFloat
    var alive: Bool
    var won: Bool
    var node: SKSpriteNode
    
    init(Steps: Int, ID: Int) {
        path = Array<Direction>()
        let r = GKRandomSource()
        for _ in 1...Steps { // create duplicate of parent
            let direction = Direction(rawValue: r.nextInt(upperBound: 4))!
            path.append(direction)
        }
        positions = Array<CGPoint>() // not ran yet
        stepSize = 4
        alive = true
        won = false
        node = SKSpriteNode(color: .red, size: CGSize(width: 5, height: 5))
        node.name = "player" + String(describing: ID)
    }
    
    
    
    func fitness(goal: CGPoint) -> Float {
        var count = positions.count * 2
        var fitness: Float = 0
        
        if won { // give winners a high score based on the number of steps taken to get there
            return Float(( 1 / positions.count) + 100000)
        }
        
        if !alive && !won { // give score of 0 if the player dies
            return 0
        } else {
            //fitness = 1 / Float(distance(positions.last!, goal))

            
            for i in positions {
                let distance = distance(i, goal)
                fitness += Float(count) * Float( 1 / distance)
                count -= 1
            }
        }
        
        return fitness
    }
    func distance(_ a: CGPoint, _ b: CGPoint) -> CGFloat {
        let xDist = a.x - b.x
        let yDist = a.y - b.y
        return CGFloat(sqrt(xDist * xDist + yDist * yDist))
    }

    // MARK: - Create an array of positions from the path
    
    func createPositions(startPos: CGPoint, obstacles: Array<SKSpriteNode>, goal: SKSpriteNode) {
        var currentPos: CGPoint = startPos
        positions.append(currentPos)
        
        for direction in path {
            
            switch direction {
                case .North:
                    currentPos.y += stepSize
                    break
                    
                case .East:
                    currentPos.x += stepSize
                    break
                    
                case .South:
                    currentPos.y -= stepSize
                    break
                    
                case .West:
                    currentPos.x -= stepSize
                    break
            }
            
            if goal.contains(currentPos) {
                won = true
                alive = false
            }
            
            // check for obstacle collision
            for o in obstacles {
                if o.contains(currentPos) {
                    alive = false
                    break
                }
            }
            if !alive {
                break
            }
            
            positions.append(currentPos) // add to list of places its been
            //node.position = currentPos
        }
        
        
        
    }
    
    // MARK:  - Change path by a percentage
    
    func mutate(Chance: Int) {
        let r = GKRandomSource()
        let oldPath = path
        path = Array<Direction>()
        for d in oldPath {
            let n = r.nextInt(upperBound: 100)
            if n < Chance {
                let direction = Direction(rawValue: r.nextInt(upperBound: 4))!
                path.append(direction)
            } else {
                path.append(d)
            }
        }
        
    }
    
    
    
}

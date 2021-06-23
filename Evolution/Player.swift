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
    var node: SKSpriteNode
    
    init(Steps: Int, i: Int) {
        path = Array<Direction>()
        let r = GKRandomSource()
        for _ in 1...Steps { // create duplicate of parent
            let direction = Direction(rawValue: r.nextInt(upperBound: 4))!
            path.append(direction)
        }
        positions = Array<CGPoint>() // not ran yet
        stepSize = 2
        alive = true
        node = SKSpriteNode(color: .red, size: CGSize(width: 5, height: 5))
        node.name = "player" + String(describing: i)
    }
    
    
    
    func fitness(goal: CGPoint) -> Float {
        var count = positions.count * 2
        var fitness: Float = 0
        
        
        if !alive {
            return fitness
        } else {
            for i in positions {
                let distance = CGPointDistance(from: i, to: goal)
                fitness += fitness * Float(distance)
                count -= 1
            }
        }
        
        return fitness
    }

    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt((from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y))
    }
    
    // MARK: - Create an array of positions from the path
    
    func createPositions(startPos: CGPoint, obstacles: Array<SKSpriteNode>) {
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
            node.position = currentPos
        }
        
        
        
    }
    
    // MARK:  - Change path by a percentage
    
    func mutate(Chance: Int) {
        let r = GKRandomSource()
        let n = r.nextInt(upperBound: 100)
        let oldPath = path
        path = Array<Direction>()
        for d in oldPath {
            if n > Chance {
                let direction = Direction(rawValue: r.nextInt(upperBound: 4))!
                path.append(direction)
            } else {
                path.append(d)
            }
        }
        
        
    }
    
    func draw() {
        for i in positions {
            node.position = i
        }
        
    }
    
}

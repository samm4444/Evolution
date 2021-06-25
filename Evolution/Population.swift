//
//  Population.swift
//  Evolution
//
//  Created by Samuel Miller on 17/06/2021.
//

import UIKit
import GameKit

class Population: NSObject {
    var players: Array<Player>
    var startingPosition: CGPoint
    var generation = 0
    
    init(Size: Int, Position: CGPoint, Steps: Int) { //  creates random players
        players = Array<Player>()
        startingPosition = Position
        for i in 1...Size {
            let player = Player(Steps: Steps, ID: i)
            players.append(player)
        }
        
    }
    
    func createPositions(obstacles: Array<SKSpriteNode>, goal: SKSpriteNode) {
        for p in players {
            p.createPositions(startPos: startingPosition, obstacles: obstacles, goal: goal)
            p.node.position = p.positions.last!
        }
    }
    
    // MARK: - Fitness Function
    
    func fittestPlayer(goal: CGPoint) -> Player {
        
        var fittnesses = Dictionary<Player,Float>()
        
        for p in players {
            fittnesses[p] = p.fitness(goal: goal)
        }
        let sorted = fittnesses.sorted { (first, second) -> Bool in // sort fitness from highest to lowest
            return first.value > second.value
        }
        /*
        for i in fittnesses {
            print(i.value)
        }*/
        var sum: Float = 0
        for i in fittnesses {
            sum += i.value
        }
        //print(String(describing: generation) + "," + String(describing: (sum / Float(fittnesses.count))) )
        
        return sorted[0].key // return the player with the highest fitness rating
    }
    
    // MARK: - Reproduction
    
    func reproduce(Parent: Player, Size: Int, MutationChance: Int) {
        players = Array<Player>()
        generation += 1
        for i in 1...Size { // create duplicate of parent
            let newPlayer = Player(Steps: Parent.path.count, ID: i)
            newPlayer.path = Parent.path
            
            players.append(newPlayer)
        }
        
        for p in players { // mutate from parent
            p.mutate(Chance: MutationChance)
        }
    }
    
    
    
}

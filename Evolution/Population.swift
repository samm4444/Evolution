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
    
    init(Size: Int, Position: CGPoint) { //  creates random players
        players = Array<Player>()
        startingPosition = Position
        for i in 1...Size {
            let player = Player(Steps: 1000, i: i)
            players.append(player)
        }
        
    }
    
    func createPositions(obstacles: Array<SKSpriteNode>) {
        for p in players {
            p.createPositions(startPos: startingPosition, obstacles: obstacles)
        }
    }
    
    // MARK: - Fitness Function
    
    func fittestPlayer(goal: CGPoint) -> Player {
        
        var fittnesses = Dictionary<Player,Float>()
        
        for p in players {
            fittnesses[p] = p.fitness(goal: goal)
        }
        let sorted = fittnesses.sorted { (first, second) -> Bool in
            return first.value > second.value
        }
        return sorted[0].key
    }
    
    // MARK: - Reproduction
    
    func reproduce(Parent: Player, Size: Int) {
        players = Array<Player>()
        
        for _ in 1...Size { // create duplicate of parent
            players.append(Parent)
        }
        
        for p in players { // mutate from parent
            p.mutate(Chance: 20)
        }
    }
    
    func draw() {
        for i in players {
            i.draw()
        }
    }
    
}

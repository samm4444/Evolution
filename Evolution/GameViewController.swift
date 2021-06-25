//
//  GameViewController.swift
//  Evolution
//
//  Created by Samuel Miller on 17/06/2021.
//

import UIKit
import SpriteKit
import GameplayKit

class GameViewController: UIViewController {
    
    var scene: SKScene?
    @IBOutlet weak var progressBar: UIProgressView!
    @IBOutlet weak var skipBarButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        progressBar.progress = 0
        
        
        if #available(iOS 14.0, *) {
            let skipFiveAction : UIAction = .init(title: "Skip 5", image: UIImage(named: "gear"), identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .off, handler: { (action) in
                (self.scene! as! GameScene).skip(generations: 5)
            })
            
            let skipTenAction : UIAction = .init(title: "Skip 10", image: UIImage(named: "gearshape.2.fill"), identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .off, handler: { (action) in
                (self.scene! as! GameScene).skip(generations: 10)
            })
            
            let skipTwentyAction : UIAction = .init(title: "Skip 20", image: UIImage(named: "gearshape.2.fill"), identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .off, handler: { (action) in
                (self.scene! as! GameScene).skip(generations: 20)
            })
            
            let skipFiftyAction : UIAction = .init(title: "Skip 50", image: UIImage(named: "gearshape.2.fill"), identifier: nil, discoverabilityTitle: nil, attributes: .init(), state: .off, handler: { (action) in
                (self.scene! as! GameScene).skip(generations: 50)
            })
            
            let actions = [skipFiveAction, skipTenAction, skipTwentyAction, skipFiftyAction]
            
            let menu = UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: actions)
            
            skipBarButton.menu = menu
        }
        
        
        if let view = self.view as! SKView? {
            // Load the SKScene from 'GameScene.sks'
            scene = SKScene(fileNamed: "GameScene")
            if (scene) != nil {
                // Set the scale mode to scale to fit the window
                scene!.scaleMode = .aspectFill
                
                (scene! as! GameScene).setProgress = .some({ progress in
                    self.progressBar.setProgress(progress, animated: true)
                })
                
                (scene! as! GameScene).setGeneration = .some({ generation in
                    self.title = "Generation " + String(describing: generation)
                })
                
                // Present the scene
                view.presentScene(scene!)
            }
            
            view.ignoresSiblingOrder = true
            
            view.showsFPS = true
            view.showsNodeCount = true
        }
        
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}

//
//  ViewController.swift
//  Shaker
//
//  Created by Shawn Roller on 4/5/18.
//  Copyright © 2018 Shawn Roller. All rights reserved.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {

    // Movement and physics
    var motion: CMMotionManager!
    var animator: UIDynamicAnimator!
    var gravity: UIGravityBehavior!
    var gravityVector = CGVector.zero
    var collision: UICollisionBehavior!
    
    // Views
    var redBlock: UIView!
    var blueBlock: UIView!
    var greenBlock: UIView!
    var yellowBlock: UIView!
    var blocks: [UIView] {
        return [redBlock, blueBlock, greenBlock, yellowBlock]
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        createBlocks()
        setupMotion()
        setupAnimator()
    }
    
    private func createBlocks() {
        redBlock = UIView(frame: CGRect(x: 50, y: 125, width: 100, height: 100))
        redBlock.layer.borderWidth = 1
        redBlock.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        redBlock.backgroundColor = #colorLiteral(red: 0.8549019694, green: 0.250980407, blue: 0.4784313738, alpha: 1)
        view.addSubview(redBlock)
        blueBlock = UIView(frame: CGRect(x: 165, y: 125, width: 100, height: 100))
        blueBlock.layer.borderWidth = 1
        blueBlock.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        blueBlock.backgroundColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        view.addSubview(blueBlock)
        greenBlock = UIView(frame: CGRect(x: 35, y: 0, width: 100, height: 100))
        greenBlock.layer.borderWidth = 1
        greenBlock.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        greenBlock.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        view.addSubview(greenBlock)
        yellowBlock = UIView(frame: CGRect(x: 180, y: 0, width: 100, height: 100))
        yellowBlock.layer.borderWidth = 1
        yellowBlock.layer.borderColor = #colorLiteral(red: 0.6000000238, green: 0.6000000238, blue: 0.6000000238, alpha: 1).cgColor
        yellowBlock.backgroundColor = #colorLiteral(red: 0.9686274529, green: 0.78039217, blue: 0.3450980484, alpha: 1)
        view.addSubview(yellowBlock)
    }

}

// MARK: - Motion
extension ViewController {
    
    private func setupMotion() {
        motion = CMMotionManager()
        motion.accelerometerUpdateInterval = 0.1
        guard let currentOperationQueue = OperationQueue.current else { return }
        motion.startAccelerometerUpdates(to: currentOperationQueue) { (data, error) in
            if let motionData = data {
                let motionVector = CGVector(dx: motionData.acceleration.x * 25, dy: motionData.acceleration.y * -25)
                self.setGravity(motionVector)
            }
        }
    }
    
    private func setGravity(_ vector: CGVector) {
        gravityVector = vector
        gravity.gravityDirection = gravityVector
    }
    
}

// MARK: - Dynamics
extension ViewController {
    
    private func setupAnimator() {
        // Setup the animator
        animator = UIDynamicAnimator(referenceView: view)
        gravity = UIGravityBehavior(items: blocks)
        animator.addBehavior(gravity)
        
        // Add collisions
        collision = UICollisionBehavior(items: blocks)
        collision.translatesReferenceBoundsIntoBoundary = true
        animator.addBehavior(collision)
        
        // Add elasticity
        let elasticity = UIDynamicItemBehavior(items: blocks)
        elasticity.elasticity = 0.5
        animator.addBehavior(elasticity)
    }
    
}

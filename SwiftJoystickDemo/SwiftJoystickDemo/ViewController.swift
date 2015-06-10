//
//  ViewController.swift
//  SwiftJoystickDemo
//
//  Created by TJ Fallon on 2/23/15.
//  Copyright (c) 2015 TJ Fallon. All rights reserved.
//

import UIKit

class ViewController: UIViewController, MFLSwiftJoystickDelegate {
    var balls:NSMutableArray? = nil;
    var animator:UIDynamicAnimator? = nil;
    var collisions:UICollisionBehavior? = nil;
    var gravity:UIGravityBehavior? = nil;
    var joystickPush:UIPushBehavior? = nil;
    @IBOutlet weak var joystick:MFLSwiftJoystickImplementation?;


    override func viewDidLoad() {
        super.viewDidLoad()

        var balls = [UIView]();

        animator = UIDynamicAnimator(referenceView:self.view);

        collisions = UICollisionBehavior()
        collisions?.translatesReferenceBoundsIntoBoundary = true;
        animator?.addBehavior(collisions)

        gravity = UIGravityBehavior()
        gravity?.gravityDirection = CGVectorMake(0, 1)
        animator?.addBehavior(gravity)

        joystickPush = UIPushBehavior(items:balls, mode:UIPushBehaviorMode.Continuous)
        animator?.addBehavior(joystickPush)

        joystick?.setupWithThumbAndBackgroundImages(UIImage(named:"joy_thumb.png")!, bgImage: UIImage(named:"stick_base.png")!);
        joystick?.delegate = self
    }


    @IBAction func createNewBall(sender: UIButton) {
        let ball:UIView = UIView(frame: CGRectMake(view.frame.size.width / 2, 60, 30, 30))
        ball.backgroundColor = UIColor.blueColor()
        ball.layer.cornerRadius = 15
        ball.layer.masksToBounds = true
        view.insertSubview(ball, atIndex:0)
        let ballPath:UIBezierPath = UIBezierPath(ovalInRect: ball.bounds)
        balls?.addObject(ball)
        let behaviorForBall = randomDynamicItemBehavior(ball)
        collisions?.addItem(ball)
        gravity?.addItem(ball)
        joystickPush?.addItem(ball)
        
    }
    func randomDynamicItemBehavior(item:UIDynamicItem) -> UIDynamicItemBehavior {
        let dynamicBehavior = UIDynamicItemBehavior(items: [item])
        let random:Float = Float(arc4random())
        dynamicBehavior.density = CGFloat((random % 5.0) / 10.0)
        dynamicBehavior.elasticity = CGFloat((random % 20.0) / 10.0 + 0.5)
        dynamicBehavior.friction = CGFloat((random % 5.0) / 10.0)
        dynamicBehavior.resistance = CGFloat((random % 4.0) / 10.0)
        dynamicBehavior.addAngularVelocity(CGFloat((random % 20.0) / 10.0), forItem: item)
        return dynamicBehavior
    }

    func joyStickDidUpdate(movement: CGPoint) {
        let random:CGFloat = CGFloat(arc4random());
        joystickPush?.pushDirection = CGVector(dx: movement.x * (random % 5.0), dy: movement.y * (random % 5.0))
        joystickPush?.active = true;
    }
}


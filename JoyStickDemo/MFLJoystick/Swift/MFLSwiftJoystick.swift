//
//  MFLSwiftJoystick.swift
//  JoyStickDemo
//
//  Created by TJ Fallon on 2/19/15.
//  Copyright (c) 2015 Foley. All rights reserved.
//

import Foundation
import UIKit

@objc public protocol MFLSwiftJoystickDelegate
{
    func joyStickDidUpdate(movement:CGPoint)
}

@objc public class MFLSwiftJoystickImplementation : UIView
{
    /*
    *   Below here be demons, and they're swift.
    */
    @IBOutlet public weak var delegate: MFLSwiftJoystickDelegate?;

    var smallestPossible: CGFloat               = 0.09;
    var moveViscosity: CGFloat                  = 4;
    var defaultPoint: CGPoint                   = CGPointZero;

    var bgImageView: UIImageView!;
    var thumbImageView: UIImageView!;
    var handle: UIView!;

    var isTouching                              = false;

    required public init(coder: NSCoder) {
        super.init(coder: coder)
        sharedInit();
    }

    override public init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }

    public func setMoveViscosityWithMinimum(viscosity: CGFloat, minimum: CGFloat) {
        moveViscosity = viscosity
        smallestPossible = minimum
    }

    public func setupWithThumbAndBackgroundImages(thumbImage: UIImage, bgImage: UIImage) {
        thumbImageView.image = thumbImage;
        bgImageView.image = bgImage;
    }

    func sharedInit() {
        roundViewToDiameter(self, newSize:bounds.size.width)

        bgImageView = UIImageView(frame:CGRectMake(0, 0, bounds.width, bounds.height));
        roundViewToDiameter(bgImageView, newSize:bgImageView.bounds.size.width)
        addSubview(bgImageView)


        makeHandle()
        animate()
        notifyDelegate()
    }

    func makeHandle() {
        handle = UIView(frame: CGRectMake(0, 0, 61, 61))
        handle.center = CGPointMake(bounds.size.width / 2,
            bounds.size.height/2)

        defaultPoint = handle.center
        roundViewToDiameter(handle, newSize: CGRectGetWidth(handle.bounds))
        self.addSubview(handle)

        thumbImageView = UIImageView(frame:handle.frame)
        self.addSubview(self.thumbImageView)
    }

    public override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        UIView.animateWithDuration(0.2) { () -> Void in
            self.alpha = 1;
        }
        self.touchesMoved(touches, withEvent: event)
    }

    public override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        if let myTouch: UITouch = touches.first as? UITouch {
            var currentPos = myTouch.locationInView(self)

            let selfCenter = CGPointMake((bounds.origin.x + bounds.size.width/2),
                (bounds.origin.y + bounds.size.height/2))
            let selfRadius = (bounds.size.width / 2) - 34;

            if (distanceBetweenTwoPoints(currentPos, point2: selfCenter) > selfRadius) {
                let vX = currentPos.x - selfCenter.x;
                let vY = currentPos.y - selfCenter.y;
                let magV = sqrt(vX*vX + vY*vY);
                currentPos.x = selfCenter.x + vX / magV * selfRadius;
                currentPos.y = selfCenter.y + vY / magV * selfRadius;
            }

            UIView.animateWithDuration(0.1) { () -> Void in
                self.thumbImageView.center = currentPos;
            }

            handle.center = currentPos;
            isTouching = true
            notifyDelegate();
        }
    }

    public override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        UIView.animateWithDuration(0.4) { () -> Void in
            self.alpha = 0.1;
        }
        delegate?.joyStickDidUpdate(CGPointZero)
        isTouching = false
    }

    func isPointInCircleOfRadiusWithCenter(point: CGPoint, center: CGPoint, radius: CGFloat) -> Bool {
        let deltaX = Float((point.x-center.x))
        let xSquared = powf(deltaX, 2);

        let deltaY = Float((point.y-center.y))
        let ySquared = powf(deltaY, 2);

        let xPointPow = center.x;

        return ((xSquared + ySquared) < powf(Float(radius), 2.0));
    }

    func animate() {

        if (!isTouching) {
            //move the handle back to the default position
            var newX:Float = Float(handle.center.x)
            var newY:Float = Float(handle.center.y)
            let dx = fabsf(newX - Float(defaultPoint.x))
            let dy = fabsf(newY - Float(defaultPoint.y))

            let floatMV = Float(moveViscosity)
            if (handle.center.x > defaultPoint.x) {
                newX = newX - dx/floatMV
            } else if (handle.center.x < defaultPoint.x) {
                newX = newX + dx/floatMV
            }

            if (handle.center.y > defaultPoint.y) {
                newY = newY - dy/Float(moveViscosity)
            } else if (handle.center.y < defaultPoint.y) {
                newY = newY + dy/Float(moveViscosity)
            }

            if (Float(fabsf(dx/floatMV)) < Float(smallestPossible) &&
                Float(fabsf(dy/floatMV)) < Float(smallestPossible))
            {
                newX = Float(defaultPoint.x)
                newY = Float(defaultPoint.y)
            }

            handle.center = CGPointMake(CGFloat(newX), CGFloat(newY))
            thumbImageView.center = handle.center
        }
        var dispatchTime: dispatch_time_t = dispatch_time(DISPATCH_TIME_NOW, Int64(1.0/45.0 * Double(NSEC_PER_SEC)))
        dispatch_after(dispatchTime, dispatch_get_main_queue()) { () -> Void in
            self.animate()
        }
    }

    func notifyDelegate() {
        if (isTouching) {
            let positionX = (CGRectGetMinX(handle.frame) / CGRectGetWidth(handle.frame) - 0.55) * 2.0;
            let positionY = (CGRectGetMinY(handle.frame) / CGRectGetHeight(handle.frame) - 0.55) * 2.0;
            let degreeOfPosition = CGPointMake(positionX, positionY)
            [delegate?.joyStickDidUpdate(degreeOfPosition)];
        }
    }

    func roundViewToDiameter(roundedView: UIView, newSize:CGFloat) {
        let saveCenter = roundedView.center;
        let newFrame = CGRect(x:roundedView.frame.origin.x,
            y:roundedView.frame.origin.y,
            width:newSize,
            height:newSize)
        roundedView.frame = newFrame;
        roundedView.layer.cornerRadius = newSize / 2.0
        roundedView.center = saveCenter
    }
    
    func distanceBetweenTwoPoints(point1: CGPoint, point2: CGPoint) -> CGFloat {
        let dx = point2.x - point1.x
        let dy = point2.y - point1.y
        let distance = sqrt((dx * dx) + (dy * dy));
        return distance;
    }
    
}
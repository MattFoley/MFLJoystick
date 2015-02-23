// Playground - noun: a place where people can play

import UIKit
import MFLSwiftJoystick

var str = "Hello, playground"

let view: UIView = UIView(frame: CGRectMake(0, 0, 320, 568));

let ball: UIView = UIView(frame: CGRectMake(0, 0, 40, 40));
ball.layer.cornerRadius = 20;
ball.backgroundColor = UIColor.blueColor();
view .addSubview(ball);


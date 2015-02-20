//
//  ViewController.m
//  JoyStickDemo
//
//  Created by teejay on 5/14/13.
//  Copyright (c) 2013 teejay. All rights reserved.
//


#import "ViewController.h"
#import "MFLJoystick.h"
#import "JoystickDemo-Swift.h"

@interface ViewController () <JoystickDelegate, MFLSwiftJoystickDelegate>

@property (weak) IBOutlet UIView *playerObjC;
@property (weak) IBOutlet UIView *playerSwift;

@property (weak) IBOutlet MFLJoystick *objcJoystick;
@property (weak) IBOutlet MFLSwiftJoystickImplementation *swiftJoystick;

@property CGPoint playerObjCOrigin;
@property CGPoint playerSwiftOrigin;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playerObjCOrigin = self.playerObjC.frame.origin;
        self.playerSwiftOrigin = self.playerSwift.frame.origin;

    [self.objcJoystick setThumbImage:[UIImage imageNamed:@"joy_thumb.png"]
                          andBGImage:[UIImage imageNamed:@"stick_base.png"]];

    [self.swiftJoystick setupWithThumbAndBackgroundImages:[UIImage imageNamed:@"joy_thumb.png"]
                                                  bgImage:[UIImage imageNamed:@"stick_base.png"]];
    [self.swiftJoystick setDelegate:self];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)joystick:(MFLJoystick *)aJoystick didUpdate:(CGPoint)dir
{
    CGPoint newpos = self.playerObjCOrigin;
    newpos.x = 30.0 * dir.x + newpos.x;
    newpos.y = 30.0 * dir.y + newpos.y;
    CGRect fr = self.playerObjC.frame;
    fr.origin = newpos;
    self.playerObjC.frame = fr;
}

- (void)joyStickDidUpdate:(CGPoint)movement
{
    CGPoint newpos = self.playerSwiftOrigin;
    newpos.x = 30.0 * movement.x + newpos.x;
    newpos.y = 30.0 * movement.y + newpos.y;
    CGRect fr = self.playerSwift.frame;
    fr.origin = newpos;
    self.playerSwift.frame = fr;
}

@end

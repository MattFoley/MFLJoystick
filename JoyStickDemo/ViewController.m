//
//  ViewController.m
//  JoyStickDemo
//
//  Created by teejay on 5/14/13.
//  Copyright (c) 2013 teejay. All rights reserved.
//


#import "ViewController.h"
#import "MFLJoystick.h"
@interface ViewController () <JoystickDelegate>

@property (weak) IBOutlet UIView *player;
@property CGPoint playerOrigin;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.playerOrigin = self.player.frame.origin;
    
    MFLJoystick *joystick = [[MFLJoystick alloc] initWithFrame:CGRectMake(40, 90, 128, 128)];
    [joystick setThumbImage:[UIImage imageNamed:@"joy_thumb.png"]
                 andBGImage:[UIImage imageNamed:@"stick_base.png"]];
    [joystick setDelegate:self];
    [self.view addSubview:joystick];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)joystick:(MFLJoystick *)aJoystick didUpdate:(CGPoint)dir
{
    NSLog(@"%@", NSStringFromCGPoint(dir));
    CGPoint newpos = self.playerOrigin;
    newpos.x = 30.0 * dir.x + self.playerOrigin.x;
    newpos.y = 30.0 * dir.y + self.playerOrigin.y;
    CGRect fr = self.player.frame;
    fr.origin = newpos;
    self.player.frame = fr;
}

@end

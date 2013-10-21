//
//  ViewController.m
//  Flipper
//
//  Created by Stuart Hall on 15/10/2013.
//  Copyright (c) 2013 Stuart Hall. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIDynamicAnimator *animator;
@property (nonatomic, strong) UIGravityBehavior *gravityBehavior;
@property (nonatomic, strong) UICollisionBehavior *collisionBehavior;
@property (nonatomic, strong) UIDynamicItemBehavior *bounceBehaviour;

@end

@implementation ViewController

static NSInteger const kBallSize = 40;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Simple tap gesture
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [self.view addGestureRecognizer:tapGesture];
    
    // Create our animator, we retain this ourselves
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view];
    
    // Gravity
    self.gravityBehavior = [[UIGravityBehavior alloc] initWithItems:@[ ]];
    self.gravityBehavior.magnitude = 10;
    [self.animator addBehavior:self.gravityBehavior];
    
    // Collision - make a fake platform
    self.collisionBehavior = [[UICollisionBehavior alloc] initWithItems:@[ ]];
    [self.collisionBehavior addBoundaryWithIdentifier:@"bottom"
                                       fromPoint:CGPointMake(0, 300)
                                         toPoint:CGPointMake(568, 300)];
    self.collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:self.collisionBehavior];
    
    // Bounce!
    self.bounceBehaviour = [[UIDynamicItemBehavior alloc] initWithItems:@[ ]];
    self.bounceBehaviour.elasticity = 0.6;
    [self.animator addBehavior:self.bounceBehaviour];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - Gesture Recognizer

- (void)onTap:(UITapGestureRecognizer*)gesture
{
    if (gesture.state == UIGestureRecognizerStateEnded) {
        // Grab the x of the touch for the center of our ball
        // Ignore the y, we'll drop from the top
        CGPoint pt = [gesture locationInView:self.view];
        [self dropBallAtX:pt.x];
    }
}

#pragma mark - Helpers

- (void)dropBallAtX:(CGFloat)x
{
    // Create a ball and add it to our view
    UIView *ball = [[UIView alloc] initWithFrame:CGRectMake(x - (kBallSize/2), 0, kBallSize, kBallSize)];
    ball.backgroundColor = [UIColor redColor];
    ball.layer.cornerRadius = kBallSize/2;
    ball.layer.masksToBounds = YES;
    [self.view addSubview:ball];
    
    // Add some gravity
    [self.gravityBehavior addItem:ball];
    
    // Add the collision
    [self.collisionBehavior addItem:ball];
    
    // Add the bounce
    [self.bounceBehaviour addItem:ball];
}

@end

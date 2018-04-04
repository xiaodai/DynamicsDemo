//
//  ViewController.m
//  DynamicsDemo
//
//  Created by yangaichun on 2018/4/3.
//  Copyright © 2018年 yangaichun. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollisionBehaviorDelegate>
@property (weak, nonatomic) IBOutlet UIView *view1;
@property (weak, nonatomic) IBOutlet UIView *view2;
@property (strong,nonatomic)UIDynamicAnimator *animator;
@property (strong,nonatomic)UIAttachmentBehavior *attachmentBehavior;
@property (strong,nonatomic)UIAttachmentBehavior *attachmentBehavior2;
@property (strong,nonatomic)UISnapBehavior *snapBehavior;
@property (strong,nonatomic)UIPushBehavior *pushBehavior;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.animator = [[UIDynamicAnimator alloc]initWithReferenceView:self.view];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //添加重力效果
    //[self addGravityBehavior];
    //添加碰撞
    //[self addCollisionBehavior];
    //添加连接和弹簧效果
    //[self addAttachmentBehavior];
    //添加吸附效果
    //[self addSnapBehavior];
    //添加push效果
    [self addPushBehavior];
}

- (void)addGravityBehavior{
    UIGravityBehavior *gravityBehavior = [[UIGravityBehavior alloc]initWithItems:@[self.view1,self.view2]];
    [gravityBehavior setAngle:M_PI/2 magnitude:0.1];
    [self.animator addBehavior:gravityBehavior];
}

- (void)addCollisionBehavior{
    UICollisionBehavior *collisionBehavior = [[UICollisionBehavior alloc]initWithItems:@[self.view1,self.view2]];
    [collisionBehavior setCollisionMode:UICollisionBehaviorModeItems];
    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    collisionBehavior.collisionDelegate = self;
    [self.animator addBehavior:collisionBehavior];
}

- (void)addAttachmentBehavior{
    CGPoint view1Center = CGPointMake(self.view1.center.x, self.view1.center.y);
    self.attachmentBehavior = [[UIAttachmentBehavior alloc]initWithItem:self.view1 attachedToAnchor:view1Center];
    [self.attachmentBehavior setFrequency:1.0f];
    [self.attachmentBehavior setDamping:0.1f];
    self.attachmentBehavior2 = [[UIAttachmentBehavior alloc]initWithItem:self.view2 attachedToAnchor:view1Center];
    [self.animator addBehavior:self.attachmentBehavior];
    [self.animator addBehavior:self.attachmentBehavior2];
    
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handleAttachmentGesture:)];
    [self.view1 addGestureRecognizer:pan];
}

- (void)handleAttachmentGesture:(UIPanGestureRecognizer *)panGesture{
    CGPoint gesturePoint = [panGesture locationInView:self.view];
    self.view1.center = gesturePoint;
    [self.attachmentBehavior setAnchorPoint:gesturePoint];
    [self.attachmentBehavior2 setAnchorPoint:gesturePoint];
}

- (void)addSnapBehavior{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapGesture:)];
    [self.view addGestureRecognizer:tap];
}

- (void)handleTapGesture:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self.view];
    if (!self.snapBehavior) {
        self.snapBehavior = [[UISnapBehavior alloc]initWithItem:self.view1 snapToPoint:point];
        self.snapBehavior.damping = 0.75;
        [self.animator addBehavior:self.snapBehavior];
   }else{
        self.snapBehavior.snapPoint = point;
    }
}

- (void)addPushBehavior{
    UIPushBehavior *pushBehavior = [[UIPushBehavior alloc]initWithItems:@[self.view1] mode:UIPushBehaviorModeInstantaneous];
    pushBehavior.angle = 0;
    pushBehavior.magnitude = 0;
    self.pushBehavior = pushBehavior;
    [self.animator addBehavior:pushBehavior];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handlePushTapGesture:)];
    [self.view addGestureRecognizer:tap];
}

- (void)handlePushTapGesture:(UITapGestureRecognizer *)gesture{
    CGPoint point = [gesture locationInView:self.view];
    CGPoint origin = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
    CGFloat distance = sqrtf(powf(point.x-origin.x, 2)+powf(point.y-origin.y, 2));
    CGFloat angle = atan2(point.y-origin.y, point.x-origin.x);
    distance = MIN(distance,100);
    [self.pushBehavior setMagnitude:distance/100];
    [self.pushBehavior setAngle:angle];
    [self.pushBehavior setActive:YES];
}

#pragma mark- collisionDelegate
- (void)collisionBehavior:(UICollisionBehavior *)behavior beganContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2 atPoint:(CGPoint)p;{
    
}
- (void)collisionBehavior:(UICollisionBehavior *)behavior endedContactForItem:(id <UIDynamicItem>)item1 withItem:(id <UIDynamicItem>)item2;{
    
}

// The identifier of a boundary created with translatesReferenceBoundsIntoBoundary or setTranslatesReferenceBoundsIntoBoundaryWithInsets is nil
- (void)collisionBehavior:(UICollisionBehavior*)behavior beganContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier atPoint:(CGPoint)p;{
    
}
- (void)collisionBehavior:(UICollisionBehavior*)behavior endedContactForItem:(id <UIDynamicItem>)item withBoundaryIdentifier:(nullable id <NSCopying>)identifier;{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

//
//  CustomNavigationController.m
//  CustomNavigationBehav
//
//  Created by Matteo Battistini on 04/11/15.
//  Copyright © 2015 MB. All rights reserved.
//

#import "CustomNavigationController.h"
#import "CustomNavigationBar.h"
#import "UIView+Extensions.h"


#define SMOOTH_FACTOR 0.1
#define HIDE_SHOW_PERCENTAGE 0.9
#define HEIGHT_TO_HIDE 35

@interface CustomNavigationController () <UIGestureRecognizerDelegate>


@end

@implementation CustomNavigationController
{
    CGFloat _navBarHeight;
    CGFloat _minNavBarHeight;
    CGFloat _firstY;
    CGFloat _heightToHide;
}

-(instancetype)initWithNavigationBarClass:(Class)navigationBarClass
                              navBarHight:(CGFloat)height
                             toolbarClass:(Class)toolbarClass;
{
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) {
        _navBarHeight = height;
        _minNavBarHeight = _navBarHeight - HEIGHT_TO_HIDE;
        self.customNavigationBar.height = _navBarHeight;
    }
    return self;
}

-(instancetype)initWithNavigationBarClass:(Class)navigationBarClass
                              navBarHight:(CGFloat)height
                             heightToHIde:(CGFloat)heightToHide
                             toolbarClass:(Class)toolbarClass
{
    self = [super initWithNavigationBarClass:navigationBarClass toolbarClass:toolbarClass];
    if (self) {
        _navBarHeight = height;
        _heightToHide = heightToHide;
        _minNavBarHeight = _navBarHeight - ((_heightToHide > 0) ? _heightToHide : HEIGHT_TO_HIDE);
        self.customNavigationBar.height = _navBarHeight;
    }
    return self;
}


-(void)viewDidLoad
{
    [super viewDidLoad];
    /* default navigation bar hide on swipe mode
    self.hidesBarsOnSwipe = YES;
    [self.barHideOnSwipeGestureRecognizer addTarget:self action:@selector(panGestureRecognizer:)];
     */
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureRecognizer:)];
    pan.delegate = self;
    [self.view addGestureRecognizer:pan];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

-(CustomNavigationBar *)customNavigationBar
{
    if ([self.navigationBar isKindOfClass:[CustomNavigationBar class]]) {
        return (CustomNavigationBar *)self.navigationBar;
    } else {
        return nil;
    }
}

-(void)hideNavigationBar
{
    [UIView animateWithDuration:0.3 animations:^{
        self.customNavigationBar.height = _minNavBarHeight;
    } completion:^(BOOL finished) {
        
    }];
}

-(void)showNavigationBar
{
    [UIView animateWithDuration:0.3 animations:^{
        self.customNavigationBar.height = _navBarHeight;
    } completion:^(BOOL finished) {
        
    }];
}


-(void)panGestureRecognizer:(UIPanGestureRecognizer *)gesture;
{
    CGPoint translation =  [gesture translationInView:gesture.view];
    CGPoint velocity = [gesture velocityInView:gesture.view];

    
    if (gesture.state == UIGestureRecognizerStateEnded) {
        if (self.customNavigationBar.height >=  _navBarHeight * HIDE_SHOW_PERCENTAGE) {
            [self showNavigationBar];
        } else {
            [self hideNavigationBar];
        }
    }
    
    
    if (gesture.state == UIGestureRecognizerStateChanged) {
        
        
// velocity filter
        if (velocity.y > 2300) {
            [self showNavigationBar];
            return;
        }
        
        if (velocity.y < -2300) {
            [self hideNavigationBar];
            return;
        }
        
        
        CGFloat smoothTanslationY = (translation.y * SMOOTH_FACTOR);
        CGFloat newheight = (self.customNavigationBar.height + smoothTanslationY);
        
// border collision
        if (newheight <= _minNavBarHeight ) {
            newheight = _minNavBarHeight;
        }
        
        if (newheight >= _navBarHeight ) {
            newheight = _navBarHeight;
        }
        
// set new height
        self.customNavigationBar.height = newheight;
    }

    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return NO;
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

@end

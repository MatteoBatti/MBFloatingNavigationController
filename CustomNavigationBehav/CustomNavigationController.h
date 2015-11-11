//
//  CustomNavigationController.h
//  CustomNavigationBehav
//
//  Created by Matteo Battistini on 04/11/15.
//  Copyright © 2015 MB. All rights reserved.
//

#import <UIKit/UIKit.h>
@class  CustomNavigationBar;

@interface CustomNavigationController : UINavigationController

@property (nonatomic, readonly) CustomNavigationBar *customNavigationBar;

-(instancetype)initWithNavigationBarClass:(Class)navigationBarClass
                              navBarHight:(CGFloat)height
                             toolbarClass:(Class)toolbarClass;

@end

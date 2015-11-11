//
//  CustomNavigationBar.m
//  CustomNavigationBehav
//
//  Created by Matteo Battistini on 04/11/15.
//  Copyright © 2015 MB. All rights reserved.
//

#import "CustomNavigationBar.h"

@implementation CustomNavigationBar

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

//   self.clipsToBounds = YES; not usefull, the status bar should be clear


        
    }
    return self;
}

-(CGSize)sizeThatFits:(CGSize)size
{
    return CGSizeMake(self.superview.frame.size.width, _height);
}

-(void)setHeight:(CGFloat)height;{
    _height = height;
    CGRect r = {self.frame.origin.x, self.frame.origin.y, self.frame.size.width, _height};
    self.frame = r;
}


@end

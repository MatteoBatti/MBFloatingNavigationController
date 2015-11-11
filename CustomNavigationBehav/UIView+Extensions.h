
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@interface UIView (ObjectTag)
@property (nonatomic, strong) id objectTag;
-(UIView*)viewWithObjectTag:(id)object;
@end


@interface UIView (Frame)
@property CGPoint position;
@property CGFloat x;
@property CGFloat y;
@property CGSize size;
@property CGFloat width;
@property CGFloat height;
@property (readonly) CGFloat relativeWidth;
@property (readonly) CGFloat relativeHeight;
@property CGPoint anchorPoint;
@property CGSize scale;
@property CGFloat rotation;
@property CGPoint translation;
@property CGFloat rotationDegree;
@property CGFloat rotationX;
@property CGFloat rotationY;
@property CGFloat rotationZ;    
@property CGFloat rotationXDegree;
@property CGFloat rotationYDegree;
@property CGFloat rotationZDegree;

-(void)fitToSuperview:(UIView *)superview;

-(void)setScale:(CGSize)scale;
-(void)setRotation:(CGFloat)rotation;
-(void)setRotationDegree:(CGFloat)rotation;

-(void)setRotationX:(CGFloat)ratation;
-(void)setRotationY:(CGFloat)ratation;
-(void)setRotationZ:(CGFloat)ratation;
-(void)setRotationXDegree:(CGFloat)ratation;
-(void)setRotationYDegree:(CGFloat)ratation;
-(void)setRotationZDegree:(CGFloat)ratation;


@end

@interface UIView (Utility)
-(void) addSubviews:(UIView*)view, ... NS_REQUIRES_NIL_TERMINATION;
-(void) removeAllSubviews;
@end

@interface UIView (Image)
-(UIImage *) viewImage;
@end


@interface UIView (AnimationsHandler)

- (void)pauseAnimations;
- (void)resumeAnimations;

@end
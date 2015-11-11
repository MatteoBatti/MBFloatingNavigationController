
#define RADIANS_TO_DEGREES(radians) ((radians) * (180.0 / M_PI))
#define DEGREES_TO_RADIANS(angle) ((angle) / 180.0 * M_PI)


#import "UIView+Extensions.h"
#import <objc/runtime.h>

static char const * const ObjectTagKey = "ObjectTag";

@implementation UIView (ObjectTag)
@dynamic objectTag;
- (id)objectTag {
    return objc_getAssociatedObject(self, ObjectTagKey);
}

- (void)setObjectTag:(id)newObjectTag {
    objc_setAssociatedObject(self, ObjectTagKey, newObjectTag, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)viewWithObjectTag:(id)object {
    // Raise an exception if object is nil
    if (object == nil) {
        [NSException raise:NSInternalInconsistencyException format:@"Argument to -viewWithObjectTag: must not be nil"];
    }
    
    if ([self.objectTag isEqual:object]) {
        return self;
    }
    for (UIView *subview in self.subviews) {
        UIView *resultView = [subview viewWithObjectTag:object];
        if (resultView != nil) {
            return resultView;
        }
    }
    return nil;
}
@end

@implementation UIView (Frame)
@dynamic relativeWidth;
@dynamic relativeHeight;
@dynamic anchorPoint;


- (CGPoint)position {
    return [self frame].origin;
}

- (void)setPosition:(CGPoint)position {
    CGRect rect = [self frame];
    rect.origin = position;
    [self setFrame:rect];
}

- (CGFloat)x {
    return [self frame].origin.x;
}

- (void)setX:(CGFloat)x {
    CGRect rect = [self frame];
    rect.origin.x = x;
    [self setFrame:rect];
}

- (CGFloat)y {
    return [self frame].origin.y;
}

- (void)setY:(CGFloat)y {
    CGRect rect = [self frame];
    rect.origin.y = y;
    [self setFrame:rect];
}

- (CGSize)size {
    return [self frame].size;
}

- (void)setSize:(CGSize)size {
    CGRect rect = [self frame];
    rect.size = size;
    [self setFrame:rect];
}

- (CGFloat)width {
    return [self frame].size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect rect = [self frame];
    rect.size.width = width;
    [self setFrame:rect];
}

- (CGFloat)relativeWidth {
    return self.x + self.width;
}

- (CGFloat)height {
    return [self frame].size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect rect = [self frame];
    rect.size.height = height;
    [self setFrame:rect];
}

- (CGFloat)relativeHeight {
    return self.y + self.height;
}

-(void)setAnchorPoint:(CGPoint)anchorPoint {
    CGPoint newPoint = CGPointMake(self.bounds.size.width * anchorPoint.x, self.bounds.size.height * anchorPoint.y);
    CGPoint oldPoint = CGPointMake(self.bounds.size.width * self.layer.anchorPoint.x, self.bounds.size.height * self.layer.anchorPoint.y);
    
    newPoint = CGPointApplyAffineTransform(newPoint, self.transform);
    oldPoint = CGPointApplyAffineTransform(oldPoint, self.transform);
    
    CGPoint position = self.layer.position;
    
    position.x -= oldPoint.x;
    position.x += newPoint.x;
    
    position.y -= oldPoint.y;
    position.y += newPoint.y;
    
    self.layer.position = position;
    self.layer.anchorPoint = anchorPoint;
}
-(CGPoint) anchorPoint {
    return self.layer.anchorPoint;
}
CGAffineTransform makeTransform(CGFloat xScale, CGFloat yScale,
                                CGFloat theta, CGFloat tx, CGFloat ty)
{
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    transform.a = xScale * cos(theta);
    transform.b = yScale * sin(theta);
    transform.c = xScale * -sin(theta);
    transform.d = yScale * cos(theta);
    transform.tx = tx;
    transform.ty = ty;
    
    return transform;
}
-(void) setScale:(CGSize)scale {
    
    self.transform = makeTransform(scale.width, scale.height, self.rotation, self.translation.x, self.translation.y);
    
}
-(CGSize) scale {
    
    CGAffineTransform t = self.transform;
    
    CGFloat xScale = sqrt(t.a * t.a + t.c * t.c);
    CGFloat yScale = sqrt(t.b * t.b + t.d * t.d);
    
    return CGSizeMake(xScale, yScale);
}
-(void) setRotation:(CGFloat)rotation {
    
    self.transform = makeTransform(self.scale.width, self.scale.height, rotation, self.translation.x, self.translation.y);
    
}
-(CGFloat) rotation {
    
    CGAffineTransform t = self.transform;
    
    return atan2f(t.b, t.a);
    
}

-(void)setRotationDegree:(CGFloat) degree
{
    [self setRotation:RADIANS_TO_DEGREES(degree)];
}

-(CGFloat)rotationDegree
{
    return DEGREES_TO_RADIANS(self.rotation);
}

-(void) setTranslation:(CGPoint)translation {
    
    self.transform = makeTransform(self.scale.width, self.scale.height, self.rotation, translation.x, translation.y);
    
}
-(CGPoint) translation {
    
    CGAffineTransform t = self.transform;
    
    return CGPointMake(t.tx, t.ty);
    
}

-(CGFloat)rotationX
{
    return atan2(self.layer.transform.m32, self.layer.transform.m33);
}

-(CGFloat)rotationXDegree
{
    return RADIANS_TO_DEGREES(self.rotationX);
}

-(CGFloat)rotationY
{
    return atan2(-self.layer.transform.m31, sqrt(self.layer.transform.m32 * self.layer.transform.m32 + self.layer.transform.m33 * self.layer.transform.m33));
}

-(CGFloat)rotationYDegree
{
    return RADIANS_TO_DEGREES(self.rotationY);
}

-(CGFloat)rotationZ
{
    return atan2(self.layer.transform.m21, self.layer.transform.m11);
}

-(CGFloat)rotationZDegree
{
    return RADIANS_TO_DEGREES(self.rotationZ);
}

-(void)setRotationX:(CGFloat) rotation
{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/ -500;
    t = CATransform3DRotate(t, rotation, 1, 0, 0);
    self.layer.transform = t;
}

-(void)setRotationY:(CGFloat) rotation
{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/ -500;
    t = CATransform3DRotate(t, rotation, 0, 1, 0);
    self.layer.transform = t;
}

-(void)setRotationZ:(CGFloat) rotation
{
    CATransform3D t = CATransform3DIdentity;
    t.m34 = 1.0/ -500;
    t = CATransform3DRotate(t, rotation, 0, 0, 1);
    self.layer.transform = t;
}

-(void)setRotationXDegree:(CGFloat) rotation
{
    [self setRotationX:DEGREES_TO_RADIANS(rotation)];
}

-(void)setRotationYDegree:(CGFloat) rotation
{
    [self setRotationY:DEGREES_TO_RADIANS(rotation)];
}

-(void)setRotationZDegree:(CGFloat) rotation
{
    [self setRotationZ:DEGREES_TO_RADIANS(rotation)];
}

-(void)fitToSuperview:(UIView *)superview;
{
    self.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *width =[NSLayoutConstraint
                                constraintWithItem:self
                                attribute:NSLayoutAttributeWidth
                                relatedBy:0
                                toItem:superview
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                constant:0];
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:self
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:superview
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:self
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:superview
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:0.f];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:self
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:superview
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    [superview addConstraint:width];
    [superview addConstraint:height];
    [superview addConstraint:top];
    [superview addConstraint:leading];
    
    [self setNeedsUpdateConstraints];
}

@end

@implementation UIView (Utility)

-(void) addSubviews:(UIView *)view, ... {
    
    va_list args;
    va_start(args, view);
    for (UIView *arg = view; arg != nil; arg = va_arg(args, UIView*))
    {
        [self addSubview:arg];
    }
    va_end(args);
    
}

-(void) removeAllSubviews {
    for (UIView *subview in self.subviews) {
        [subview removeFromSuperview];
    }
}

@end


@implementation UIView (Image)
-(UIImage *) viewImage {
    if(UIGraphicsBeginImageContextWithOptions != NULL) {
        UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0.0);
    } else {
        UIGraphicsBeginImageContext(self.frame.size);
    }
    
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@implementation UIView (AnimationsHandler)

- (void)pauseAnimations;
{
    CFTimeInterval paused_time = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    self.layer.speed = 0.0;
    self.layer.timeOffset = paused_time;
}

- (void)resumeAnimations;
{
    CFTimeInterval paused_time = [self.layer timeOffset];
    self.layer.speed = 1.0f;
    self.layer.timeOffset = 0.0f;
    self.layer.beginTime = 0.0f;
    CFTimeInterval time_since_pause = [self.layer convertTime:CACurrentMediaTime() fromLayer:nil] - paused_time;
    self.layer.beginTime = time_since_pause;
}

@end


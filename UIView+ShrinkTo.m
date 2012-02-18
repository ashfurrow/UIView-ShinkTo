//
//  UIView+ShrinkTo.m
//  ShrinkToExample
//
//  Created by Ash Furrow on 12-02-18.
//  Copyright (c) 2012 500px. All rights reserved.
//

#import "UIView+ShrinkTo.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView (ShrinkTo)

static NSMutableArray *queue;

-(void)shrinkToCenterOfView:(UIView *)targetView 
{
    [self shrinkToPoint:targetView.center inView:targetView];
}

-(void)shrinkToPoint:(CGPoint)thePoint inView:(UIView *)theTargetView 
{
    if (!queue)
        queue = [[NSMutableArray alloc] init];
    UIView *sharedSuperView = self.superview;
    while (![theTargetView isDescendantOfView:sharedSuperView])
    {
        sharedSuperView = [sharedSuperView superview];
        if (sharedSuperView == nil)
        {
            NSLog(@"We couldn't find a common ancester view to re-add the cell to.");
            return;
        }
    }
    
    CGRect newFrame = [self.superview convertRect:self.frame toView:sharedSuperView];
    CGPoint targetPointInSharedSuperview = [sharedSuperView convertPoint:thePoint fromView:theTargetView];
    
    UIImage *viewImage;
    
    UIGraphicsBeginImageContext(self.bounds.size);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    UIImageView *imageView = [[[UIImageView alloc] initWithImage:viewImage] autorelease];
    imageView.frame = newFrame;
    [sharedSuperView addSubview:imageView];
    
    //These animations scale the view down, reduce it's opacity, and move it along a bezier curve
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    scaleAnim.removedOnCompletion = NO;
    scaleAnim.duration = SHRINK_ANIMATION_DURATION;
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
    opacityAnim.removedOnCompletion = NO;
    opacityAnim.duration = SHRINK_ANIMATION_DURATION;
    
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    CGPoint ctlPoint = CGPointMake(imageView.center.x, targetPointInSharedSuperview.y);
    [movePath moveToPoint:imageView.center];
    [movePath addQuadCurveToPoint:targetPointInSharedSuperview controlPoint:ctlPoint];
    
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = NO;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
    animGroup.delegate = self;
    [imageView.layer addAnimation:animGroup forKey:nil];
    
    [queue insertObject:imageView atIndex:0];
}

//after we're done animating, we need to remove ourselves from the view so we don't "hang around" on the screen
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!flag) return;
    
    UIImageView *imageView = [queue lastObject];
    [imageView removeFromSuperview];
    [queue removeLastObject];
}

@end

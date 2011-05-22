//Copyright (C) 2011 by Ash Furrow
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN

#import "UITableViewCell+ShrinkTo.h"

#import <QuartzCore/QuartzCore.h>

@implementation UITableViewCell (ShrinkTo)

-(void)shrinkToCenterOfView:(UIView *)targetView fromTableView:(UITableView *)theTableView withRemoveFromDataSourceBlock:(void (^)())block
{
    [self shrinkToPoint:[self convertPoint:targetView.center fromView:targetView] inView:targetView fromTableView:theTableView withRemoveFromDataSourceBlock:block];
}

-(void)shrinkToPoint:(CGPoint)thePoint inView:(UIView *)targetView fromTableView:(UITableView *)theTableView withRemoveFromDataSourceBlock:(void (^)())block
{
    NSIndexPath *indexPath = [theTableView indexPathForCell:self];

    //This block should remove the item represented by the cell from the table view's datasource object. Tnis is important, since
    //we're calling deleteRowsAtIndexPaths:withRowAnimations later and we'll get an NSInternalConsistencyException if the 
    //table view differs from its datasource
    block();
    
    //we're removing ourselves from our superview before we add ourselves somehwere else - we don't want to get accidentally dealloc'd!
    [[self retain] autorelease];
    
    UIView *superview = theTableView;
    while (![self isDescendantOfView:superview])
    {
        superview = [superview superview];
        if (superview == nil)
        {
            NSLog(@"We couldn't find a common ancester view to re-add the cell to.");
            return;
        }
    }
    
    //we're essetially swapping the cell from the table view to a common view ancestor so that we don't get clipped
    [theTableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [theTableView.superview addSubview:self];
    
    //These animations scale the cell down, reduce it's opacity, and move it along a bezier curve
    CABasicAnimation *scaleAnim = [CABasicAnimation animationWithKeyPath:@"transform"];
    scaleAnim.fromValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
    scaleAnim.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.1, 0.1, 1.0)];
    scaleAnim.removedOnCompletion = NO;
    
    CABasicAnimation *opacityAnim = [CABasicAnimation animationWithKeyPath:@"alpha"];
    opacityAnim.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnim.toValue = [NSNumber numberWithFloat:0.1];
    opacityAnim.removedOnCompletion = NO;
    
    UIBezierPath *movePath = [UIBezierPath bezierPath];
    CGPoint ctlPoint = CGPointMake(self.center.x, thePoint.y);
    [movePath moveToPoint:self.center];
    [movePath addQuadCurveToPoint:thePoint controlPoint:ctlPoint];
    
    CAKeyframeAnimation *moveAnim = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    moveAnim.path = movePath.CGPath;
    moveAnim.removedOnCompletion = NO;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.animations = [NSArray arrayWithObjects:moveAnim, scaleAnim, opacityAnim, nil];
    animGroup.delegate = self;
    [self.layer addAnimation:animGroup forKey:nil];
}

//after we're done animating, we need to remove ourselves from the view so we don't "hang around" on the screen
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (!flag) return;
    
    if (self.superview != nil) [self removeFromSuperview];
}

@end

//
//  UIView+ShrinkTo.h
//  ShrinkToExample
//
//  Created by Ash Furrow on 12-02-18.
//  Copyright (c) 2012 500px. All rights reserved.
//

#import <UIKit/UIKit.h>

#define SHRINK_ANIMATION_DURATION 0.5f

@interface UIView (ShrinkTo)

-(void)shrinkToCenterOfView:(UIView *)targetView;

/*
 Animates shrinking this view to a point within a specified view. 
 */
-(void)shrinkToPoint:(CGPoint)thePoint inView:(UIView *)targetView;

@end

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

#import <Foundation/Foundation.h>


@interface UITableViewCell (ShrinkTo)


/*
 Shrinks a UITableViewCell instance to a the center of another view (like a trashcan).
 
 This method is essentially a special case of the next method.
 */
-(void)shrinkToCenterOfView:(UIView *)targetView fromTableView:(UITableView *)theTableView withRemoveFromDataSourceBlock:(void (^)())block;

/*
 Shrinks a UITableViewCell instance to a specifific point relative (inside) the targetView.
 
 The block is used to update your tableview's datasource. This may be removing an item from an NSMutableArray, calling an 
 external web service to delete the entity from the cloud, or updating a CoreData store. The issue is that the block is
 invoked *synchronoushly*, so write it accordingly.
 */
-(void)shrinkToPoint:(CGPoint)thePoint inView:(UIView *)targetView fromTableView:(UITableView *)theTableView withRemoveFromDataSourceBlock:(void (^)())block;

@end

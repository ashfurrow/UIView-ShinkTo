//
//  RootViewController.h
//  AnimateCellMove
//
//  Created by Ash Furrow on 11-05-19.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kSelectedSegmentedIndexLeft 0
#define kSelectedSegmentedIndexRight 1

@interface RootViewController : UITableViewController {
    UISegmentedControl *segmentedControl;
    NSMutableArray *leftItems;
    NSMutableArray *rightItems;
}

@end

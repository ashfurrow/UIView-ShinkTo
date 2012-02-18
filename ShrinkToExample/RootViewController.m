//
//  RootViewController.m
//  ShrinkToExample
//
//  Created by Ash Furrow on 11-05-19.
//  
//

#import "RootViewController.h"

#import "UIView+ShrinkTo.h"

@implementation RootViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"ShrinkTo Example";
    
    //set up our segmentedControl and add it to our table view
    segmentedControl = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"Left", @"Right", nil]];
    segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
    segmentedControl.selectedSegmentIndex = kSelectedSegmentedIndexLeft;
    [segmentedControl addTarget:self action:@selector(selectedIndexDidChange) forControlEvents:UIControlEventValueChanged];
    
    self.tableView.tableHeaderView = segmentedControl;
    
    //a grocery list, say
    leftItems = [[NSMutableArray alloc] initWithObjects:@"Envelopes", @"Milk", @"Eggs", @"Tinfoil",nil];
    rightItems = [[NSMutableArray alloc] init];
    
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (segmentedControl.selectedSegmentIndex)
    {
        case kSelectedSegmentedIndexLeft:
            return [leftItems count];
        case kSelectedSegmentedIndexRight:
            return [rightItems count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    //We're just loading data from either NSMutableArray instance
    
    switch (segmentedControl.selectedSegmentIndex)
    {
        case kSelectedSegmentedIndexLeft:
            cell.textLabel.text = [leftItems objectAtIndex:indexPath.row];
            break;
        case kSelectedSegmentedIndexRight:
            cell.textLabel.text = [rightItems objectAtIndex:indexPath.row];
            break;
    }
    
    return cell;
}

//This will basically flip the item from one NSMutableArray to the other (and animate that change appropriately)
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    //we'll shift the target point to be on top of the label on the segmented control
    CGPoint toPoint = segmentedControl.center;
    
    if (segmentedControl.selectedSegmentIndex == kSelectedSegmentedIndexRight){
        toPoint = CGPointMake(toPoint.x*0.5, toPoint.y); 

        [leftItems insertObject:[rightItems objectAtIndex:indexPath.row] atIndex:0];
        [rightItems removeObjectAtIndex:indexPath.row];
    }    
    else{
        toPoint = CGPointMake(toPoint.x*1.5, toPoint.y); 
        
        [rightItems insertObject:[leftItems objectAtIndex:indexPath.row] atIndex:0];
        [leftItems removeObjectAtIndex:indexPath.row];
    }
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [[[tableView cellForRowAtIndexPath:indexPath] contentView] shrinkToPoint:toPoint inView:segmentedControl];
    
    [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationTop];
}

//So updated lists are displayed when the user selects the other side of the segmented control
-(void)selectedIndexDidChange
{
    [self.tableView reloadData];
}

- (void)dealloc
{
    [segmentedControl release];
    [leftItems release];
    [rightItems release];
    
    [super dealloc];
}

@end

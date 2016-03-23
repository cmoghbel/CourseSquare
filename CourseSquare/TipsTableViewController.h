//
//  TipsTableViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/8/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface TipsTableViewController : UITableViewController {
    Course *course;
    NSMutableArray *tips;
}

@property (retain) Course *course;
@property (retain) NSMutableArray *tips;

-(void) updateTips:(NSDictionary*)tip;

@end

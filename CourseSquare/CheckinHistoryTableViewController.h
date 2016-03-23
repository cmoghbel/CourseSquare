//
//  CheckinHistoryTableViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/8/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CheckinHistoryTableViewController : UITableViewController {
    NSArray *checkins;
}

@property (nonatomic, retain) NSArray *checkins;

@end

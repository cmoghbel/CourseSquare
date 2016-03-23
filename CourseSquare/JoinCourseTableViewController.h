//
//  JoinCourseTableViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoursesTableViewController.h"

@interface JoinCourseTableViewController : UITableViewController {
    
}

@property (assign) CoursesTableViewController *presentingController;
@property (retain) NSArray *nearbyVenues;

@end

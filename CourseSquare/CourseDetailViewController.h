//
//  CourseDetailViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface CourseDetailViewController : UITableViewController {

}

@property (retain) Course* course;
@property (retain) NSDictionary *venueInfo;

-(void)checkin;
-(void)closeModalController;

@end

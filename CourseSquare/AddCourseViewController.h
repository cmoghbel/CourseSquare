//
//  AddCourseViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/8/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoursesTableViewController.h"

@interface AddCourseViewController : UITableViewController {
    CoursesTableViewController *coursesTableViewController;
    UITextField *schoolTextField;
    UITextField *departmentCodeTextField;
    UITextField *courseNumberTextField;
    UITextField *quarterTextField;
}

@property (nonatomic, retain) CoursesTableViewController *coursesTableViewController;

-(void)doneAddingCourse;

@end

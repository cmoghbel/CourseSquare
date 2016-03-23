//
//  AddTipViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/8/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "TipsTableViewController.h"

@interface AddTipViewController : UIViewController <UITextFieldDelegate> {
    TipsTableViewController *presentingViewController;
    Course *course;
    IBOutlet UITextField *tipTextField;
    IBOutlet UITextField *urlTextField;
}

@property (retain) TipsTableViewController *presentingViewController;
@property (retain) Course *course;


- (IBAction)done:(id)sender;
- (IBAction)cancel:(id)sender;

@end

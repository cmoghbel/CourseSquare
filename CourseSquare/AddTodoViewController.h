//
//  AddTodoViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/8/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"
#import "TodosTableViewController.h"

@interface AddTodoViewController : UIViewController <UITextFieldDelegate> {
    TodosTableViewController *presentingViewController;
    IBOutlet UITextField *todoTextField;
}

@property (retain) TodosTableViewController *presentingViewController;
@property (retain) Course *course;

- (IBAction)cancel:(id)sender;

@end

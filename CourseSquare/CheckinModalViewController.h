//
//  CheckinModalViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseDetailTableViewController.h"

@interface CheckinModalViewController : UIViewController {
    IBOutlet UITextView *textView;
    NSString *text;
}

@property (assign) UITextView *textView;
@property (assign) NSString *text;
@property (assign) CourseDetailTableViewController *presentingController;

- (IBAction)close:(id)sender;

@end

//
//  LoginViewController.h
//  FSTest2
//
//  Created by Christopher Moghbel on 3/31/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foursquare2.h"

@interface LoginViewController : UIViewController {
    IBOutlet UIButton *logUserDataButton;
    IBOutlet UIActivityIndicatorView *applicationLoadingIndicator;
}

@property (readonly) UIButton* logUserDataButton;
@property (readonly) UIActivityIndicatorView* applicationLoadingIndicator;

- (IBAction)logUserData;

@end

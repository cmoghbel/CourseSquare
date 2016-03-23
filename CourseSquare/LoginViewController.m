//
//  LoginViewController.m
//  FSTest2
//
//  Created by Christopher Moghbel on 3/31/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import "LoginViewController.h"


@implementation LoginViewController

@synthesize logUserDataButton;
@synthesize applicationLoadingIndicator;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)dealloc
{
    [logUserDataButton release];
    [applicationLoadingIndicator release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [logUserDataButton release];
    logUserDataButton = nil;
    [applicationLoadingIndicator release];
    applicationLoadingIndicator = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)logUserData {
    [Foursquare2 getDetailForUser:@"self" callback:^(BOOL success, id result) {
        if (success) {
            NSLog(@"User Data: %@", result);
            NSLog(@"Result is of type %@", [result class]);
        }
        else {
            NSLog(@"Error retrieving user data.");
        }
    }];
}

@end

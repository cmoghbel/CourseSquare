//
//  CheckinModalViewController.m
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import "CheckinModalViewController.h"


@implementation CheckinModalViewController

@synthesize presentingController;
@synthesize textView;
@synthesize text;

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
    [textView release];
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
    self.textView.text = self.text;
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [textView release];
    textView = nil;
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (IBAction)close:(id)sender {
    [self.parentViewController dismissModalViewControllerAnimated:YES]; 
}

@end

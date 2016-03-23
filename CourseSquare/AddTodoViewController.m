//
//  AddTodoViewController.m
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/8/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import "AddTodoViewController.h"
#import "Foursquare2.h"

@implementation AddTodoViewController

@synthesize presentingViewController;
@synthesize course;

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
    [todoTextField release];
    todoTextField = nil;
    [course release];
    course = nil;
    [presentingViewController release];
    presentingViewController = nil;
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
    [todoTextField release];
    todoTextField = nil;
    [course release];
    course = nil;
    [super viewDidUnload];
    [presentingViewController release];
    presentingViewController = nil;
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    [Foursquare2 markVenueToDo:course.venueId text:textField.text callback:^(BOOL success, id result) {
        NSLog(@"TODO Result: %@", result);
        NSString *responseCode = [NSString stringWithFormat:@"%@", [[result objectForKey:@"meta"] objectForKey:@"code"]];
        
        if ([responseCode isEqualToString:@"200"]) {
            NSDictionary *todo = [[result objectForKey:@"response"] objectForKey:@"todo"];
            [self.presentingViewController updateTodos:todo];
            [self.presentingViewController.tableView reloadData];
            [self.parentViewController dismissModalViewControllerAnimated:YES];
        }
        else {
            NSString *errorMessage = [[result objectForKey:@"meta"] objectForKey:@"errorDetail"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:responseCode message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];  
        }
    }];
    return NO;
}

- (IBAction)cancel:(id)sender {
    [self.parentViewController dismissModalViewControllerAnimated:YES];
}

@end

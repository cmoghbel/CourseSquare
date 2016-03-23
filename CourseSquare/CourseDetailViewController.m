//
//  CourseDetailViewController.m
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import "CourseDetailViewController.h"
#import "Foursquare2.h"
#import "CheckinModalViewController.h"
#import "TipsTableViewController.h"
#import "PeopleTableViewController.h"
#import "TodosTableViewController.h"
#import "TipsTableViewController.h"

@implementation CourseDetailViewController

@synthesize course;
@synthesize venueInfo;

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
//    webView = [[UIWebView alloc] initWithFrame:self.view.frame];
//    [self.view addSubview:webView];
//    NSURL *url = [NSURL URLWithString:course.shortUrl];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    [webView loadRequest:request];
//    [webView release];
    // Do any additional setup after loading the view from its nib.
    
    UIBarButtonItem *checkinButton = [[UIBarButtonItem alloc] initWithTitle:@"Checkin" style:UIBarButtonSystemItemAction target:self action:@selector(checkin)];
    self.navigationItem.rightBarButtonItem = checkinButton;
    [checkinButton release];
}
                                      
-(void)checkin {
    NSLog(@"Checkin!");
    NSString *venue = [NSString stringWithFormat:@"%@ %@ %@ %@", course.school, course.departmentCode, course.courseNumber, course.quarter];
    [Foursquare2 createCheckinAtVenue:course.venueId venue:venue shout:nil broadcast:broadcastPublic latitude:course.latitude longitude:course.longitude accuracyLL:nil altitude:nil accuracyAlt:nil callback:^(BOOL success, id result) {
        NSLog(@"Checked In!");
        NSLog(@"%@", result);
        NSString *responseCode = [NSString stringWithFormat:@"%@", [[result objectForKey:@"meta"] objectForKey:@"code"]];
        if ([responseCode isEqualToString:@"200"]) {
            CheckinModalViewController *checkinModelViewController = [[CheckinModalViewController alloc] initWithNibName:@"CheckinModalViewController" bundle:[NSBundle mainBundle]];
            checkinModelViewController.presentingController = self;
            NSLog(@"%@", [[result objectForKey:@"response"] objectForKey:@"checkin"]);
            NSString *name = [[[[result objectForKey:@"response"] objectForKey:@"checkin"] objectForKey:@"venue"] objectForKey:@"name"];
            NSString *address = [[[[[result objectForKey:@"response"] objectForKey:@"checkin"] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"address"];
            NSString *city = [[[[[result objectForKey:@"response"] objectForKey:@"checkin"] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"city"];
            NSString *state = [[[[[result objectForKey:@"response"] objectForKey:@"checkin"] objectForKey:@"venue"] objectForKey:@"location"] objectForKey:@"state"];
            checkinModelViewController.text = [NSString stringWithFormat:@"You have been seen at:\n\n %@\n%@\n%@\n%@", name, address, city, state];
            [self presentModalViewController:checkinModelViewController animated:YES];
        }
        else {
            NSString *errorMessage = [[result objectForKey:@"meta"] objectForKey:@"errorDetail"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:responseCode message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }];
}

-(void)closeModalController {
    [self dismissModalViewControllerAnimated:YES];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 3;
//    return [self.nearbyVenues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
//    NSDictionary *venueInfo = [self.nearbyVenues objectAtIndex:indexPath.row];
    if (indexPath.row == 0) {
        cell.textLabel.text = @"People";
        cell.imageView.image = [UIImage imageNamed:@"profileIcon.png"];
    }
    else if (indexPath.row == 1) {
        cell.textLabel.text = @"Tips";
        cell.imageView.image = [UIImage imageNamed:@"tips2.png"];
    }
    else if (indexPath.row == 2) {
        cell.textLabel.text = @"Todos";
        cell.imageView.image = [UIImage imageNamed:@"todo.png"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/*
 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the specified item to be editable.
 return YES;
 }
 */

/*
 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {
 if (editingStyle == UITableViewCellEditingStyleDelete) {
 // Delete the row from the data source
 [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
 }   
 else if (editingStyle == UITableViewCellEditingStyleInsert) {
 // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
 }   
 }
 */

/*
 // Override to support rearranging the table view.
 - (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
 {
 }
 */

/*
 // Override to support conditional rearranging of the table view.
 - (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
 {
 // Return NO if you do not want the item to be re-orderable.
 return YES;
 }
 */

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    
    UIViewController *detailViewController;
    
    if (indexPath.row == 0) {
        detailViewController = [[PeopleTableViewController alloc] initWithNibName:@"PeopleTableViewController" bundle:[NSBundle mainBundle]];
        detailViewController.title = @"People";
        NSArray *friends = [[[[venueInfo objectForKey:@"hereNow"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
        NSArray *nonFriends = [[[[venueInfo objectForKey:@"hereNow"] objectForKey:@"groups"] objectAtIndex:1] objectForKey:@"items"];
        NSMutableArray *people = [NSMutableArray array];
        [people addObjectsFromArray:friends];
        [people addObjectsFromArray:nonFriends];
//        ((PeopleTableViewController*)detailViewController).people = [[[[venueInfo objectForKey:@"hereNow"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
        ((PeopleTableViewController*)detailViewController).people = people;
        ((PeopleTableViewController*)detailViewController).course = course;
    }
    else if (indexPath.row == 1) {
        detailViewController = [[TipsTableViewController alloc] initWithNibName:@"TipsTableViewController" bundle:[NSBundle mainBundle]];
        detailViewController.title = @"Tips";
        NSArray *groups = [[venueInfo objectForKey:@"tips"] objectForKey:@"groups"];
        if ([groups count] > 0) {
            ((TipsTableViewController*)detailViewController).tips = [[groups objectAtIndex:0] objectForKey:@"items"];
        }
        else {
            ((TipsTableViewController*)detailViewController).tips = nil;
        }
//        ((TipsTableViewController*)detailViewController).tips = [[[[venueInfo objectForKey:@"tips"] objectForKey:@"groups"] objectAtIndex:0] objectForKey:@"items"];
        ((TipsTableViewController*)detailViewController).course = course;
    }
    else if (indexPath.row == 2) {
        detailViewController = [[TodosTableViewController alloc] initWithNibName:@"TodosTableViewController" bundle:[NSBundle mainBundle]];
        detailViewController.title = @"Todos";
        ((TodosTableViewController*)detailViewController).todos = [[venueInfo objectForKey:@"todos"] objectForKey:@"items"];
        ((TodosTableViewController*)detailViewController).course = course;
    }
    
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
    
}

@end

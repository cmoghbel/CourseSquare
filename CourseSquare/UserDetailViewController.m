//
//  UserDetailViewController.m
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import "UserDetailViewController.h"
#import "Foursquare2.h"
#import "CheckinHistoryTableViewController.h"

@implementation UserDetailViewController

@synthesize userDetails;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)fetchUserDetails {
    [Foursquare2 getDetailForUser:@"self" callback:^(BOOL success, id result) {
        id details = [[result objectForKey:@"response"] objectForKey:@"user"];
        self.userDetails = details;
        NSLog(@"Is Dictionary?: %@", [details isKindOfClass:[NSDictionary class]] ? @"YES" : @"NO");
        NSLog(@"User Details 1: %@", self.userDetails);
    }]; 
}

- (void)dealloc
{
    [userDetails release];
    userDetails = nil;
    [operationQueue release];
    operationQueue = nil;
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
    operationQueue = [[NSOperationQueue alloc] init];
    [self fetchUserDetails];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
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
    NSLog(@"Number of Rows in Section: %@", self.userDetails);
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    static NSString *CellIdentifier2 = @"Cell2";
    
    UITableViewCell *cell = nil;

    if (indexPath.row == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
        }
        
        cell.textLabel.text = [self.userDetails objectForKey:@"firstName"];
        cell.detailTextLabel.text = [[self.userDetails objectForKey:@"contact"] objectForKey:@"email"];
    }
    else if (indexPath.row == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2] autorelease];
        }
        cell.textLabel.text = @"Mayorships";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.userDetails objectForKey:@"mayorships"] objectForKey:@"count"]];
    }
    else if (indexPath.row == 2) { //Badges
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2] autorelease];
        }
        cell.textLabel.text = @"Badges";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.userDetails objectForKey:@"badges"] objectForKey:@"count"]];
    }
    else if (indexPath.row == 3) { //Tips
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2] autorelease];
        }
        cell.textLabel.text = @"Tips";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.userDetails objectForKey:@"tips"] objectForKey:@"count"]];
    }
    else if (indexPath.row == 4) { //Checkins
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier2];
        if (cell == nil) {
            cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier2] autorelease];
        }
        cell.textLabel.text = @"Checkins";
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [[self.userDetails objectForKey:@"checkins"] objectForKey:@"count"]];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
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

    if (indexPath.row == 4) { //Checkins
        
        [Foursquare2 getCheckinsByUser:@"self" limit:nil offset:nil afterTimestamp:nil beforeTimestamp:nil callback:^(BOOL success, id result) {
            CheckinHistoryTableViewController *detailViewController = [[CheckinHistoryTableViewController alloc] initWithNibName:@"CheckinHistoryTableViewController" bundle:[NSBundle mainBundle]];
            detailViewController.title = [NSString stringWithFormat:@"Checkin History"];
            NSArray *checkins = [[[result objectForKey:@"response"] objectForKey:@"checkins"] objectForKey:@"items"];
            detailViewController.checkins = checkins;
            NSLog(@"Checkin History: %@", checkins);
            
            // Pass the selected object to the new view controller.
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }];
    }

}

@end

//
//  JoinCourseTableViewController.m
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import "JoinCourseTableViewController.h"
#import "Course.h"
#import "CoreDataHelper.h"

@implementation JoinCourseTableViewController

@synthesize presentingController;
@synthesize nearbyVenues;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
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
//    return 0;
    return [self.nearbyVenues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    NSDictionary *venueInfo = [self.nearbyVenues objectAtIndex:indexPath.row];
    cell.textLabel.text = [venueInfo objectForKey:@"name"];
    cell.imageView.image = [UIImage imageNamed:@"courseIcon.png"];
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
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    NSManagedObjectContext *context = [[CoreDataHelper sharedInstance] managedObjectContext];
    Course *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];
    
    NSDictionary *venueInfo = [self.nearbyVenues objectAtIndex:indexPath.row];
    NSLog(@"Venue Info: %@", venueInfo);
    
    course.school = @"UCSD";
    NSArray *nameComponents = [[venueInfo objectForKey:@"name"] componentsSeparatedByString:@" "];
    NSDictionary *locationInfo = [venueInfo objectForKey:@"location"];
    NSString *latitude = [NSString stringWithFormat:@"%@", [locationInfo objectForKey:@"lat"]];
    NSString *longitude = [NSString stringWithFormat:@"%@", [locationInfo objectForKey:@"lng"]];

    course.departmentCode = [nameComponents objectAtIndex:0];
    course.courseNumber = [nameComponents objectAtIndex:1];
    course.quarter = [nameComponents objectAtIndex:2];
    course.venueId = [venueInfo objectForKey:@"id"];
    course.latitude = latitude;
    course.longitude = longitude;
    course.shortUrl = @"http://foursquare.com";
    
    NSError *error = nil;
    if(![context save:&error]) {
        NSLog(@"Error adding course!");
    }
    
//    [self.presentingController dismissModalViewControllerAnimated:YES];
    [self.presentingController.navigationController popToRootViewControllerAnimated:YES];

}

@end

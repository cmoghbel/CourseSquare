//
//  CoursesTableViewController.m
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import "CoursesTableViewController.h"
#import "AddCourseViewController.h"
#import "CoreDataHelper.h"
#import "Course.h"
#import "Foursquare2.h"
#import "CourseDetailTableViewController.h"
#import "JoinCourseTableViewController.h"

@implementation CoursesTableViewController

@synthesize locationManager;
@synthesize currentLocation;
@synthesize reverseGeocoder;
@synthesize placemark;

-(void)addCourse {
    AddCourseViewController *addCourseViewController = [[AddCourseViewController alloc] initWithStyle:UITableViewStyleGrouped];
    addCourseViewController.coursesTableViewController = self;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:addCourseViewController];
    addCourseViewController.title = @"Add Course";
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(cancelAdd)];
    addCourseViewController.navigationItem.leftBarButtonItem = cancelButton;
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:addCourseViewController action:@selector(doneAddingCourse)];
    addCourseViewController.navigationItem.rightBarButtonItem = doneButton;
    navigationController.navigationBar.tintColor = [UIColor colorWithRed:43.0/255.0 green:128.0/255.0 blue:43.0/255.0 alpha:1.0];
    [self presentModalViewController:navigationController animated:YES];
    [doneButton release];
    [cancelButton release];
    [addCourseViewController release];
    [navigationController release];
}

-(void)cancelAdd {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)displayJoinCourseController {
    JoinCourseTableViewController *joinCourseTableViewController = [[JoinCourseTableViewController alloc] initWithNibName:@"JoinCourseTableViewController" bundle:[NSBundle mainBundle]];
    joinCourseTableViewController.presentingController = self;
    
    NSString *lat = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    NSLog(@"HERE 1");
    [Foursquare2 searchVenuesNearByLatitude:lat longitude:lon accuracyLL:nil altitude:nil accuracyAlt:nil query:@"[CSv2]" limit:nil intent:@"checkin" callback:^(BOOL success, id result) {
        NSString *responseCode = [NSString stringWithFormat:@"%@", [[result objectForKey:@"meta"] objectForKey:@"code"]];
        
        if ([responseCode isEqualToString:@"200"]) {
            NSArray *groups = [[result objectForKey:@"response"] objectForKey:@"groups"];
            NSArray *nearybyVenues = nil;
            if ([groups count] > 0) {
                nearybyVenues = [[groups objectAtIndex:0] objectForKey:@"items"];
            }
            joinCourseTableViewController.nearbyVenues = nearybyVenues;
            joinCourseTableViewController.title = @"Join Course";
            [self.navigationController pushViewController:joinCourseTableViewController animated:YES];
            [joinCourseTableViewController release];
        }
        else {
            NSString *errorMessage = [[result objectForKey:@"meta"] objectForKey:@"errorDetail"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:responseCode message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release]; 
        }
    }];
}

-(void)addCourseWithSchool:(NSString *)school andDepartmentCode:(NSString *)departmentCode andCourseNumber:(NSString *)courseNumber andQuarter:(NSString *)quarter {
    NSLog(@"Adding New Course: %@ %@ %@ %@", school, departmentCode, courseNumber, quarter);
    
    if (!school || !departmentCode || !courseNumber || !quarter) {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error adding course" message:@"All fields must be filled in!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alertView show];
        [alertView release];
        return;
    }
    
    NSString *lat = [NSString stringWithFormat:@"%f", currentLocation.coordinate.latitude];
    NSString *lon = [NSString stringWithFormat:@"%f", currentLocation.coordinate.longitude];
    NSLog(@"%@, %@", lat, lon);
    
    NSString *city = placemark.subLocality;
    if (!city) {
        city = placemark.locality;
    }
    NSMutableString *address = [NSMutableString string];
    if (placemark.subThoroughfare) {
        [address appendString:placemark.subThoroughfare];
        [address appendString:@" "];
    }
    if (placemark.thoroughfare) {
        [address appendString:placemark.thoroughfare];
    }
    
    [Foursquare2 addVenueWithName:[NSString stringWithFormat:@"[CSv2] %@ %@ %@ %@", school, departmentCode, courseNumber, quarter]  address:address crossStreet:nil city:city state:placemark.administrativeArea zip:placemark.postalCode phone:nil latitude:lat longitude:lon primaryCategoryId:nil callback:^(BOOL success, id result) {
        NSLog(@"RESULT: %@", result);
        NSString *responseCode = [NSString stringWithFormat:@"%@", [[result objectForKey:@"meta"] objectForKey:@"code"]];
        
        if ([responseCode isEqualToString:@"200"]) {
            NSDictionary *venueDetails = [[result objectForKey:@"response"] objectForKey:@"venue"];
        
            NSManagedObjectContext *context = [[CoreDataHelper sharedInstance] managedObjectContext];
            Course *course = [NSEntityDescription insertNewObjectForEntityForName:@"Course" inManagedObjectContext:context];

            course.school = school;
            course.departmentCode = departmentCode;
            course.courseNumber = courseNumber;
            course.quarter = quarter;
            course.venueId = [venueDetails objectForKey:@"id"];
            course.latitude = lat;
            course.longitude = lon;
            course.shortUrl = [venueDetails objectForKey:@"shortUrl"];
        
            NSError *error = nil;
            if(![context save:&error]) {
                NSLog(@"Error adding course!");
            }
        }
        else {
            NSString *errorMessage = [[result objectForKey:@"meta"] objectForKey:@"errorDetail"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:responseCode message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }

    }];
    
    [self dismissModalViewControllerAnimated:YES];
}

-(void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}


- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
            
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath]
                    atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"Location: %@", [newLocation description]);
    self.currentLocation = newLocation;
    self.reverseGeocoder = [[MKReverseGeocoder alloc] initWithCoordinate:currentLocation.coordinate];
    self.reverseGeocoder.delegate = self;
    [self.reverseGeocoder start];
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
	NSLog(@"Error: %@", [error description]);
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFailWithError:(NSError *)error
{
    NSString *errorMessage = [error localizedDescription];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Cannot obtain address."
                                                        message:errorMessage
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
    [alertView release];
}

- (void)reverseGeocoder:(MKReverseGeocoder *)geocoder didFindPlacemark:(MKPlacemark *)placemark
{
    self.placemark = placemark;
    NSString *city = placemark.subLocality;
    if (!city) {
        city = placemark.locality;
    }
    NSMutableString *address = [NSMutableString string];
    if (placemark.subThoroughfare) {
        [address appendString:placemark.subThoroughfare];
        [address appendString:@" "];
    }
    if (placemark.thoroughfare) {
        [address appendString:placemark.thoroughfare];
    }
    NSLog(@"%@ %@ %@ %@ %@", address, city, placemark.administrativeArea, placemark.postalCode, placemark.country);
}

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

    fetchedResultsController = [[CoreDataHelper sharedInstance] fetchedResultsControllerForEntity:@"Course" withPredicate:[NSPredicate predicateWithFormat:@"TRUEPREDICATE"] andSortKey:@"departmentCode"];
    
    [fetchedResultsController retain];
    fetchedResultsController.delegate = self;
    
    NSError *error = nil;
    [fetchedResultsController performFetch:&error];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    [self.locationManager startUpdatingLocation];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [self.locationManager stopUpdatingLocation];
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
    return [[fetchedResultsController sections] count];;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    id <NSFetchedResultsSectionInfo> sectionInfo = [[fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
    // Configure the cell...
    Course *course = (Course*) [fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", course.departmentCode, course.courseNumber];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", course.school, course.quarter];
//    cell.textLabel.text = [NSString stringWithFormat:@"%@ %@", course.school, course.quarter];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@", course.departmentCode, course.courseNumber];
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
    
    CourseDetailTableViewController *detailViewController = [[CourseDetailTableViewController alloc] initWithNibName:@"CourseDetailViewController" bundle:[NSBundle mainBundle]];
    Course *course = (Course*) [fetchedResultsController objectAtIndexPath:indexPath];
    detailViewController.title = [NSString stringWithFormat:@"%@ %@", course.departmentCode, course.courseNumber];
    detailViewController.course = course;
    
    [Foursquare2 getDetailForVenue:course.venueId callback:^(BOOL success, id result) {
        NSLog(@"%@", result);
        NSString *responseCode = [NSString stringWithFormat:@"%@", [[result objectForKey:@"meta"] objectForKey:@"code"]];
        
        if ([responseCode isEqualToString:@"200"]) {
            detailViewController.venueInfo = [[result objectForKey:@"response"] objectForKey:@"venue"];
            [self.navigationController pushViewController:detailViewController animated:YES];
            [detailViewController release];
        }
        else {
            NSString *errorMessage = [[result objectForKey:@"meta"] objectForKey:@"errorDetail"];
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:responseCode message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alertView show];
            [alertView release];
        }
    }];
    
     // ...
     // Pass the selected object to the new view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
//    [detailViewController release];
     
}

@end

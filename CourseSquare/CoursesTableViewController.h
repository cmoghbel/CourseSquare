//
//  CoursesTableViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"
#import "MapKit/MapKit.h"

@interface CoursesTableViewController : UITableViewController <NSFetchedResultsControllerDelegate, CLLocationManagerDelegate, MKReverseGeocoderDelegate> {
    NSFetchedResultsController *fetchedResultsController;
    NSOperationQueue *operationQueue;
}

-(void)addCourse;
-(void)addCourseWithSchool:(NSString*)school andDepartmentCode:(NSString*) departmentCode andCourseNumber:(NSString*)courseNumber andQuarter:(NSString*)quarter;

@property (nonatomic, retain) CLLocationManager *locationManager;
@property (retain) CLLocation *currentLocation;
@property (retain) MKReverseGeocoder *reverseGeocoder;
@property (retain) MKPlacemark *placemark;

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation;

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error;

@end

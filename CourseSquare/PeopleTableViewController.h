//
//  PeopleTableViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/8/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface PeopleTableViewController : UITableViewController {
    NSMutableArray *people;
    Course *course;
    NSOperationQueue *operationQueue;
    NSDictionary *images;
    dispatch_queue_t queue;
}

@property (retain) NSMutableArray *people;
@property (retain) Course *course;
@property (nonatomic, retain) NSDictionary *images;

-(UIImage *)imageForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

//
//  UserDetailViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserDetailViewController : UITableViewController {
    NSOperationQueue *operationQueue;
    NSDictionary *userDetails;
}

@property (retain) NSDictionary *userDetails;

-(void)fetchUserDetails;

@end

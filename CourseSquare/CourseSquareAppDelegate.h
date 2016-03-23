//
//  CourseSquareAppDelegate.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/6/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Foursquare2.h"
#import "FoursquareWebLoginDelegate.h"
#import "LoginViewController.h"
#import "UserDetailViewController.h"

@interface CourseSquareAppDelegate : NSObject <UIApplicationDelegate> {
    UserDetailViewController *userDetailViewController;
    NSOperationQueue *operationQueue;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

-(void)setAccessToken:(NSString*)accessToken;

@end

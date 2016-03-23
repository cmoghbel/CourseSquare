//
//  CourseSquareAppDelegate.m
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/6/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import "CourseSquareAppDelegate.h"
#import "FoursquareWebLogin.h"
#import "CoursesTableViewController.h"
#import "AddCourseViewController.h"

@implementation CourseSquareAppDelegate

@synthesize window=_window;

@synthesize managedObjectContext=__managedObjectContext;

@synthesize managedObjectModel=__managedObjectModel;

@synthesize persistentStoreCoordinator=__persistentStoreCoordinator;

-(void)doFetch {
    // TODO: Find a better place/way to do this...or at least put on another thread so we don't block.
    while ([Foursquare2 isNeedToAuthorize]) {
    }
    [userDetailViewController fetchUserDetails];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    
    CoursesTableViewController *coursesTableViewController = [[CoursesTableViewController alloc] initWithStyle:UITableViewStylePlain];
    coursesTableViewController.title = @"Courses";
    UINavigationController *coursesNavigationController = [[UINavigationController alloc] initWithRootViewController:coursesTableViewController];
    [coursesNavigationController setTitle:@"Courses"];
    coursesNavigationController.navigationBar.tintColor = [UIColor colorWithRed:43.0/255.0 green:128.0/255.0 blue:43.0/255.0 alpha:1.0];

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:coursesTableViewController action:@selector(addCourse)];
    coursesTableViewController.navigationItem.rightBarButtonItem = addButton;
    [addButton release];
    UIBarButtonItem *joinButton = [[UIBarButtonItem alloc] initWithTitle:@"Join" style:UIBarButtonItemStylePlain target:coursesTableViewController action:@selector(displayJoinCourseController)];
    coursesTableViewController.navigationItem.leftBarButtonItem = joinButton;
    [joinButton release];
    
    userDetailViewController = [[UserDetailViewController alloc] initWithStyle:UITableViewStyleGrouped];
    userDetailViewController.title = @"Profile";
    UINavigationController *profileNavigationController = [[UINavigationController alloc] initWithRootViewController:userDetailViewController];
    profileNavigationController.navigationBar.tintColor = [UIColor colorWithRed:43.0/255.0 green:128.0/255.0 blue:43.0/255.0 alpha:1.0];
    
    NSArray *viewControllers = [NSArray arrayWithObjects:coursesNavigationController, profileNavigationController, nil];
    [tabBarController setViewControllers:viewControllers];
    
    UIImage *coursesImage = [UIImage imageNamed:@"courseIcon.png"];
    UITabBarItem *coursesTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Courses" image:coursesImage tag:0];
    coursesTableViewController.tabBarItem = coursesTabBarItem;
    [coursesTabBarItem release];
    
    UIImage *profileImage = [UIImage imageNamed:@"profileIcon.png"];
    UITabBarItem *profileTabBarItem = [[UITabBarItem alloc] initWithTitle:@"Profile" image:profileImage tag:1];
    userDetailViewController.tabBarItem = profileTabBarItem;
    [profileTabBarItem release];

    [self.window setRootViewController:tabBarController];
    
//    [Foursquare2 removeAccessToken];
	if ([Foursquare2 isNeedToAuthorize]) {
        NSString *url = [NSString stringWithFormat:@"https://foursquare.com/oauth2/authenticate?display=touch&client_id=%@&response_type=code&redirect_uri=%@",OAUTH_KEY,REDIRECT_URL];
        FoursquareWebLogin *loginModalWebViewController = [[FoursquareWebLogin alloc] initWithUrl:url];
        loginModalWebViewController.delegate = self;
        [coursesNavigationController presentModalViewController:loginModalWebViewController animated:YES];
        [loginModalWebViewController release];	
    }
    
    operationQueue = [[NSOperationQueue alloc] init];
    NSInvocationOperation *operation = [[NSInvocationOperation alloc] initWithTarget:self selector:@selector(doFetch) object:nil];
    [operationQueue addOperation:operation];
    [operation release];
        
    [coursesTableViewController release];
    [coursesNavigationController release];
    [profileNavigationController release];
    
    [self.window makeKeyAndVisible];
    return YES;
}

-(void)setCode:(NSString*)accessToken {
	[Foursquare2 getAccessTokenForCode:accessToken callback:^(BOOL success,id result){
		if (success) {
            NSLog(@"Setting access token");
			[Foursquare2 setBaseURL:[NSURL URLWithString:@"https://api.foursquare.com/v2/"]];
			[Foursquare2 setAccessToken:[result objectForKey:@"access_token"]];
		}
	}];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    /*
     Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
     */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

- (void)dealloc
{
    [userDetailViewController release];
    userDetailViewController = nil;
    [operationQueue release];
    operationQueue = nil;
    [_window release];
    [__managedObjectContext release];
    [__managedObjectModel release];
    [__persistentStoreCoordinator release];
    [super dealloc];
}

- (void)awakeFromNib
{
    /*
     Typically you should set up the Core Data stack here, usually by passing the managed object context to the first view controller.
     self.<#View controller#>.managedObjectContext = self.managedObjectContext;
    */
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil)
    {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error])
        {
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        } 
    }
}

#pragma mark - Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext
{
    if (__managedObjectContext != nil)
    {
        return __managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil)
    {
        __managedObjectContext = [[NSManagedObjectContext alloc] init];
        [__managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return __managedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel
{
    if (__managedObjectModel != nil)
    {
        return __managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"CourseSquare" withExtension:@"momd"];
    __managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];    
    return __managedObjectModel;
}

/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (__persistentStoreCoordinator != nil)
    {
        return __persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"CourseSquare.sqlite"];
    
    NSError *error = nil;
    __persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![__persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error])
    {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter: 
         [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }    
    
    return __persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end

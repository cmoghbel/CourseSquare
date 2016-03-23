//
//  CoreDataHelper.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CoreDataHelper : NSObject {
    NSManagedObjectModel *managedObjectModel;
    NSManagedObjectContext *managedObjectContext;
    NSPersistentStoreCoordinator *persistentStoreCoordinator;
}

// Returns the 'singleton' instance of this class
+ (id)sharedInstance;

// Checks to see if any database exists on disk
- (BOOL)databaseExists;

// Returns the NSManagedObjectContext for inserting and fetching objects into the store
- (NSManagedObjectContext *)managedObjectContext;

// Returns an array of objects already in the database for the given Entity Name and Predicate
- (NSArray *)fetchManagedObjectsForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate;

// Returns an NSFetchedResultsController for a given Entity Name and Predicate
- (NSFetchedResultsController *)fetchedResultsControllerForEntity:(NSString*)entityName withPredicate:(NSPredicate*)predicate andSortKey:(NSString*)sortKey;

@end

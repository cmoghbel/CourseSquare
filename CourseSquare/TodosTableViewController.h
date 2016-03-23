//
//  TodosTableViewController.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/8/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Course.h"

@interface TodosTableViewController : UITableViewController {
    Course *course;
    NSMutableArray *todos;
}

@property (retain) Course *course; 
@property (retain) NSMutableArray *todos;


-(void)updateTodos:(NSDictionary*)todo;

@end

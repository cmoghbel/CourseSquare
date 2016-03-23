//
//  Course.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/7/11.
//  Copyright (c) 2011 UC San Diego. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Course : NSManagedObject {
@private
}
@property (nonatomic, retain) NSString * departmentCode;
@property (nonatomic, retain) NSString * courseNumber;
@property (nonatomic, retain) NSString * quarter;
@property (nonatomic, retain) NSString * venueId;
@property (nonatomic, retain) NSString * latitude;
@property (nonatomic, retain) NSString * longitude;
@property (nonatomic, retain) NSString * shortUrl;
@property (nonatomic, retain) NSString * school;

@end

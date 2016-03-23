//
//  CellPictureUpdateWrapper.h
//  CourseSquare
//
//  Created by Christopher Moghbel on 4/8/11.
//  Copyright 2011 UC San Diego. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface CellPictureUpdateWrapper : NSObject {
    NSURL *imageUrl;
    UITableViewCell *celll;
    UIViewController *delegate;
}

@property (retain) NSURL *imageUrl;
@property (retain) UITableViewCell *cell;
@property (retain) UIViewController *delegate;

@end

//
//  User.h
//  SleepTracker
//
//  Created by rui xie on 2/5/15.
//  Copyright (c) 2015 Rui Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSDate * sleepDate;
@property (nonatomic, retain) NSDate * aWakeDate;

@end

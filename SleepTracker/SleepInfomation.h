//
//  SleepInfomation.h
//  SleepTracker
//
//  Created by rui xie on 2/28/15.
//  Copyright (c) 2015 Rui Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface SleepInfomation : NSManagedObject

@property (nonatomic, retain) NSDate * aWakeDate;
@property (nonatomic, retain) NSNumber * isSleep;
@property (nonatomic, retain) NSDate * sleepDate;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) User *whoHas;

@end

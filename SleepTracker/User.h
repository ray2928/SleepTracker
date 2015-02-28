//
//  User.h
//  SleepTracker
//
//  Created by rui xie on 2/28/15.
//  Copyright (c) 2015 Rui Xie. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class User;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * gender;
@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSSet *has;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addHasObject:(User *)value;
- (void)removeHasObject:(User *)value;
- (void)addHas:(NSSet *)values;
- (void)removeHas:(NSSet *)values;

@end

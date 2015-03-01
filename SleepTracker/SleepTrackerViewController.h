//
//  SleepTrackerViewController.h
//  SleepTracker
//
//  Created by rui xie on 2/5/15.
//  Copyright (c) 2015 Rui Xie. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "SleepInfomation.h"
#import "SleepInformationTableView.h"

@interface SleepTrackerViewController : UIViewController<UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) User *user;
@property (strong, nonatomic) SleepInfomation *sleepInformation;
//declare table view variables
@property (weak, nonatomic) IBOutlet SleepInformationTableView *SleepInformationTV;
@property (nonatomic, retain) NSMutableArray *SleepInformationOfUser;
@end

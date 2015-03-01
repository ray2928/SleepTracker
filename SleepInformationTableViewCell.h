//
//  SleepInformationTableViewCell.h
//  SleepTracker
//
//  Created by rui xie on 3/1/15.
//  Copyright (c) 2015 Rui Xie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SleepInformationTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label_name;
@property (weak, nonatomic) IBOutlet UILabel *label_sleepAt;

@property (weak, nonatomic) IBOutlet UILabel *label_awakeAt;
@property (weak, nonatomic) IBOutlet UILabel *duration;

@end

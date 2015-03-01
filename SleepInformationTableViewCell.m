//
//  SleepInformationTableViewCell.m
//  SleepTracker
//
//  Created by rui xie on 3/1/15.
//  Copyright (c) 2015 Rui Xie. All rights reserved.
//

#import "SleepInformationTableViewCell.h"

@implementation SleepInformationTableViewCell

@synthesize label_name = _label_name;
@synthesize label_sleepAt = _label_sleepAt;
@synthesize label_awakeAt = _label_awakeAt;
@synthesize duration = _duration;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

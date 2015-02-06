//
//  SleepTrackerViewController.m
//  SleepTracker
//
//  Created by rui xie on 2/5/15.
//  Copyright (c) 2015 Rui Xie. All rights reserved.
//

#import "SleepTrackerViewController.h"

@interface SleepTrackerViewController ()
@property (weak, nonatomic) IBOutlet UILabel *DateLabel;
@property (weak, nonatomic) IBOutlet UILabel *TimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *RecordButton;

@end

@implementation SleepTrackerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

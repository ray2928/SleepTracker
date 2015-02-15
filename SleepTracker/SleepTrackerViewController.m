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
@property (weak, nonatomic) IBOutlet UIButton *RecordButton;
@property (weak, nonatomic) IBOutlet UIDatePicker *TimePicker;

@end

@implementation SleepTrackerViewController

-(NSString *) currentDate{
    NSDate *date =[NSDate date];
    NSDateFormatter *dateformatter = [[NSDateFormatter alloc]init];
    [dateformatter setDateFormat:@"MM-dd-yyyy"];
    NSString* currDate = [dateformatter stringFromDate:date];
    //NSLog(@"date is %@",currDate);
    return currDate;
}

// write the time time and awake time persistently
- (IBAction)SleepRecord:(UIButton *)sender {
    NSDate *currentTime = self.TimePicker.date;
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"HH:mm"];
    NSString* currTime = [timeFormatter stringFromDate:currentTime];
    NSLog(@"time is %@", currTime);
    //record sleepTime
    NSManagedObjectContext *context = [self manageObjectContext];
    NSManagedObject *newSleepTime = [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:context];
    [newSleepTime setValue:currentTime forKey:@"sleepDate"];
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
    
}

- (NSManagedObjectContext *) manageObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}




- (void) viewDidLoad{
    [super viewDidLoad];
    self.DateLabel.text = [self currentDate];
}

@end

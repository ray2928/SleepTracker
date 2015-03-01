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
@synthesize SleepInformationTV, SleepInformationOfUser;

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
    //record sleepTime or awake time
    NSManagedObjectContext *context = [self managedObjectContext];
    if ([self.RecordButton.titleLabel.text  isEqual: @"Sleep"]) {

        NSManagedObject *newSleepTime = [NSEntityDescription insertNewObjectForEntityForName:@"SleepInfomation" inManagedObjectContext:context];
        [newSleepTime setValue:currentTime forKey:@"sleepDate"];
        [newSleepTime setValue:@"ray" forKey:@"userID"];
        [newSleepTime setValue:false forKey:@"isSleep"];
        
        [self.RecordButton setTitle:@"Awake" forState:UIControlStateNormal];
    } else {
        NSArray *sleepInformationArray = [self fetchSleepInfomationData];
//        NSMutableArray *sleeptime = [[sleepInformationArray valueForKey:@"sleepDate"]mutableCopy];
//        for (NSDate *date in sleeptime) {
//            NSLog(@"sleep time is %@",date);
//        }
        NSManagedObject *sleepRecord = [sleepInformationArray firstObject];
        [sleepRecord setValue:currentTime forKey:@"aWakeDate"];
        
        [sleepRecord setValue:[NSNumber numberWithInt:1] forKey:@"isSleep"];
        [self.RecordButton setTitle:@"Sleep" forState:UIControlStateNormal];
    }

    
    
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
}


- (NSManagedObjectContext *) managedObjectContext {
    NSManagedObjectContext *context = nil;
    id delegate = [[UIApplication sharedApplication] delegate];
    if ([delegate performSelector:@selector(managedObjectContext)]) {
        context = [delegate managedObjectContext];
    }
    return context;
}


- (NSArray *) fetchSleepInfomationData{
    //NSString *str = nil;
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"SleepInfomation" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSString *userID = @"ray";
    //int isSleep = 0;
    bool isSleep = false;
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ and isSleep == %@", userID, isSleep];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sleepDate" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *sleepInformationArray = [moc executeFetchRequest:request error:&error];
    if (sleepInformationArray == nil)
    {
        NSLog(@"Can't fetch! %@ %@", error, [error localizedDescription]);
    }
    return sleepInformationArray;
}

- (NSArray *) fetchUserSleepRecord: (NSString *) userID{
    //NSString *str = nil;
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"SleepInfomation" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@", userID];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sleepDate" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *sleepInformationArray = [moc executeFetchRequest:request error:&error];
    if (sleepInformationArray == nil)
    {
        NSLog(@"Can't fetch! %@ %@", error, [error localizedDescription]);
    }
    return sleepInformationArray;
}

// complete tableview delegate method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [SleepInformationOfUser count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIndentifier = @"User Sleep Information";
    UITableViewCell *sleepInforCell = [tableView dequeueReusableCellWithIdentifier:tableIndentifier];
    if (sleepInforCell == nil) {
        sleepInforCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIndentifier];
    }
    sleepInforCell.textLabel.text = [[SleepInformationOfUser valueForKey:@"userID"] objectAtIndex:indexPath.row];
    return sleepInforCell;
}




- (void) viewDidLoad{
    [super viewDidLoad];
    self.DateLabel.text = [self currentDate];
    //[self fetchData];
    SleepInformationOfUser = [[self fetchUserSleepRecord:@"ray"]mutableCopy];
}

@end

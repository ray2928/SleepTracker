//
//  SleepTrackerViewController.m
//  SleepTracker
//
//  Created by rui xie on 2/5/15.
//  Copyright (c) 2015 Rui Xie. All rights reserved.
//

#import "SleepTrackerViewController.h"
#import "SleepInformationTableViewCell.h"

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
    return currDate;
}

#pragma mark - Button event
// write the time time and awake time persistently
- (IBAction)SleepRecord:(UIButton *)sender {
    NSDate *currentTime = self.TimePicker.date;
    //record sleepTime or awake time
    NSManagedObjectContext *context = [self managedObjectContext];
    Boolean change = false;
    if ([self.RecordButton.titleLabel.text  isEqual: @"Sleep"]) {
        NSManagedObject *newSleepTime = [NSEntityDescription insertNewObjectForEntityForName:@"SleepInfomation" inManagedObjectContext:context];
        [newSleepTime setValue:currentTime forKey:@"sleepDate"];
        [newSleepTime setValue:@"ray" forKey:@"userID"];
        [newSleepTime setValue:[NSNumber numberWithInt:1] forKey:@"isSleep"];
        [newSleepTime setValue:[NSNumber numberWithDouble:0] forKey:@"duration"];
        
        [self.RecordButton setTitle:@"Awake" forState:UIControlStateNormal];
    } else {
        NSArray *sleepInformationArray = [self fetchSleepInfomationData];
        NSManagedObject *sleepRecord = [sleepInformationArray firstObject];
        NSDate *sleepTime = [sleepRecord valueForKey:@"sleepDate"];
        NSTimeInterval timeElapsed = [currentTime timeIntervalSinceDate:sleepTime];

        [sleepRecord setValue:currentTime forKey:@"aWakeDate"];
        [sleepRecord setValue:[NSNumber numberWithInt:0] forKey:@"isSleep"];
        [sleepRecord setValue:[NSNumber numberWithDouble:timeElapsed] forKey:@"duration"];
        
        [self.RecordButton setTitle:@"Sleep" forState:UIControlStateNormal];
        change = true;
    }
    NSError *error = nil;
    if (![context save:&error]) {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
    if (change) {
        SleepInformationOfUser = [[self fetchUserSleepRecord:@"ray"]mutableCopy];
        [self.SleepInformationTV reloadData];
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

#pragma mark - Fetch data
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
    NSNumber *isSleep = [NSNumber numberWithInt:1];
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
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"SleepInfomation" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"userID == %@ and isSleep == 0", userID];
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

#pragma mark - Load tableview
// complete tableview delegate method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [SleepInformationOfUser count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *tableIndentifier = @"Customized Sleep Information Cell";
    SleepInformationTableViewCell *sleepInforCell = (SleepInformationTableViewCell *)[tableView dequeueReusableCellWithIdentifier:tableIndentifier];
    if (sleepInforCell == nil) {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:tableIndentifier owner:self options:nil];
        sleepInforCell = [nib objectAtIndex:0];
    }
    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc]init];
    [timeFormatter setDateFormat:@"MM-dd-yyyy hh:mm:ss"];
    NSString *sleepDate = [timeFormatter stringFromDate: [[SleepInformationOfUser valueForKey:@"sleepDate"] objectAtIndex:indexPath.row]];
    NSString *awakeDate = [timeFormatter stringFromDate:[[SleepInformationOfUser valueForKey:@"aWakeDate"] objectAtIndex:indexPath.row]];
    NSNumber *duration = [[SleepInformationOfUser valueForKey:@"duration"] objectAtIndex:indexPath.row];
    NSString *name =[[SleepInformationOfUser valueForKey:@"userID"] objectAtIndex:indexPath.row];
    int hours = [duration intValue]/3600;
    int minues = ([duration intValue]-hours*3600)/60;
    
    sleepInforCell.label_name.text =[NSString stringWithFormat:@"Name: %@", name];
    sleepInforCell.label_sleepAt.text = [NSString stringWithFormat:@"Sleep at: %@", sleepDate];
    sleepInforCell.label_awakeAt.text = [NSString stringWithFormat:@"Awake at: %@", awakeDate];
    sleepInforCell.duration.text = [NSString stringWithFormat:@"Duration: %d h, %d m", hours, minues];
    return sleepInforCell;
}




- (void) viewDidLoad{
    [super viewDidLoad];
    self.DateLabel.text = [self currentDate];
    //[self fetchData];
    SleepInformationOfUser = [[self fetchUserSleepRecord:@"ray"]mutableCopy];
}

@end

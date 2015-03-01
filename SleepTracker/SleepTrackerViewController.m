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
    //record sleepTime
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *newSleepTime = [NSEntityDescription insertNewObjectForEntityForName:@"SleepInfomation" inManagedObjectContext:context];
    [newSleepTime setValue:currentTime forKey:@"sleepDate"];
    [newSleepTime setValue:@"111" forKey:@"userID"];
    
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

- (void) fetchData{
    //NSString *str = nil;
    NSManagedObjectContext *moc = [self managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"SleepInfomation" inManagedObjectContext:moc];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDescription];
    
    // Set example predicate and sort orderings...
    NSPredicate *predicate = [NSPredicate predicateWithFormat:
                              @"(userID == 111)"];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
                                        initWithKey:@"sleepDate" ascending:YES];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if (array == nil)
    {
        NSLog(@"Can't save! %@ %@", error, [error localizedDescription]);
    }
    for (NSDate *date in array) {
        NSLog(@"h");
        NSLog(@"%@", date);
    }
}

// complete tableview delegate method
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"tableview----");
    return [SleepInformationOfUser count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"tableview+++++");
    static NSString *tableIndentifier = @"User Sleep Information";
    UITableViewCell *sleepInforCell = [tableView dequeueReusableCellWithIdentifier:tableIndentifier];
    if (sleepInforCell == nil) {
        sleepInforCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:tableIndentifier];
    }
    sleepInforCell.textLabel.text = [SleepInformationOfUser objectAtIndex:indexPath.row];
    return sleepInforCell;
}




- (void) viewDidLoad{
    [super viewDidLoad];
    self.DateLabel.text = [self currentDate];
    [self fetchData];
    SleepInformationOfUser = [[NSMutableArray alloc] initWithObjects:@"ray", @"lln", nil];
//    self.SleepInformationTV.delegate = self;
//    self.SleepInformationTV.dataSource = self;
}

@end

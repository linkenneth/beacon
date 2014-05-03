//
//  MessagesViewController.m
//  beacon
//
//  Created by Larry Cao on 5/3/14.
//  Copyright (c) 2014 oslife. All rights reserved.
//

#import "MessagesViewController.h"
#import "BeaconViewController.h"
#import "BeaconAppDelegate.h"


@interface MessagesViewController ()

@property (nonatomic, weak) NSMutableArray *messages;

@end

@implementation MessagesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"messageCell"];
        
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.messages = [(BeaconAppDelegate *)[[UIApplication sharedApplication] delegate] messages];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setBackgroundColor:(UIColor *)color {
    [self.navigationController.navigationBar setTintColor:color];
    
    self.tableView.backgroundColor = color;
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"messageCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    // Configure the cell...
    
    NSArray *message = self.messages[indexPath.row];
    
    cell.textLabel.text = message[0];

    
    NSDate *messageDate = message[1];
    NSString *dateText;
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    int units = NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    NSDateComponents *components = [calendar components:units fromDate:[NSDate date] toDate:messageDate options:0];
    
    if([components month] > 0){
        dateText = [NSString stringWithFormat:@"%lu%c %lu%c %lu%c %lu%c %lu%c ago", (long)[components month], 'm', (long)[components day], 'd', (long)[components hour], 'h', (long)[components minute], 'm', (long)[components second], 's'];
    }else if([components day] > 0){
        dateText = [NSString stringWithFormat:@"%lu%c %lu%c %lu%c %lu%c ago", (long)[components day], 'd', (long)[components hour], 'h', (long)[components minute], 'm', (long)[components second], 's'];
    }else if([components hour] > 0){
        dateText =  [NSString stringWithFormat:@"%lu%c %lu%c %lu%c ago", (long)[components hour], 'h', (long)[components minute], 'm', (long)[components second], 's'];
    }else if([components minute] > 0){
        dateText = [NSString stringWithFormat:@"%lu%c %lu%c ago", (long)[components minute], 'm', (long)[components second], 's'];
    }
        
    cell.detailTextLabel.text = dateText;
        
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

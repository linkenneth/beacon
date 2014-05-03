//
//  BeaconViewController.m
//  beacon
//
//  Created by echeng on 5/2/14.
//  Copyright (c) 2014 oslife. All rights reserved.
//
#include <stdlib.h>
#import "BeaconViewController.h"
#import "BeaconDefaults.h"
#import "SettingsView.h"
#import "MessagesViewController.h"
#import "UIImage+ColorAtPixel.h"

@import CoreLocation;
@import CoreBluetooth;

CBPeripheralManager *peripheralManager = nil;
CLBeaconRegion *region = nil;

@interface BeaconViewController () <CBPeripheralManagerDelegate, CLLocationManagerDelegate>

@property BOOL listenEnabled;
@property BOOL sendEnabled;
@property NSUUID *uuid;
@property BOOL notifyOnEntry;
@property BOOL notifyOnExit;
@property BOOL notifyOnDisplay;

@property BOOL settingsControlOpen;

@property (nonatomic) NSNumberFormatter *numberFormatter;
@property (nonatomic) CLLocationManager *locationManager;

@property (nonatomic, weak) IBOutlet UIButton *bob;


@property (nonatomic, strong) SettingsView *settingsView;

- (void)updateMonitoredRegion;

//- (void)updateAdvertisedRegion;

@end

@implementation BeaconViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.settingsControlOpen = NO;
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(showSettings:)];
    swipe.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:swipe];
    
    
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeLeft:)];
    swipeLeft.direction = UISwipeGestureRecognizerDirectionLeft
    ;
    
    [self.view addGestureRecognizer:swipeLeft];

    
    NSArray *xibArray = [[NSBundle mainBundle] loadNibNamed:@"SettingsView" owner:nil options:nil];
    for (id xibObject in xibArray) {
        //Loop through array, check for the object we're interested in.
        if ([xibObject isKindOfClass:[SettingsView class]]) {
            //Use casting to cast (id) to (MyCustomView *)
            self.settingsView = (SettingsView *)xibObject;
        }
    }
    
    self.view.backgroundColor = [self.settingsView.blueButton.imageView.image colorAtPixel:CGPointMake(5, 5)];
    
    self.settingsView.frame = CGRectMake(-self.view.bounds.size.
                                         width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.settingsView.parent = self;
    [self.view addSubview:self.settingsView];
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    self.numberFormatter = [[NSNumberFormatter alloc] init];
    self.numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    self.textField.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.6];
    

    
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"] identifier:BeaconIdentifier];
    region = [self.locationManager.monitoredRegions member:region];
    if(region)
    {
        self.listenEnabled = YES;
        self.uuid = region.proximityUUID;
        self.notifyOnEntry = region.notifyOnEntry;
        self.notifyOnExit = region.notifyOnExit;
        self.notifyOnDisplay = region.notifyEntryStateOnDisplay;
    }
    else
    {
        // Default settings.
        self.listenEnabled = NO;
        
        self.uuid = [BeaconDefaults sharedDefaults].defaultProximityUUID;
        self.notifyOnEntry = self.notifyOnExit = YES;
        self.notifyOnDisplay = NO;
    }
    
    [self updateMonitoredRegion];
    //self.doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(doneEditing:)];
    
    
    
}

- (void)swipeLeft:(UISwipeGestureRecognizer*)recognizer {
    
    if (self.settingsControlOpen) {
        [UIView animateWithDuration:.5 animations:^{
            self.settingsView.frame = CGRectMake(-self.view.bounds.size.width, 0, self.view.bounds.size.width, self.view.bounds.size.height);
        }];
        
        self.settingsControlOpen = NO;
    } else {
        
        MessagesViewController *messageViewController = [[MessagesViewController alloc] initWithStyle:UITableViewStylePlain];
        
        [messageViewController setBackgroundColor:self.view.backgroundColor];
        [self.navigationController pushViewController:messageViewController animated:YES];
    }
}


- (void)showSettings:(UISwipeGestureRecognizer*)recognizer {
    [UIView animateWithDuration:.5 animations:^{
        self.settingsView.frame = CGRectMake(-self.view.bounds.size.width/2, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    }];
    
    self.settingsControlOpen = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:animated];
    
    if (!peripheralManager)
    {
        peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)];
    }
    else
    {
        peripheralManager.delegate = self;
    }
    
    self.listenEnabledSwitch.on = self.listenEnabled;
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:animated];
    
    peripheralManager.delegate = nil;
}

- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    
}

- (IBAction)toggleEnabled:(UISwitch *)sender
{
    self.listenEnabled = sender.on;
    
    [self updateMonitoredRegion];
}


- (IBAction)buttonPressed:(id)sender {
    self.textField.alpha = 0;
    self.textField.hidden = NO;
    [UIView animateWithDuration:1 animations:^{
        self.textField.alpha = 1;
    }];
    
    [self.textField becomeFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [self sendMessage];
    [self.textField discardMessage];
    return YES;
}

- (void)sendMessage
{
//    if (self.sendEnabled) {
//        self.sendEnabled = NO;
//    } else {
//        self.sendEnabled = YES;
//    }
    // We must construct a CLBeaconRegion that represents the payload we want the device to beacon.
    
    NSNumber *majorNum = [NSNumber numberWithShort:(uint16_t) arc4random()];
    NSNumber *minorNum = [NSNumber numberWithShort:(uint16_t) arc4random()];
    region = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid major:[majorNum unsignedShortValue] minor:[minorNum unsignedShortValue] identifier:BeaconIdentifier];
    
//    int msgId = [majorNum intValue] << 16 | [minorNum intValue];
    
//    NSNumber *msgIdNum = [NSNumber numberWithInt:msgId];
    NSNumber *msgIdNum = majorNum;
    
    NSURLSession *session = [NSURLSession sharedSession];
    
    
    
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://beacon-of-hope-server.herokuapp.com/%u", [msgIdNum unsignedShortValue]]];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
    
    [request setHTTPMethod:@"POST"];
    
    
    NSString *postString = [NSString stringWithFormat:@"value=%@", self.textField.text];
    
    [request setHTTPBody:[postString dataUsingEncoding:NSUTF8StringEncoding]];
    
    [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *peripheralData = [region peripheralDataWithMeasuredPower:[BeaconDefaults sharedDefaults].defaultPower];
            
            // The region's peripheral data contains the CoreBluetooth-specific data we need to advertise.
            if(peripheralData)
            {
                [peripheralManager startAdvertising:peripheralData];
            }
            
            
            [NSTimer scheduledTimerWithTimeInterval:0.3 target:self selector:@selector(stopUpdateAdvertisedRegion) userInfo:nil repeats:NO];

        });
        
    }] resume];

    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)updateMonitoredRegion
{
    // if region monitoring is enabled, update the region being monitored
    CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"] identifier:BeaconIdentifier];
    
    if(region != nil)
    {
        [self.locationManager stopMonitoringForRegion:region];
    }
    
    if(self.listenEnabled)
    {
        region = [[CLBeaconRegion alloc] initWithProximityUUID:self.uuid identifier:BeaconIdentifier];
        
        if(region)
        {
            region.notifyOnEntry = self.notifyOnEntry;
            region.notifyOnExit = self.notifyOnExit;
            region.notifyEntryStateOnDisplay = self.notifyOnDisplay;
            
            [self.locationManager startMonitoringForRegion:region];

        }
    }
    else
    {
        CLBeaconRegion *region = [[CLBeaconRegion alloc] initWithProximityUUID:[[NSUUID alloc] initWithUUIDString:@"E2C56DB5-DFFB-48D2-B060-D0F5A71096E0"] identifier:BeaconIdentifier];
        [self.locationManager stopMonitoringForRegion:region];
    }
}

- (void)stopUpdateAdvertisedRegion
{
    if(peripheralManager.state < CBPeripheralManagerStatePoweredOn)
    {
        NSString *title = NSLocalizedString(@"Bluetooth must be enabled", @"");
        NSString *message = NSLocalizedString(@"To configure your device as a beacon", @"");
        NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Cancel button title in configuration Save Changes");
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
        [errorAlert show];
        
        return;
    }
    
	[peripheralManager stopAdvertising];
    
//    if(self.sendEnabled)
//    {
//        
//    }
}

- (void)changeBackgroundColorTo:(UIColor *)color {
    self.view.backgroundColor = color;
}

@end

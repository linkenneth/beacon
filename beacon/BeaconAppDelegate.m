//
//  BeaconDelegate.m
//  beacon
//
//  Created by echeng on 5/2/14.
//  Copyright (c) 2014 oslife. All rights reserved.
//
#import "BeaconAppDelegate.h"
@import CoreLocation;


@interface BeaconAppDelegate () <UIApplicationDelegate, CLLocationManagerDelegate>
@property CLLocationManager *locationManager;
@property (nonatomic) BOOL didSeeBeacon;
@property (nonatomic, strong) NSMutableSet *messagesSeen;

@end



@implementation BeaconAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // This location manager will be used to notify the user of region state transitions.
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.messagesSeen = [[NSMutableSet alloc] init];
    self.didSeeBeacon = NO;
    return YES;
}


- (void)locationManager:(CLLocationManager *)manager didDetermineState:(CLRegionState)state forRegion:(CLRegion *)region
{
//    /*
//     A user can transition in or out of a region while the application is not running. When this happens CoreLocation will launch the application momentarily, call this delegate method and we will let the user know via a local notification.
//     */
//    UILocalNotification *notification = [[UILocalNotification alloc] init];
//    
//    CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
//    int msgId = [beaconRegion.major intValue] << 16 | [beaconRegion.minor intValue];
//    
//    NSNumber *msgIdNum = [NSNumber numberWithInt:msgId];
//    
    if(state == CLRegionStateInside)
    {
        self.didSeeBeacon = YES;
        [self.locationManager startRangingBeaconsInRegion:(CLBeaconRegion *)region];

//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            
//            [self.locationManager requestStateForRegion:region];
//        });
//        notification.alertBody = [NSString stringWithFormat:@"%d", [msgIdNum intValue]];
    }
//    else
//    {
//        return;
//    }
//    
//    /*
//     If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
//     If it's not, iOS will display the notification to the user.
//     */
//    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
    
}



//- (void)locationManager:(CLLocationManager *)manager didEnterRegion:(CLRegion *)region {
//    
//}



- (void)locationManager:(CLLocationManager *)manager didExitRegion:(CLRegion *)region {
    UILocalNotification *notification = [[UILocalNotification alloc] init];
    notification.alertBody = @"exitedRegion";
    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
}

- (void)locationManager:(CLLocationManager *)manager didRangeBeacons:(NSArray *)beacons inRegion:(CLBeaconRegion *)region
{
    if (self.didSeeBeacon) {
        
        for (CLBeacon *beacon in beacons) {
            UILocalNotification *notification = [[UILocalNotification alloc] init];
            
//            CLBeaconRegion *beaconRegion = (CLBeaconRegion *)region;
//            int msgId = [beacon.major intValue] << 16 | [beacon.minor intValue];
            
//            NSNumber *msgIdNum = [NSNumber numberWithInt:msgId];
            
            NSNumber *msgIdNum = beacon.major;
            
            if (![self.messagesSeen containsObject:msgIdNum]) {
                NSURLSession *session = [NSURLSession sharedSession];
                NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://beacon-of-hope-server.herokuapp.com/%u", [msgIdNum unsignedShortValue]]];
                NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                                       cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:60.0];
                
                [[session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
                    
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        notification.alertBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                        /*
                         If the application is in the foreground, it will get a callback to application:didReceiveLocalNotification:.
                         If it's not, iOS will display the notification to the user.
                         */
                        [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                        
                        [self.messagesSeen addObject:msgIdNum];
                    });
                }] resume];
            }
            

        }
        self.didSeeBeacon = NO;
        
        [self.locationManager stopMonitoringForRegion:region];
        [self.locationManager startMonitoringForRegion:region];
    }
}


- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    // If the application is in the foreground, we will notify the user of the region's state via an alert.
    NSString *cancelButtonTitle = NSLocalizedString(@"OK", @"Title for cancel button in local notification");
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:notification.alertBody message:nil delegate:nil cancelButtonTitle:cancelButtonTitle otherButtonTitles:nil];
    [alert show];
}


@end

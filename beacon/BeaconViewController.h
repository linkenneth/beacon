//
//  BeaconViewController.h
//  beacon
//
//  Created by echeng on 5/2/14.
//  Copyright (c) 2014 oslife. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MessageTextField.h"

@interface BeaconViewController : UIViewController

- (void)changeBackgroundColorTo:(UIColor *)color;


@property (nonatomic, weak) IBOutlet UISwitch *listenEnabledSwitch;

@property (weak, nonatomic) IBOutlet MessageTextField *textField;

@end

//
//  SettingsView.h
//  beacon
//
//  Created by Larry Cao on 5/3/14.
//  Copyright (c) 2014 oslife. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BeaconViewController;

@interface SettingsView : UIView

@property (nonatomic, weak) IBOutlet UIButton *blueButton;

@property (nonatomic, weak) IBOutlet UIButton *greenButton;
@property (nonatomic, weak) IBOutlet UIButton *orangeButton;
@property (nonatomic, weak) IBOutlet UIButton *pinkButton;
@property (nonatomic, weak) IBOutlet UIButton *purpleButton;
@property (nonatomic, weak) IBOutlet UIButton *yellowButton;

@property (nonatomic, weak) IBOutlet UISwitch *enableMessages;


@property (nonatomic, weak) BeaconViewController *parent;

- (IBAction)changeColor:(id)sender;
- (IBAction)toggleMessages:(id)sender;

@end

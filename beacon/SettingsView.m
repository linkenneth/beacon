//
//  SettingsView.m
//  beacon
//
//  Created by Larry Cao on 5/3/14.
//  Copyright (c) 2014 oslife. All rights reserved.
//

#import "SettingsView.h"
#import "UIImage+ColorAtPixel.h"
#import "BeaconViewController.h"

@interface SettingsView()


@end

@implementation SettingsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = .5;
        self.opaque = NO;
        
    }
    return self;
}
//
- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        self.opaque = NO;

        // Initialization code
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

- (IBAction)changeColor:(id)sender {
    
    UIColor *color = [[[(UIButton *)sender imageView] image] colorAtPixel:CGPointMake(5, 5)];
    
    [self.parent changeBackgroundColorTo:color];
    
}

- (IBAction)toggleMessages:(id)sender {
    if (self.parent.listenEnabledSwitch) {
        [self.parent.listenEnabledSwitch setOn:NO];
    } else {
        [self.parent.listenEnabledSwitch setOn:YES];
    }
    
}
@end

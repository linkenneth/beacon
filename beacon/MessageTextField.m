//
//  MessageTextField.m
//  beacon
//
//  Created by Larry Cao on 5/3/14.
//  Copyright (c) 2014 oslife. All rights reserved.
//

#import "MessageTextField.h"

@implementation MessageTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registerGesture];
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self registerGesture];
        // Initialization code
    }
    return self;
}

- (void)registerGesture {
    
    UISwipeGestureRecognizer *swipe = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(discardMessage)];
    swipe.direction = UISwipeGestureRecognizerDirectionDown;
    
    [self addGestureRecognizer:swipe];
    
}

- (void)discardMessage {
    CGRect previousFrame = self.frame;
    [UIView animateWithDuration:1 animations:^{
        self.frame = CGRectMake(0, self.superview.bounds.size.height, self.bounds.size.width, self.bounds.size.height);
        self.alpha = 0;
    } completion:^(BOOL finished) {
        self.frame = previousFrame;
        self.hidden = YES;
        self.text = @"";
        [self resignFirstResponder];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [super textRectForBounds:UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(10, 10, 10, 10))];
}


- (CGRect)editingRectForBounds:(CGRect)bounds {
    return [super editingRectForBounds:UIEdgeInsetsInsetRect(bounds, UIEdgeInsetsMake(10, 10, 10, 10))];
}

//- (void)drawTextInRect:(CGRect)rect
//{
//    [super drawTextInRect: CGRectInset(self.bounds, MARGIN, MARGIN)];
//}
@end

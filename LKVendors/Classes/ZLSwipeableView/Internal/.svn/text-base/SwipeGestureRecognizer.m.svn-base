//
//  SwipeGestureRecognizer.m
//  ZLSwipeableViewDemo
//
//  Created by WZheng on 2019/6/21.
//  Copyright © 2019 Zhixuan Lai. All rights reserved.
//

#import "SwipeGestureRecognizer.h"

@implementation SwipeGestureRecognizer

- (instancetype)initWithTarget:(nullable id)target action:(nullable SEL)action
                       touches:(NSUInteger)numbers
                     direction:(UISwipeGestureRecognizerDirection)direction{
    
    self = [super initWithTarget:target action:action];
    if (self) {
        
        self.numberOfTouchesRequired = numbers;
        self.direction = direction;
    }
    return self;
}

@end

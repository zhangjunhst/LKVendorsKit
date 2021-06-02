//
//  SwipeGestureRecognizer.h
//  ZLSwipeableViewDemo
//
//  Created by WZheng on 2019/6/21.
//  Copyright © 2019 Zhixuan Lai. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwipeGestureRecognizer : UISwipeGestureRecognizer

- (instancetype)initWithTarget:(nullable id)target action:(nullable SEL)action
               touches:(NSUInteger)numbers
                     direction:(UISwipeGestureRecognizerDirection)direction;

@end

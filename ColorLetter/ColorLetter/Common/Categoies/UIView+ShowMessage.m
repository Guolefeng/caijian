//
//  UIView+ShowMessage.m
//  YZY_ qdaily
//
//  Created by dllo on 16/9/26.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "UIView+ShowMessage.h"
#import "UILabel+SizeToFit_W_H.h"

#define SCREEN_W [UIScreen mainScreen].bounds.size.width
#define SCREEN_H [UIScreen mainScreen].bounds.size.height

@implementation UIView (ShowMessage)

+ (void)showMessage:(NSString *)message {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor blackColor];
    view.frame = CGRectMake(1, 1, 1, 1);
    view.alpha = 1.0;
    view.layer.cornerRadius = 9;
    [window addSubview:view];
    
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:18];
    label.text = message;
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    CGFloat width = [UILabel getWidthWithTitle:message font:label.font];
    label.frame = CGRectMake(10, 5, width, 20);
    [view addSubview:label];
    view.frame = CGRectMake((SCREEN_W - width - 20) / 2, SCREEN_H / 2 + 100, width + 20 , 25);
    [UIView animateWithDuration:2.0f animations:^{
        view.frame = CGRectMake((SCREEN_W - width - 20) / 2, SCREEN_H / 2 + 70, width + 20, 30);
        view.alpha = 0;
    } completion:^(BOOL finished) {
        [view removeFromSuperview];
    }];
}


@end

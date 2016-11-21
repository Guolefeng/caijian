//
//  UIBarButtonItem+SetImage_Click.m
//  GeekCourse
//
//  Created by dllo on 16/10/8.
//  Copyright © 2016年 Guolefeng. All rights reserved.
//

#import "UIBarButtonItem+SetImage_Click.h"
#import "UIButton+Block.h"

@implementation UIBarButtonItem (SetImage_Click)

+ (UIBarButtonItem *)getBarButtonItemWithImage:(UIImage *)image target:(CallBack)block {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, 21, 21);
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button handleControlEvent:UIControlEventTouchUpInside withBlock:^{
        block();
    }];
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barButtonItem;
}

@end

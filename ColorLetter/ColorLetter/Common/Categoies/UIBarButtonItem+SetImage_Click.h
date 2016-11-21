//
//  UIBarButtonItem+SetImage_Click.h
//  GeekCourse
//
//  Created by dllo on 16/10/8.
//  Copyright © 2016年 Guolefeng. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CallBack)();

@interface UIBarButtonItem (SetImage_Click)

+ (UIBarButtonItem *)getBarButtonItemWithImage:(UIImage *)image target:(CallBack)block;

@end

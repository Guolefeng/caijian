//
//  UIButton+Block.h
//  ColorLetter
//
//  Created by dllo on 16/10/19.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>


@interface UIButton (Block)

typedef void (^Callback)();

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(Callback)block;


@end

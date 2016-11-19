//
//  UIButton+Block.m
//  ColorLetter
//
//  Created by dllo on 16/10/19.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "UIButton+Block.h"
#import <objc/runtime.h>


@implementation UIButton (Block)

static char overviewKey;

- (void)handleControlEvent:(UIControlEvents)controlEvent withBlock:(Callback)block {
    [self removeTarget:self action:@selector(callActionBlock:) forControlEvents:controlEvent];
    objc_setAssociatedObject(self, &overviewKey, block, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self addTarget:self action:@selector(callActionBlock:) forControlEvents:controlEvent];
}

- (void)callActionBlock:(id)sender {
    Callback block = (Callback)objc_getAssociatedObject(self, &overviewKey);
    if (block) {
        block();
    }
}

@end

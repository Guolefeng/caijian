//
//  FZY_SliderScrollView.m
//  ColorLetter
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_SliderScrollView.h"

@interface FZY_SliderScrollView ()

@property (nonatomic, assign) BOOL isMoved;

@end

@implementation FZY_SliderScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = [UIColor blackColor];
        
    }
    return self;
}

- (void)touchesMoved:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    // 当前触摸的点
    CGPoint current = [touch locationInView:self];
    // 上次触摸的点
    CGPoint previous = [touch previousLocationInView:self];
    CGPoint center = self.center;
    center.x += current.x - previous.x;
    
    // 限制移动范围
    CGFloat xMin = self.frame.size.width * 0.5f;
    CGFloat xMax = (WIDTH - 120) - xMin;
    
    if (center.x > xMax) center.x = xMax;
    if (center.x < xMin) center.x = xMin;
    
    self.center = center;
    
    [self.sliderDelegate getSliderPostionX:self.frame.origin.x];

}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.isMoved = NO;
    // 回到一定范围
    CGFloat x = self.frame.size.width * 0.5f;
    [UIView animateWithDuration:0.25f animations:^{
        CGPoint center = self.center;
        center.x = self.center.x > (WIDTH - 120) * 0.5f ? (WIDTH - 120)- x - 3: x + 3;
        self.center = center;
    }];
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

//
//  FZY_SliderScrollView.h
//  ColorLetter
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FZY_SliderScrollViewDelegate <NSObject>

- (void)getSliderPostionX:(CGFloat)x;

@end

@interface FZY_SliderScrollView : UIScrollView

@property (nonatomic, assign) id<FZY_SliderScrollViewDelegate>sliderDelegate;

@end

//
//  FZY_KeyboardCollectionViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_KeyboardCollectionViewCell.h"

@implementation FZY_KeyboardCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:_backImageView];
        [_backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.contentView.mas_centerX).offset(0);
            make.centerY.equalTo(self.contentView.mas_centerY).offset(0);
            make.width.height.equalTo(@40);
        }];
    }
    return self;
}

@end

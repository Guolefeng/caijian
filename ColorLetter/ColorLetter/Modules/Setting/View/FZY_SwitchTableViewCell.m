//
//  FZY_SwitchTableViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_SwitchTableViewCell.h"

@interface FZY_SwitchTableViewCell ()

@property (nonatomic, strong) UISwitch *switchController;

@end

@implementation FZY_SwitchTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.switchController = [[UISwitch alloc] init];
        _switchController.onTintColor = [UIColor colorWithRed:0.34 green:0.78 blue:0.46 alpha:1];
        _switchController.thumbTintColor = [UIColor whiteColor];
        [_switchController setOn:YES animated:YES];
        [_switchController addTarget:self action:@selector(switchValueChanged:) forControlEvents:UIControlEventValueChanged];
        [self addSubview:_switchController];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_switchController mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.width.equalTo(@100);
        make.height.equalTo(@35);
    }];
}

- (void)switchValueChanged:(UISwitch *)switchControl {

}


@end

//
//  FZY_GroupTableViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/11/9.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_GroupTableViewCell.h"
@interface FZY_GroupTableViewCell ()

@property (nonatomic, strong) UIImageView *headImageView;


@end

@implementation FZY_GroupTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.image = [UIImage imageNamed:@"bg-mob"];
       
        [self.contentView addSubview:_headImageView];
        
        self.nameLabel = [[UILabel alloc] init];
        [_nameLabel sizeToFit];
        _nameLabel.font = [UIFont systemFontOfSize:20];
        _nameLabel.textColor = [UIColor blackColor];
        [self.contentView addSubview:_nameLabel];
        
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(self.contentView.frame.size.height - 20));
        make.height.equalTo(@(self.contentView.frame.size.height - 20));
    }];
    _headImageView.layer.cornerRadius = (self.contentView.frame.size.height - 20) / 2;
    _headImageView.clipsToBounds = YES;
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@(self.contentView.frame.size.height / 2));
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

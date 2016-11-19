//
//  FZY_FriendsTableViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/10/28.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_FriendsTableViewCell.h"

@implementation FZY_FriendsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        self.headImageView = [[UIImageView alloc] init];
        _headImageView.image = [UIImage imageNamed:@"mood-happy"];
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
    
    _headImageView.layer.cornerRadius = 25;
    _headImageView.clipsToBounds = YES;
    
    [_nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_headImageView.mas_right).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@20);
    }];

}

- (void)setImageUrl:(NSString *)imageUrl {
    if (_imageUrl != imageUrl) {
        _imageUrl = imageUrl;
        [_headImageView sd_setImageWithURL:[NSURL URLWithString:_imageUrl] placeholderImage:[UIImage imageNamed:@"mood-confused"]];
    }
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

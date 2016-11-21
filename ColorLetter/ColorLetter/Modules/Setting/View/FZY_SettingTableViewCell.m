//
//  FZY_SettingTableViewCell.m
//  ColorLetter
//
//  Created by dllo on 16/10/21.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_SettingTableViewCell.h"


@implementation FZY_SettingTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.cellLabel = [[UILabel alloc] init];
        //        _cellLabel.font = [UIFont fontWithName:@"Papyrus" size:15];
        _cellLabel.font = [UIFont fontWithName:@"Chalkboard SE" size:15];
        
        _cellLabel.textColor = [UIColor blackColor];
        _cellLabel.numberOfLines = 0;
        [_cellLabel sizeToFit];
        [self.contentView addSubview:_cellLabel];
        
        self.cellImageView = [[UIImageView alloc] init];
        [self addSubview:_cellImageView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_cellImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.width.equalTo(@(self.contentView.frame.size.height - 20 ));
        make.height.equalTo(@(self.contentView.frame.size.height - 20));
    }];
    
    [_cellLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cellImageView.mas_right).offset(20);
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.height.equalTo(@(self.contentView.frame.size.height));
    }];
}

- (void)setCellName:(NSString *)cellName {
    if (_cellName != cellName) {
        _cellName = cellName;
        _cellLabel.text = _cellName;
    }
}

- (void)setCellImage:(NSString *)cellImage {
    if (_cellImage != cellImage) {
        _cellImage = cellImage;
        _cellImageView.image = [UIImage imageNamed:_cellImage];
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

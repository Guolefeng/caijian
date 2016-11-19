//
//  FZY_BmobObject.h
//  ColorLetter
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseModel.h"

@interface FZY_BmobObject : FZYBaseModel

/**
 *  从字典创建BmobObject
 *
 *  @param dictionary 字典
 *
 *  @return BmobObject 对象
 */
- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

//单例
+ (FZY_BmobObject *)shareBmob;





@end

//
//  FZYBaseModel.m
//  ColorLetter
//
//  Created by dllo on 16/10/19.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZYBaseModel.h"

@implementation FZYBaseModel

- (instancetype)initWithDic:(NSDictionary *)dic {
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dic];
    }
    return self;
}

+ (instancetype)modelWithDic:(NSDictionary *)dic {
    return [[self alloc] initWithDic:dic];
}


- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
    
}

- (id)valueForUndefinedKey:(NSString *)key {
    return nil;
}


@end

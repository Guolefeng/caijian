//
//  FZY_BmobObject.m
//  ColorLetter
//
//  Created by dllo on 16/10/29.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_BmobObject.h"

@implementation FZY_BmobObject

+ (FZY_BmobObject *)shareBmob {
    
    static FZY_BmobObject *bmob = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        bmob = [[FZY_BmobObject alloc] init];
    });
    return bmob;
    
}

//- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
//    
//}
@end

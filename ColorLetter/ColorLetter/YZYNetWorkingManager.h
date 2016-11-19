//
//  YZYNetWorkingManager.h
//  YZYNetWorking
//
//  Created by dllo on 16/9/14.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YZYNetWorkingManager : NSObject

typedef void(^success) (id result);
typedef void(^failure) (NSError *error);

//+ (void)GET:(NSString *)string success:(void(^)(id result))success failure:(void(^)(NSError *error))failure;

//+ (void)POST:(NSString *)string Dic:(NSDictionary *)dic success:(void(^)(id result))success failure:(void(^)(NSError *error))failue;

+ (void)GET:(NSString *)string success:(success)success failure:(failure)failure;

+ (void)POST:(NSString *)string Dic:(NSDictionary *)dic success:(success)success failure:(failure)failure;




@end

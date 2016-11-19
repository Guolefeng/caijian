//
//  YZYNetWorkingManager.m
//  YZYNetWorking
//
//  Created by dllo on 16/9/14.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "YZYNetWorkingManager.h"

@implementation YZYNetWorkingManager

+ (NSString *)parseDictionaryToFormattedString:(NSDictionary *)dic
{
    NSMutableArray *tempArray = [NSMutableArray array];
    NSArray *keyArray = [dic allKeys];
    for (NSString *key in keyArray) {
        NSString *valueString = [dic objectForKey:key];
        NSString *formattedString = [NSString stringWithFormat:@"%@=%@", key, valueString];
        [tempArray addObject:formattedString];
    }
    NSString *finalString = [tempArray componentsJoinedByString:@"&"];
    return finalString;
}

+ (void)GET:(NSString *)string success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"GET";
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask= [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
//                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(data);
            });
        }else {
            failure(error);
        }
    }];
    [dataTask resume];
}

+ (void)POST:(NSString *)string Dic:(NSDictionary *)dic success:(void (^)(id))success failure:(void (^)(NSError *))failure  {
    if (0 == dic.count) {
        [YZYNetWorkingManager GET:string success:^(id result) {
            NSLog(@"%@", result);
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
        }];
    }
    string = [string stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL *url = [NSURL URLWithString:string];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    request.HTTPMethod = @"POST";
    NSString *dicString = [YZYNetWorkingManager parseDictionaryToFormattedString:dic];
    request.HTTPBody = [dicString dataUsingEncoding:NSUTF8StringEncoding];
    NSURLSession *session = [NSURLSession sharedSession];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                id result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                success(result);
            });
        }else {
            failure(error);
        };
    }];
    [dataTask resume];
    
}




@end

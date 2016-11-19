//
//  FZY_DataHandle.m
//  ColorLetter
//
//  Created by dllo on 16/10/31.
//  Copyright © 2016年 yzy. All rights reserved.
//

#import "FZY_DataHandle.h"
#import "FZY_User.h"

@interface FZY_DataHandle ()

@property (nonatomic, strong) FMDatabaseQueue *myQueue;

@end

@implementation FZY_DataHandle

+ (FZY_DataHandle *)shareDatahandle {
    static FZY_DataHandle *data = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        data = [[FZY_DataHandle alloc] init];
    });
    return data;
}



- (void)open {
    //1.获得数据库文件的路径
    NSString *doc =[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask, YES)  lastObject];
    
    NSString *fileName = [doc stringByAppendingPathComponent:@"user.sqlite"];
    
    self.myQueue = [FMDatabaseQueue databaseQueueWithPath:fileName];
    [_myQueue inDatabase:^(FMDatabase *db) {
        if ([db open]) {
            NSLog(@"打开成功");
            if ([db executeUpdate:@"create table if not exists user (user_id integer primary key autoincrement, name text NOT NULL, imageUrl text, userId text NOT NULL)"]) {
                NSLog(@"创建成功");
            }else {
                NSLog(@"创建失败");
            }
        }else {
            NSLog(@"打开失败");
        }
    }];
}

- (void)inset:(NSString *)name imageUrl:(NSString *)imageUrl userId:(NSString *)userId {
    [self.myQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"insert into user values (null, '%@', '%@', '%@')", name, imageUrl, userId];
        if ([db executeUpdate:sql]) {
//            NSLog(@"插入成功");
        }else {
//            NSLog(@"插入失败");
        }
        
    }];

}

- (void)insert:(FZY_User *)user {
    [self.myQueue inDatabase:^(FMDatabase *db) {
        
        NSString *sql = [NSString stringWithFormat:@"insert into user values (null, '%@', '%@', '%@')", user.name, user.imageUrl, user.userId];
        if ([db executeUpdate:sql]) {
//            NSLog(@"插入成功");
        }else {
//            NSLog(@"插入失败");
        }
        
    }];
}

- (void)deleteAll {
    [self.myQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdateWithFormat:@"delete from user"]) {
//            NSLog(@"删除成功");
        }else {
//            NSLog(@"删除失败");
        }
    }];
}

- (void)update:(NSString *)old new:(NSString *)newUrl {
    [self.myQueue inDatabase:^(FMDatabase *db) {
        if ([db executeUpdate:[NSString stringWithFormat:@"update user set imageurl = '%@' where imageUrl = '%@'", newUrl, old]]) {
//            NSLog(@"修改成功");
        }else {
//            NSLog(@"修改失败");
        }
    }];

}



//查询
- (NSArray *)select:(FZY_User *)user {
    NSMutableArray *array = [NSMutableArray array];
    [self.myQueue inDatabase:^(FMDatabase *db) {
        NSString *select;
        if (nil == user) {
            select = [NSString stringWithFormat:@"select * from user"];
        }else {
            select = [NSString stringWithFormat:@"select from user where name = '%@'", user.name];
        }
        FMResultSet *Set = [db executeQuery:select];
        while ([Set next]) {
            FZY_User * model = [[FZY_User alloc] init];
            // 从结果集中获取数据
            // 注：sqlite数据库不区别分大小写
            model.name = [Set stringForColumn:@"name"];
            model.imageUrl = [Set stringForColumn:@"imageUrl"];
            model.userId = [Set stringForColumn:@"userId"];
//            model.imageData = [Set dataForColumn:@"imageData"];
            [array addObject:model];
        }
    }];
    return array;
}


@end

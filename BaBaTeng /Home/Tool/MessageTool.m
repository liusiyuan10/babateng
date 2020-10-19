//
//  TerminologyTool.m
//  mTrackCargo
//
//  Created by liu on 16/6/17.
//  Copyright © 2016年 com.alphastark. All rights reserved.
//

#import "MessageTool.h"
#import "FMDB.h"


@interface MessageTool ()

@property (nonatomic, strong) FMDatabase *db;
@property (nonatomic, strong) NSMutableArray *modelAllArr;

@end

@implementation MessageTool

//- (NSMutableArray *)modelAllArr
//{
//    if (_modelAllArr == nil) {
//        _modelAllArr = [[NSMutableArray alloc] init];
//    }
//    
//    return _modelAllArr;
//}


//Status = A;
//TermDescription = "A container without any enclosure on one of its sides.";
//TermName = "Open-Side Container                                         ";
//lastupdatedate = "1/1/2015 12:00:00 AM";

- (instancetype)init
{
    
    self = [super init];
    if (self) {
        
        
        NSString *cachePath = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0];
        // 拼接文件名
        NSString *filePath = [cachePath stringByAppendingPathComponent:@"Message.sqlite"];
        
        NSLog(@"filePath%@",filePath);
        
        // 创建一个数据库的实例,仅仅在创建一个实例，并会打开数据库
        FMDatabase *db = [FMDatabase databaseWithPath:filePath];
        _db = db;
        // 打开数据库
        BOOL flag = [db open];
        if (flag) {
            NSLog(@"打开成功");
        }else{
            NSLog(@"打开失败");
        }
        
        // 创建数据库表
        // 数据库操作：插入，更新，删除都属于update
        // 参数：sqlite语句
        BOOL flag1 = [db executeUpdate:@"create table if not exists t_message (idStr text primary key,isShow INTEGER,isRead INTEGER,status INTEGER);"];
        if (flag1) {
            NSLog(@"创建成功");
        }else{
            NSLog(@"创建失败");
            
        }

    }
    return self;
//    select * from t_terminology order by lastupdatedate desc limit 1;
}


- (void)insertMessageArr:(NSMutableArray *)modelarr
{
    for (MessageModel *model in modelarr) {
        
        BOOL flag = [_db executeUpdate:@"insert into t_message (idStr,isShow,isRead,status) values (?,?,?,?)",model.idStr,model.isShow,model.isRead,model.status];
        if (flag) {
            NSLog(@"success");
        }else{
            NSLog(@"failure");
        }
        
    }

}

- (void)updateMessage:(NSString*)sql{

    
    BOOL flag = [_db executeUpdate:sql];
    if (flag) {
        NSLog(@"修改成功success");
    }else{
        NSLog(@"改failure");
    }

}

- (NSMutableArray *)selectAllModel:(NSString*)sql;
{

    FMResultSet *result =  [_db executeQuery:sql];
    self.modelAllArr= [[NSMutableArray alloc] init];
    // 从结果集里面往下找
    while ([result next]) {
    
        
        MessageModel *model = [[MessageModel alloc] init];
        
        model.idStr = [result stringForColumn:@"idStr"];
        model.isShow = [result stringForColumn:@"isShow"];
        model.isRead = [result stringForColumn:@"isRead"];
        model.status = [result stringForColumn:@"status"];
        
        [self.modelAllArr addObject:model];


    }
    
    return self.modelAllArr;
}

//- (NSString *)selectLatTimeStr
//{
//    FMResultSet *result =  [_db executeQuery:@"select * from t_terminology order by lastupdatedate desc limit 1"];
//    NSString *str = nil;
//    while ([result next]) {
//        str = [result stringForColumn:@"lastupdatedate"];
//    }
//    
//    return str;
//}

//- (NSMutableArray *)selectWithTermName:(NSString *)TerName
//{
////{select * from t_contact where name like '%%%@%%'
////    NSString *sqlstr= [NSString stringWithFormat:<#(nonnull NSString *), ...#>]
//    NSString *sqlstr= [NSString stringWithFormat:@"select * from t_terminology where TermName like '%%%@%%' ",TerName];
//    FMResultSet *result =  [_db executeQuery:sqlstr];
//    
//    NSMutableArray *modelArr = [[NSMutableArray alloc] init];
//    
//    // 从结果集里面往下找
//    while ([result next]) {
//        
//        TerminologyModel *model = [[TerminologyModel alloc] init];
//        
//        model.TermName = [result stringForColumn:@"TermName"];
//        model.TermDescription = [result stringForColumn:@"TermDescription"];
//        model.lastupdatedate = [result stringForColumn:@"lastupdatedate"];
//        model.Status = [result stringForColumn:@"Status"];
//        
//        [modelArr addObject:model];
//        
//        
//    }
//    
//    return modelArr;
//}

@end

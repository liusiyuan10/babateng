//
//  BBTAFmanager.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BBTAFmanager.h"

@implementation BBTAFmanager

+(AFHTTPSessionManager *)shareBBTManager {
    static AFHTTPSessionManager *manager=nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
//         manager.requestSerializer = [AFJSONRequestSerializer serializer];
//         manager.responseSerializer = [AFJSONResponseSerializer serializer];
        
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    });
    
    return manager;
}

+ (AFHTTPSessionManager*)defaultBBTManager {
    static AFHTTPSessionManager *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[AFHTTPSessionManager alloc]init];
        
    });
    return manager;
}


@end

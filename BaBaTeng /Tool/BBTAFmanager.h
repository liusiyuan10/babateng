//
//  BBTAFmanager.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface BBTAFmanager : AFHTTPSessionManager

+(AFHTTPSessionManager *)shareBBTManager;

+ (AFHTTPSessionManager*)defaultBBTManager;

@end

//
//  BVoiceModel.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/28.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BVoiceDataModel.h"

@interface BVoiceModel : NSObject

@property(nonatomic, copy) NSString *message;

@property(nonatomic, copy) NSString *statusCode;

@property(nonatomic, strong) BVoiceDataModel *data;
//{
//    data =     {
//        controldata =         (
//                               "M200 1 -100",
//                               "M200 2 100"
//                               );
//        dataStatusCode = 1;
//    };
//    message = success;
//    statusCode = 0;
//}

@end

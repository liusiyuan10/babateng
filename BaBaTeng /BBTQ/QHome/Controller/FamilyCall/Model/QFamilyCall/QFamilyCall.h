//
//  QFamilyCall.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/8.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QFamilyCallData.h"

@interface QFamilyCall : NSObject

@property (nonatomic, strong) QFamilyCallData *data;


@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;

@end


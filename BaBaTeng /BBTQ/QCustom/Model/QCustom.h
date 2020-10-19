//
//  QCustom.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/7/31.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class QCustomData;
@interface QCustom : NSObject

@property (nonatomic, strong) QCustomData *data;


@property (nonatomic, copy) NSString *message;


@property (nonatomic, copy) NSString *statusCode;


@end

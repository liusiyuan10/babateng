//
//  QMessage.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QMessageData.h"
@interface QMessage : NSObject

@property (nonatomic, strong) QMessageData *data;


@property (nonatomic, copy) NSString *message;


@property (nonatomic, copy) NSString *statusCode;

@end

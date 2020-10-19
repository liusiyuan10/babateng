//
//  QChat.h
//  BaBaTeng
//
//  Created by liu on 17/8/18.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QChatData.h"

@interface QChat : NSObject

@property(nonatomic, copy) NSString *message;

@property(nonatomic, copy) NSString *statusCode;

@property(nonatomic, strong) QChatData *data;

@end

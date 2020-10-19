//
//  MessageModel.h
//  BaBaTeng
//
//  Created by liu on 17/8/30.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic, strong) NSString *idStr;
@property (nonatomic, assign) NSString *isShow;
@property (nonatomic, assign) NSString *isRead;
@property (nonatomic, assign) NSString *status;

@end

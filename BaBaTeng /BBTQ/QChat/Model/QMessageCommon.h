//
//  QMessageCommon.h
//  BaBaTeng
//
//  Created by xyj on 2018/5/22.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QMessageCommon : NSObject

@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;

@end

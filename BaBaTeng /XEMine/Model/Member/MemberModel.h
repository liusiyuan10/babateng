//
//  MemberModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/11.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MemberDataModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface MemberModel : NSObject

@property (nonatomic, strong) MemberDataModel *data;

/***
 *价格
 */
@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;


@end

NS_ASSUME_NONNULL_END

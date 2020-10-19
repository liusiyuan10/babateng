//
//  Q2FavoriteRespone.h
//  XZ_WeChat
//
//  Created by liu on 17/3/17.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface QFavoriteRespone : NSObject

/***
 *	result
 */
@property (nonatomic, strong) NSArray *result;

/***
 *价格
 */
@property (nonatomic, copy) NSString *errcode;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *errinfo;


@end

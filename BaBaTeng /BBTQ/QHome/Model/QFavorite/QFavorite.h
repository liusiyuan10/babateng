//
//  QFavorite.h
//  BaBaTeng
//
//  Created by liu on 17/7/13.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "QFavoriteData.h"

@interface QFavorite : NSObject
@property (nonatomic, strong) QFavoriteData *data;

/***
 *价格
 */
@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;

@end

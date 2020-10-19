//
//  QAlbumResponse.h
//  BaBaTeng
//
//  Created by liu on 17/5/23.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface QAlbumResponse : NSObject

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

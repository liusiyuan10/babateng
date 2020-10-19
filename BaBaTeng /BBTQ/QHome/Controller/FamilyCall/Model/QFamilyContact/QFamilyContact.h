//
//  QFamilyContact.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/14.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QFamilyContactData.h"


@interface QFamilyContact : NSObject

@property (nonatomic, strong) QFamilyContactData *data;


@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;

@end

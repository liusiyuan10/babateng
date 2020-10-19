//
//  familyPhoneRecordC.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/13.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "familyPhoneRecordCData.h"

@interface familyPhoneRecordC : NSObject

@property (nonatomic, strong) familyPhoneRecordCData *data;


@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;

@end

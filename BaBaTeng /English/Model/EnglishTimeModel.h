//
//  EnglishTimeModel.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/11/1.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnglishTimeModel : NSObject

@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;


@property (nonatomic, copy) NSString *data;

@end

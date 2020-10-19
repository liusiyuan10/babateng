//
//  TotalCourse.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "TotalCourseData.h"

@interface TotalCourse : NSObject

@property (nonatomic, strong) TotalCourseData *data;


@property (nonatomic, copy) NSString *message;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString *statusCode;


@end

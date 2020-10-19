//
//  StudentCourseData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/25.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"

@interface StudentCourseData : NSObject<MJKeyValue>

@property (nonatomic, strong) NSArray  *list;


@property (nonatomic, copy) NSString   *pages;

/***
 *是否成功
 */
@property (nonatomic, copy) NSString   *total;

@end

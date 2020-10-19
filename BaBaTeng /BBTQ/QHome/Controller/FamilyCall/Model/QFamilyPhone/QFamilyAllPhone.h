//
//  QFamilyAllPhone.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/13.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@interface QFamilyAllPhone : NSObject<MJKeyValue>

@property (nonatomic, copy) NSString *callDate;

@property (nonatomic, strong) NSArray * phones;

@end

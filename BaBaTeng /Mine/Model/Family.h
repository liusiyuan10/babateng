//
//  Family.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FamilyData.h"
@interface Family : NSObject

@property (nonatomic, strong) FamilyData *data;


@property (nonatomic, copy) NSString *message;


@property (nonatomic, copy) NSString *statusCode;

@end

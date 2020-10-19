//
//  QSourceTypeData.h
//  BaBaTeng
//
//  Created by liu on 17/7/7.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MJExtension.h"


@interface QSourceTypeData : NSObject<MJKeyValue>


@property (nonatomic, copy) NSString       *deviceSourceTypeIcon;
@property (nonatomic, copy) NSString       *deviceSourceTypeName;
@property (nonatomic, copy) NSString       *deviceTypeId;
@property (nonatomic, copy) NSString       *sourceTypeId;
@property (nonatomic, copy) NSString       *flag;
@property (nonatomic, strong) NSArray      *sourceTags;

@end

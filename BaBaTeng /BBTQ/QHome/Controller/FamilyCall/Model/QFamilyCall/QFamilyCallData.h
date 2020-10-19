//
//  QFamilyCallData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/8.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QFamilyCalldeviceData.h"
#import "QFamilyCalllatelyFamilyPhoneData.h"

#import "QFamilyAllContact.h"

#import "MJExtension.h"

@interface QFamilyCallData : NSObject<MJKeyValue>

@property (nonatomic, strong) QFamilyCalldeviceData *device;

//@property (nonatomic, strong) QFamilyCalllatelyFamilyPhoneData *latelyFamilyPhone;
@property (nonatomic, strong) QFamilyAllContact *latelyFamilyPhone;


@property (nonatomic, strong) NSArray *topContacts;


@end

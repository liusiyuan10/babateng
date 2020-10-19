//
//  QFamilyContactData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/14.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "MJExtension.h"

@interface QFamilyContactData : NSObject<MJKeyValue>

@property (nonatomic, strong) NSArray *contacts;

@property (nonatomic, strong) NSArray * topContacts;

@end

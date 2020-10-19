//
//  familyPhoneRecordCData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/13.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "familyPhoneRecordCContact.h"

#import "QFamilyAllContact.h"

#import "MJExtension.h"

@interface familyPhoneRecordCData : NSObject<MJKeyValue>

//@property (nonatomic, strong) familyPhoneRecordCContact *familyContacts;
@property (nonatomic, strong) QFamilyAllContact *familyContacts;


@property (nonatomic, strong) NSArray *familyPhoneRecords;

@end

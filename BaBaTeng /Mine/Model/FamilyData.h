//
//  FamilyData.h
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FamilyData : NSObject
@property (nonatomic, copy) NSString *familyIconUrl;
@property (nonatomic, copy) NSString *familyId;
@property (nonatomic, copy) NSString *familyName;
@property (nonatomic, strong) NSMutableArray *familyMembers;

@end

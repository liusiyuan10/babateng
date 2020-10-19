//
//  QRecentCallDetailViewController.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/1/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

#import "QFamilyAllContact.h"

@interface QRecentCallDetailViewController : CommonViewController

@property (nonatomic,copy) NSString *contactsId;

@property (nonatomic, strong) QFamilyAllContact *FamilyContact;

@end

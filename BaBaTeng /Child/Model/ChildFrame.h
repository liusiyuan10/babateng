//
//  ChildFrame.h
//  BaBaTeng
//
//  Created by xyj on 2018/5/13.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BulletinData.h"

@interface ChildFrame : NSObject

@property(nonatomic,assign, readonly)CGRect iocnFrame;
@property(nonatomic,assign, readonly)CGRect tilteFrame;
@property(nonatomic,assign, readonly)CGRect contentFrame;
@property(nonatomic,assign, readonly)CGRect bgViewFrame;
@property(nonatomic,assign, readonly)CGRect backViewFrame;

@property(nonatomic,assign, readonly)CGFloat rowHeight;

@property(nonatomic, strong) BulletinData *bulltindata;
@end

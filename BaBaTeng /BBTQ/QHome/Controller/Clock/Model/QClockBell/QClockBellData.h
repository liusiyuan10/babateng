//
//  QClockBellData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/7/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QClockBellData : NSObject

//soundId    铃声编号    number    @mock=1
//soundName    铃声名称    string    @mock=铃声1
//soundUrl


@property (nonatomic, copy) NSString *soundId;

@property (nonatomic, copy) NSString *soundName;

@property (nonatomic, copy) NSString *soundUrl;

@end

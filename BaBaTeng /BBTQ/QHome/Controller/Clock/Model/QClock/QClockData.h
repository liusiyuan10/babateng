//
//  QClockData.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/7/4.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "QClockBellData.h"

@interface QClockData : NSObject

//clockId    闹钟编号    number    @mock=$order(2,3)
//clockSound    闹钟铃声对象    object
//createTime    创建时间    string    @mock=$order('2018-07-03 16:15:45','2018-07-03 16:18:55')
//deviceId    设备编号    string    @mock=$order('0100060000000001','0100060000000001')
//duration    播放时长    number    @mock=$order(120,120)
//enable    启用关闭    boolean    @mock=$order(true,true)
//repeat    重复时间    string    @mock=$order('1,2,3,4','1,2,3,4')
//songname    闹钟提示语    string    @mock=$order('起床了','起床了')
//soundId    铃声编号    number    @mock=$order(1,1)
//time    闹钟时间    string    @mock=$order('18:00:00','18:00:00')
//timezon    时区    number    @mock=$order(44,44)
//type    类型    number    @mock=$order(1,1)
//userId

@property (nonatomic, copy) NSString *clockId;

@property (nonatomic, strong) QClockBellData *clockSound;

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *deviceId;

@property (nonatomic, copy) NSString *duration;

@property (nonatomic, copy) NSString *enable;

@property (nonatomic, copy) NSString *repeat;

@property (nonatomic, copy) NSString *songname;

@property (nonatomic, copy) NSString *soundId;

@property (nonatomic, copy) NSString *time;

@property (nonatomic, copy) NSString *timezon;

@property (nonatomic, copy) NSString *type;

@property (nonatomic, copy) NSString *userId;

@end

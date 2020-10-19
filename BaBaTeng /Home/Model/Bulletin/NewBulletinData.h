//
//  NewBulletinData.h
//  BaBaTeng
//
//  Created by xyj on 2019/2/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NewBulletinData : NSObject

//contentIcon    图标    string    @mock=$order('http://test.file.babateng.cn/image%2Ficon%2Fcfe9a310-6a4f-4802-b008-7f74731e6336.png','http://test.file.babateng.cn/image%2Ficon%2F60aabc42-2c9c-4b3d-8770-a995e55473ae.png','http://test.file.babateng.cn/image%2Ficon%2F05426f89-93a9-4361-a1ac-3ba428714381.png','http://test.file.babateng.cn/image%2Ficon%2F0969bcb5-77d0-40db-b449-6be3a1170a12.png','http://test.file.babateng.cn/image%2Ficon%2F179b04bd-8d81-47d0-aa8a-041cfab39745.png')
//contentKey    专辑Id,板块ID，或者公告ID
//contentName    内容名称
//contentType    1:H5,2:公告，3：专辑，4：板块    number    @mock=$order(1,3,4,3,3)
//contentUrl    当为H5有效    string    @mock=$order('http://192.168.1.106:8080/#/appManagement','undefined','undefined','undefined','undefined')
//createTime    创建时间    string    @mock=$order('2019-02-12 11:16:29','2019-02-12 11:16:49','2019-02-12 11:17:05','2019-02-12 15:49:39','2019-02-12 16:54:48')
//deviceTypeId    设备类型    string    @mock=$order('738001','738001','738001','738001','738001')
//recommendId    编号    number    @mock=$order(38,39,40,55,56)
//recommendTitle    推荐标题    string    @mock=$order('巴巴腾','巴巴腾','巴巴腾','ddddeeee','ddd')
//recommendType

@property(nonatomic, copy) NSString *contentIcon;
@property(nonatomic, copy) NSString *contentKey;
@property(nonatomic, copy) NSString *contentName;
@property(nonatomic, copy) NSString *contentType;
@property(nonatomic, copy) NSString *contentUrl;
@property(nonatomic, copy) NSString *createTime;
@property(nonatomic, copy) NSString *deviceTypeId;
@property(nonatomic, copy) NSString *recommendId;
@property(nonatomic, copy) NSString *recommendTitle;
@property(nonatomic, copy) NSString *recommendType;


@end

NS_ASSUME_NONNULL_END

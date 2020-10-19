//
//  PanetMineAddressListModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PanetMineAddressListModel : NSObject

//address    详细地址    string    @mock=梧桐岛
//addressId    编号    number    @mock=1
//area    地区    string    @mock=宝安区
//city    城市    string    @mock=深圳市
//createTime    创建时间    string    @mock=2019-02-28 17:42:29
//isDefault    是否是默认地址    boolean    @mock=true
//postCode    邮政编码    string    @mock=518000
//province    省份    string    @mock=广东省
//receiverName    收货人姓名    string    @mock=朱敏
//receiverPhone    收货人手机号码    string    @mock=15112295282
//userId

@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *addressId;
@property (nonatomic, copy) NSString *area;
@property (nonatomic, copy) NSString *city;
@property (nonatomic, copy) NSString *createTime;
@property (nonatomic, copy) NSString *isDefault;
@property (nonatomic, copy) NSString *postCode;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *receiverName;
@property (nonatomic, copy) NSString *receiverPhone;
@property (nonatomic, copy) NSString *userId;

@end

NS_ASSUME_NONNULL_END

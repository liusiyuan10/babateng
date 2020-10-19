//
//  MineOneCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/2.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XEMButton.h"

NS_ASSUME_NONNULL_BEGIN

@interface MineOneCell : UITableViewCell
@property(nonatomic, strong) XEMButton *paymentlBtn;
@property(nonatomic, strong) XEMButton *receiveBtn;
@property(nonatomic, strong) XEMButton *completedBtn;
@property(nonatomic, strong) XEMButton *myorderBtn;


//    wait for receiving
//
//        completed
//        My order

@end

NS_ASSUME_NONNULL_END

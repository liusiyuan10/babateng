//
//  PayRecordCell.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/20.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PayRecordCell : UITableViewCell

@property(nonatomic,strong) UIButton *courseBtn;
@property(nonatomic,strong) UILabel *amountLabel;
@property(nonatomic,strong) UILabel *EveryamountLabel;
@property(nonatomic,strong) UILabel *timeLabel;
@property(nonatomic,strong) UILabel *givingnumLabel;

@property(nonatomic,strong) UILabel *paysuccessLabel;

@property(nonatomic,strong) UILabel *payTypeLabel;


@end

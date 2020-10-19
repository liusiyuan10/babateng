//
//  ChildViewCell.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/23.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BulletinData,ChildFrame;

@interface ChildViewCell : UITableViewCell

@property(nonatomic,strong)UIImageView *iocnView;
@property(nonatomic,strong)UILabel *tilteLabel;
@property(nonatomic,strong)UILabel *contentLabel;

@property(nonatomic,strong)UIView *bgView;
@property(nonatomic,strong)UIView *backView;

@property(nonatomic,strong)ChildFrame *childFrame;

@end

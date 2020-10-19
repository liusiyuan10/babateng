//
//  QFamilyCallCell.h
//  BaBaTeng
//
//  Created by liu on 17/12/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QFamilyCallCell;

@protocol QFamilyCallCellDelegate <NSObject>

-(void)qfamilycall:(QFamilyCallCell *)heardViewClicked;
-(void)qfamilycallcellView:(QFamilyCallCell *)cellViewClicked;

@end

@interface QFamilyCallCell : UITableViewCell

@property (nonatomic, strong) UILabel *heardLabel;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *FamilyNameLabel;
@property (nonatomic, strong) UILabel *FamilyNumLabel;
@property (nonatomic, strong) UILabel *inboundLabel;
@property (nonatomic, strong) UILabel *BreatheoutLabel;

@property (nonatomic, strong) UIImageView *inboundView;

@property (nonatomic, strong) UIImageView *BreatheoutView;

@property (nonatomic, strong) UIButton *moreBtn;

@property (nonatomic, strong) UIView *cellView;

//@property (nonatomic, strong) UIImageView *normalImageView;

@property (nonatomic, strong) UIView *nocellView;
@property (nonatomic, strong) UILabel *noFamilhCallLabel;
@property (nonatomic, strong) UIImageView *noiconView;

@property(nonatomic,weak) id<QFamilyCallCellDelegate> delegate;

@end

//
//  XEMallOrderTwoCell.h
//  BaBaTeng
//
//  Created by xyj on 2019/4/4.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaceholderTextView.h"

@class XEMallOrderTwoCell;

@protocol XEMallOrderTwoCellDelegate <NSObject>

- (void)XEMallOrderTwoCellBtnClicked:(XEMallOrderTwoCell *)view selectnum:(NSString *)numstr;

- (void)XEMallOrderTextFieldEditDidEnd:(XEMallOrderTwoCell *)view Text:(NSString *)textstr;
@end

NS_ASSUME_NONNULL_BEGIN



@interface XEMallOrderTwoCell : UITableViewCell

@property(nonatomic,strong) UIImageView *leftImage;

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *priceLabel;
@property(nonatomic,strong)UITextField *numField;
@property(nonatomic,strong)PlaceholderTextView *noteField;
@property(nonatomic,strong)UIButton *phoneBtn;
@property(nonatomic, assign) id<XEMallOrderTwoCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

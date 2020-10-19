//
//  QAlbumPayView.h
//  BaBaTeng
//
//  Created by 柳思源 on 2017/12/26.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface QAlbumPayView : UIView
//
//@end


#import <UIKit/UIKit.h>
@class XEUpgradeView;

@protocol XEUpgradeViewDelegate <NSObject>

- (void)XEUpgradeViewBtnClicked:(XEUpgradeView *)view;

@end

@interface XEUpgradeView : UIView

- (void)showInView:(UIView *)view;

@property(nonatomic, assign) id<XEUpgradeViewDelegate> delegate;

@property(nonatomic, strong) NSString *priceStr;
@property(nonatomic, strong) NSString *levelStr;
- (void)initContent;

@end

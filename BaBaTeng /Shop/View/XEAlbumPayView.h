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
@class XEAlbumPayView;

@protocol XEAlbumPayViewDelegate <NSObject>

- (void)XEAlbumPayViewBtnClicked:(XEAlbumPayView *)view;

@end

@interface XEAlbumPayView : UIView

- (void)showInView:(UIView *)view;

@property(nonatomic, assign) id<XEAlbumPayViewDelegate> delegate;

@property(nonatomic, strong) NSString *priceStr;

- (void)initContent;

@end

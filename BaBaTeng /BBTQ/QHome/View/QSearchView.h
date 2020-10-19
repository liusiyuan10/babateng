//
//  QSearchView.h
//  BaBaTeng
//
//  Created by liu on 17/6/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//
//
//#import <UIKit/UIKit.h>
//
//@interface QSearchView : UIView
//
//@end


#import <UIKit/UIKit.h>
@class QSearchView;
@class QTrackListResponse;
@protocol QSearchViewwDelegate <NSObject>

- (void)QSearchViewAddBtnClicked:(QSearchView *)view selectModel:(QTrackListResponse *)model;

@end

@interface QSearchView : UIView

- (void)showInView:(UIView *)view;

@property(nonatomic, assign) id<QSearchViewwDelegate> delegate;

@end

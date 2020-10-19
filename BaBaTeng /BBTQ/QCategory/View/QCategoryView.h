//
//  QCategoryView.h
//  BaBaTeng
//
//  Created by liu on 17/6/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface QCategoryView : UIView
//
//@end


#import <UIKit/UIKit.h>
@class QCategoryView;
@class QTrackListResponse;
@protocol QCategoryViewDelegate <NSObject>

- (void)QCategoryViewAddBtnClicked:(QCategoryView *)view selectModel:(QTrackListResponse *)model;

@end

@interface QCategoryView : UIView

- (void)showInView:(UIView *)view;

@property(nonatomic, assign) id<QCategoryViewDelegate> delegate;

@end

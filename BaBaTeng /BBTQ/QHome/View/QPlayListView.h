//
//  Q3PlayListView.h
//  XZ_WeChat
//
//  Created by liu on 17/3/23.
//  Copyright © 2017年 gxz. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QPlayListView;
@class QSongDataList;
@protocol QPlayListViewDelegate <NSObject>

- (void)QPlayListViewAddBtnClicked:(QPlayListView *)view selectModel:(QSongDataList *)model;

@end

@interface QPlayListView : UIView

- (void)showInView:(UIView *)view;

@property(nonatomic, assign) id<QPlayListViewDelegate> delegate;

@property(nonatomic, strong) NSString *albumPlaystr;

@end

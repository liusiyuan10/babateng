//
//  YGPlayerView.h
//  Demo
//
//  Created by LiYugang on 2018/3/5.
//  Copyright © 2018年 LiYugang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class YGPlayInfo,YGPlayerView;

@protocol YGPlayerViewDelegate <NSObject>

- (void)YGPlayerViewBtnClicked:(YGPlayerView *)view;
- (void)YGPlayerViewrotateBtnClicked:(YGPlayerView *)view RType:(NSString *)type;

@end

@interface YGPlayerView : UIView
- (void)playWithPlayInfo:(YGPlayInfo *)playInfo;

@property(nonatomic, assign) id<YGPlayerViewDelegate> delegate;

@property (nonatomic, strong) NSMutableArray *playInfos;

- (void)YGbackForePage;

@end

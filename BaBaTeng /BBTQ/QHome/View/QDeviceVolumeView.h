//
//  QDeviceVolumeView.h
//  BaBaTeng
//
//  Created by liu on 17/5/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
@class QDeviceVolumeView;

@protocol QDeviceVolumeViewDelegate <NSObject>

- (void)QDeviceVolumeViewBtnClicked:(QDeviceVolumeView *)view selectName:(NSString *)name;

@end


@interface QDeviceVolumeView : UIView

@property(nonatomic, assign) id<QDeviceVolumeViewDelegate> delegate;

- (void)showInView:(UIView *)view;

@property(nonatomic, assign) NSInteger volumenum;

@end

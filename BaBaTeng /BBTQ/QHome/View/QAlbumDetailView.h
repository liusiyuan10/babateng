//
//  QAlbumDetailView.h
//  BaBaTeng
//
//  Created by liu on 17/6/21.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface QAlbumDetailView : UIView
//
//@end


#import <UIKit/UIKit.h>
@class QAlbumDetailView;

@protocol QAlbumDetailViewDelegate <NSObject>

- (void)QDeviceVolumeViewBtnClicked:(QAlbumDetailView *)view selectName:(NSString *)name;

- (void)QDeviceVolumeViewAddBtnClicked:(QAlbumDetailView *)view;

- (void)QDeviceVolumeViewAddFavoriteBtnClicked:(QAlbumDetailView *)view;
@end


@interface QAlbumDetailView : UIView

@property(nonatomic, assign) id<QAlbumDetailViewDelegate> delegate;

- (void)showInView:(UIView *)view;

@property (nonatomic, strong) NSString *albumPlaystr;


@end

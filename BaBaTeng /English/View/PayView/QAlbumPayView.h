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
@class QAlbumPayView;

@protocol QAlbumPayViewDelegate <NSObject>

- (void)QAlbumPayViewBtnClicked:(QAlbumPayView *)view selectName:(NSString *)name selectIndex:(NSInteger)selectindex;

@end

@interface QAlbumPayView : UIView

- (void)showInView:(UIView *)view;

@property(nonatomic, assign) id<QAlbumPayViewDelegate> delegate;



- (void)initContent;

@end

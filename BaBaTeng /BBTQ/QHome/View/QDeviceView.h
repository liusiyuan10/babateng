//
//  QDeviceView.h
//  BaBaTeng
//
//  Created by liu on 17/5/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface QDeviceView : UIView
//
//@end


#import <UIKit/UIKit.h>
@class QDeviceView;

@protocol QDeviceViewDelegate <NSObject>

- (void)QDeviceViewBtnClicked:(QDeviceView *)view selectName:(NSString *)name selectIndex:(NSInteger)selectindex;

@end

@interface QDeviceView : UIView

- (void)showInView:(UIView *)view;

@property(nonatomic, assign) id<QDeviceViewDelegate> delegate;

@property(nonatomic, strong) NSString *QDeviceType;

- (void)initContent;

@end

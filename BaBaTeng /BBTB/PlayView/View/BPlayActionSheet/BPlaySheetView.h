//
//  GYZSheetView.h
//  GYZCustomActionSheet
//
//  Created by GYZ on 16/6/20.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QAlbumDataTrackList.h"
typedef NS_ENUM(NSUInteger, NSCellTextStyle) {
    NSTextStyleCenter = 0,    ///cell文字默认样式居中
    NSTextStyleLeft,          ///cell文字样式居左
    NSTextStyleRight,         ///cell文字样式居右
};

@protocol BPlaySheetViewDelegate <NSObject>
- (void)sheetViewDidSelectIndex:(NSInteger)Index selectTitle:(QAlbumDataTrackList *)title;
@end

@interface BPlaySheetView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id<BPlaySheetViewDelegate> delegate;
@property (strong, nonatomic) UIColor *cellTextColor;
@property (strong, nonatomic) UIFont *cellTextFont;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) BOOL showTableDivLine;
@property (assign, nonatomic) NSCellTextStyle cellTextStyle;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (nonatomic) UIView *divLine;

@property (assign, nonatomic) QAlbumDataTrackList *resultRespone;

@end

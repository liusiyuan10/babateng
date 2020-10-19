//
//  GYZSheetView.h
//  GYZCustomActionSheet
//
//  Created by GYZ on 16/6/20.
//  Copyright © 2016年 GYZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "QAlbumDataTrackList.h"
#import "QplayType.h"
#import "QCustomData.h"
typedef NS_ENUM(NSUInteger, NSCellTextStyle) {
    NSTextStyleCenter = 0,    ///cell文字默认样式居中
    NSTextStyleLeft,          ///cell文字样式居左
    NSTextStyleRight,         ///cell文字样式居右
};

@protocol GYZSheetViewDelegate <NSObject>
- (void)sheetViewDidSelectIndex:(NSInteger)Index selectTitle:(QAlbumDataTrackList *)title selectPlayType:(QplayType *)qPlayType selectQCustomData:(QCustomData*)qCustomData;
@end

@interface GYZSheetView : UIView<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) UITableView *tableView;
@property (weak, nonatomic) id<GYZSheetViewDelegate> delegate;
@property (strong, nonatomic) UIColor *cellTextColor;
@property (strong, nonatomic) UIFont *cellTextFont;
@property (assign, nonatomic) CGFloat cellHeight;
@property (assign, nonatomic) BOOL showTableDivLine;
@property (assign, nonatomic) BOOL selfPlaying;
@property (assign, nonatomic) NSCellTextStyle cellTextStyle;
@property (strong, nonatomic) NSMutableArray *dataSource;

@property (nonatomic) UIView *divLine;

@property (assign, nonatomic) QAlbumDataTrackList *resultRespone;

-(void)getCurrentPlayingTracksId:(NSString*)orderBy;

@end

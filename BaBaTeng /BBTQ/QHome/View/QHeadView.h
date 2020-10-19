//
//  HeadView.h
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol QHeadViewDelegate;

@interface QHeadView : UIView{

    NSInteger section;
    UIButton* backBtn;
    BOOL open;
}
@property(nonatomic, assign) id<QHeadViewDelegate> delegate;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) BOOL open;
@property(nonatomic, retain) UIButton* backBtn;

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *timeLabel;
@property(nonatomic,strong)UIImageView *myImageView;
@property(nonatomic,strong)UIButton *leftImage;
@property(nonatomic,strong)UIImageView *timeView;

@property(nonatomic,strong) UIButton *addBtn;

@property(nonatomic, assign) BOOL isPlay;

//cell.myImageView.frame = CGRectMake(10, 13,19, 14);

@end

@protocol QHeadViewDelegate <NSObject>
-(void)selectedWith:(QHeadView *)view;
- (void)QHeadViewBtnClicked:(QHeadView *)view leftBtn:(UIButton *)btn;
- (void)QHeadViewAddBtnClicked:(QHeadView *)view;
@end




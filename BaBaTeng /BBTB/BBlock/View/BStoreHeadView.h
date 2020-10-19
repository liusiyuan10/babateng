//
//  BStoreHeadView.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/8/2.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

//#import <UIKit/UIKit.h>
//
//@interface BStoreHeadView : UIView
//
//@end


#import <UIKit/UIKit.h>
@protocol BStoreHeadViewDelegate;

@interface BStoreHeadView : UIView{
    
    NSInteger section;
    UIButton* backBtn;
    BOOL open;
}
@property(nonatomic, assign) id<BStoreHeadViewDelegate> delegate;
@property(nonatomic, assign) NSInteger section;
@property(nonatomic, assign) BOOL open;
@property(nonatomic, retain) UIButton* backBtn;

@property(nonatomic,strong)UILabel *nameLabel;
@property(nonatomic,strong)UILabel *authorLabel;
@property(nonatomic,strong)UILabel *timeLabel;

@property(nonatomic,strong)UIImageView *leftImage;


@property(nonatomic,strong) UIButton *addBtn;



@end

@protocol BStoreHeadViewDelegate <NSObject>

-(void)selectedWith:(BStoreHeadView *)view;

- (void)BStoreHeadViewAddBtnClicked:(BStoreHeadView *)view;
@end




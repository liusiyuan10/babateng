//
//  EcgoSegmentTool.h
//  integral
//
//  Created by liu on 16/1/22.
//  Copyright © 2016年 ecg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    
    SelectLeftBtnCell = 0,
    SelectMidBtnCell = 1,
    SelectRightBtnCell = 2,
    SelectFourCell =3
    
} BtnSelectTypeCell;

@class QSegmentTool;

@protocol QSegmentToolCellDelegate <NSObject>

-(void)viewChangeWithType:(BtnSelectTypeCell)type;


@end

@interface QSegmentTool : UIView

@property (nonatomic, weak)id<QSegmentToolCellDelegate>delegate;
@property (nonatomic, retain)UIButton *baseInfoBtn;
@property (nonatomic, retain)UIButton *introduceBtn;
@property (nonatomic, retain)UIButton *appraiseBtn;

@property(nonatomic,strong)NSMutableArray *btnArray;
@property(nonatomic)BtnSelectTypeCell selectType;
@property (nonatomic, strong) UIImageView   *lineView;
@property (nonatomic, strong) UIImageView   *lineView1;
@property (nonatomic, strong) UIImageView   *lineView2;
@property (nonatomic, strong) UIImageView   *btnClickedImg;

@property (nonatomic, strong) UIImageView   *seperateLineOne;
@property (nonatomic, strong) UIImageView   *seperateLineTwo;
@property (nonatomic, strong) UIImageView   *seperateLineThree;

@property (nonatomic, assign) NSInteger btntag;

@property (nonatomic, strong) NSArray *itemsArr;


-(void)btnChangeTabAction:(UIButton *)btn;

- (void)setNProDetailSixCellInfo;

@end

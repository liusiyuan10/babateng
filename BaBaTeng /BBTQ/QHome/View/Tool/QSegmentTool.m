//
//  NProDetailSixCell.m
//  YijietongBuy
//
//  Created by YangGH on 15/10/9.
//  Copyright © 2015年 YangGH. All rights reserved.
//
#import "QSegmentTool.h"
#import "UIImage-Extensions.h"
#import "Header.h"
//#import "UIView+SNFoundation.h"
#import "Header.h"
@implementation QSegmentTool


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    //    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (UIImageView *)btnClickedImg
{
    if (!_btnClickedImg) {
        _btnClickedImg = [[UIImageView alloc] init];
        _btnClickedImg.image = [UIImage streImageNamed:@"segment_line_Horizontal_red.png"];
        _btnClickedImg.frame = CGRectMake(0, 63, kDeviceWidth/2, 2);
    }
    return _btnClickedImg;
}

- (UIImageView *)seperateLineOne
{
    if (!_seperateLineOne) {
        _seperateLineOne = [[UIImageView alloc] init];
        
        _seperateLineOne.image = [UIImage streImageNamed:@"segment_line_vertical_gray.png"];
    }
    return _seperateLineOne;
}

- (UIImageView *)seperateLineTwo
{
    if (!_seperateLineTwo) {
        _seperateLineTwo = [[UIImageView alloc] init];
        
        _seperateLineTwo.image = [UIImage streImageNamed:@"line.png"];
    }
    return _seperateLineTwo;
}
//
//- (UIImageView *)seperateLineThree
//{
//    if (!_seperateLineThree) {
//        _seperateLineThree = [[UIImageView alloc] init];
//
//        _seperateLineThree.image = [UIImage streImageNamed:@"line.png"];
//    }
//    return _seperateLineThree;
//}

- (void)setBtnsPropetry:(UIButton*)btn
{
    [btn addTarget:self action:@selector(btnChangeTabAction:) forControlEvents:UIControlEventTouchUpInside];
    
    //    [btn setBackgroundImage:nil forState:UIControlStateNormal];
    
    [btn setTitleColor:RGBCOLOR(247, 111, 44) forState:UIControlStateSelected];
    
    [btn setTitleColor:RGBCOLOR(93, 93, 93) forState:UIControlStateNormal];
    
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
}

-(UIButton *)baseInfoBtn{
    
    if (!_baseInfoBtn) {
        
        _baseInfoBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth/2, 4, kDeviceWidth/2, 65)];
        
        [self setBtnsPropetry:_baseInfoBtn];
        
        [_baseInfoBtn setTitle:@"专辑简介" forState:UIControlStateNormal];
        
        self.selectType = SelectMidBtnCell;
        
    }
    return _baseInfoBtn;
}

-(UIButton *)introduceBtn{
    
    if (!_introduceBtn) {
        
        _introduceBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 4, kDeviceWidth/2,65)];
        
        [self setBtnsPropetry:_introduceBtn];
        
        [_introduceBtn setTitle:@"列表" forState:UIControlStateNormal];
        
        self.selectType = SelectLeftBtnCell;
        
    }
    return _introduceBtn;
}

//-(UIButton *)appraiseBtn{
//
//    if (!_appraiseBtn) {
//
//        _appraiseBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth/4*2, 4, kDeviceWidth/4, 32)];
//
//        [self setBtnsPropetry:_appraiseBtn];
//
//        _appraiseBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//
//        [_appraiseBtn setTitle:@"评价(0)" forState:UIControlStateNormal];
//
//        self.selectType = SelectRightBtnCell;
//    }
//    return _appraiseBtn;
//}
//
//-(UIButton *)consultationBtn{
//
//    if (!_consultationBtn) {
//
//        _consultationBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth/4*3, 0, kDeviceWidth/4, 32)];
//
//        [self setBtnsPropetry:_consultationBtn];
//
//        _consultationBtn.titleLabel.adjustsFontSizeToFitWidth = YES;
//
//        [_consultationBtn setTitle:@"咨询(0)" forState:UIControlStateNormal];
//
//        self.selectType = SelectRightBtnCell;
//    }
//    return _consultationBtn;
//}




- (UIImageView *)lineView
{
    if (!_lineView) {
        _lineView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segment_line_vertical_gray.png"]];
        _lineView.backgroundColor = [UIColor clearColor];
    }
    return _lineView;
}

//- (UIImageView *)underLineImage
//{
//    if (!_underLineImage) {
//        _underLineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSeparatorLine.png"]];
//        _underLineImage.backgroundColor = [UIColor clearColor];
//    }
//    return _underLineImage;
//}

//- (UIImageView *)lineView1
//{
//    if (!_lineView1) {
//        _lineView1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segment_line_vertical_gray.png"]];
//        _lineView1.backgroundColor = [UIColor clearColor];
//    }
//    return _lineView1;
//}
//
//- (UIImageView *)lineView2
//{
//    if (!_lineView2) {
//        _lineView2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"segment_line_vertical_gray.png"]];
//        _lineView2.backgroundColor = [UIColor clearColor];
//    }
//    return _lineView2;
//}

//- (void)setNProDetailSixCellInfo:(DataProductBasic*)dto WithAppraiseNum:(NSString*)numStr
- (void)setNProDetailSixCellInfo
{
    [self addSubview:self.baseInfoBtn];
    
    [self addSubview:self.introduceBtn];
    
    
    
   // [self addSubview:self.lineView];
    
    
    
    [self addSubview:self.btnClickedImg];
    
    //    [self addSubview:self.underLineImage];
    
    [self addSubview:self.seperateLineOne];
    [self addSubview:self.seperateLineTwo];
    
    self.baseInfoBtn.frame = CGRectMake(kDeviceWidth/2, 0, kDeviceWidth/2, 65);
    self.introduceBtn.frame = CGRectMake(0, 0, kDeviceWidth/2, 65);
    //self.appraiseBtn.frame = CGRectMake(kDeviceWidth/4*2, 0, kDeviceWidth/4, 32);
    self.lineView.frame = CGRectMake(self.introduceBtn.rightX, 5, 1, 55);
    // self.lineView1.frame = CGRectMake(self.baseInfoBtn.right, 7, 1, 15);
    //self.lineView2.frame = CGRectMake(self.appraiseBtn.right, 7, 1, 15);
    
//    self.seperateLineOne.frame = CGRectMake(0, 0, kDeviceWidth, 0.5);
    //    self.seperateLineTwo.frame = CGRectMake(0, 51.5, kDeviceWidth, 0.5);
    
    //self.consultationBtn.enabled = YES;
}

-(NSArray *)btnArray{
    
    if (!_btnArray) {
        
        //        _btnArray = [[NSArray alloc] initWithObjects:self.introduceBtn,self.baseInfoBtn,self.appraiseBtn,self.consultationBtn, nil];
        
        
        _btnArray = [[NSArray alloc] initWithObjects:self.introduceBtn,self.baseInfoBtn, nil];
    }
    return _btnArray;
}


#pragma mark -
#pragma mark 自定义方法


-(void)btnChangeTabAction:(UIButton *)btn{
    
    //当改按钮没有选中时 点击该按钮响应一下操作
    if (!btn.isSelected) {
        
        //该按钮设为选中
        //其他按钮改为 非选中
        for (int i=0;i<[self.btnArray count];i++) {
            
            UIButton *obj = (UIButton *)[self.btnArray objectAtIndex:i];
            if (btn != obj) {
                
                obj.selected = NO;
            }
            else{
                
                obj.selected = YES;
                self.selectType = i;
            }
        }
        
        [self viewChangeWithType:self.selectType];
    }
}

// 切换
-(void)viewChangeWithType:(BtnSelectTypeCell)type{
    
    [UIView animateWithDuration:0.2 animations:^{
        self.btnClickedImg.frame = CGRectMake(type*kDeviceWidth/2, 63, kDeviceWidth/2, 2);
    }];
    
    if(self.delegate && [self.delegate respondsToSelector:@selector(viewChangeWithType:)])
    {
        [self.delegate viewChangeWithType:type];
        
    }
    
}



@end

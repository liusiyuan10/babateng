//
//  HeadView.m
//  Test04
//
//  Created by HuHongbing on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "QHeadView.h"
#import "Header.h"



@implementation QHeadView
@synthesize delegate = _delegate;
@synthesize section,open,backBtn;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        open = NO;

        
        UIView *headView = [self BgView];
        
        UITapGestureRecognizer *headViewtapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doSelected)];
        [headView addGestureRecognizer:headViewtapGesture];
        
        [self addSubview:headView];


    }
    return self;
}

-(UIView*)BgView{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,65)];
    bgView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 0, kDeviceWidth - 28, 0.5)];
    
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    _leftImage = [[UIButton alloc] initWithFrame:CGRectMake(14, 7, 50, 50)];
    [_leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
    [_leftImage setImage:[UIImage imageNamed:@"icon_xbf01_sel"] forState:UIControlStateSelected];
    _leftImage.selected = NO;
    [_leftImage addTarget:self action:@selector(leftBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    
    [bgView addSubview:_leftImage];
    
    
    _myImageView =  [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 11, 16,19, 14)];
    _myImageView.backgroundColor = [UIColor clearColor];
    _myImageView.contentMode = UIViewContentModeScaleAspectFill;
    _myImageView.hidden = YES;
    
    [bgView addSubview:_myImageView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(_leftImage.frame) - 11, 16)];
    _nameLabel.font = [UIFont systemFontOfSize:14];
    _nameLabel.backgroundColor = [UIColor clearColor];
    //        _labTip.textColor = [UIColor light_Black_Color];
    _nameLabel.textColor = [UIColor colorWithRed:32/255.0 green:16/255.0 blue:3/255.0 alpha:1.0];
    [bgView addSubview:_nameLabel];
    
    _timeView = [[UIImageView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 11, CGRectGetMaxY(_nameLabel.frame)+ 8, 15, 15)];
    _timeView.image = [UIImage imageNamed:@"demandtime"];
    
    [bgView addSubview:_timeView];
    
    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_timeView.frame) + 8, CGRectGetMaxY(_nameLabel.frame)+ 9, kDeviceWidth -40 - CGRectGetMaxX(_timeView.frame) - 8, 12)];
    _timeLabel.font = [UIFont systemFontOfSize:12];
    _timeLabel.backgroundColor = [UIColor clearColor];
    //        _labTip.textColor = [UIColor light_Black_Color];
    _timeLabel.textColor = [UIColor colorWithRed:117/255.0 green:116/255.0 blue:106/255.0 alpha:1.0];
    [bgView addSubview:_timeLabel];
    
    
    self.addBtn = [[UIButton alloc] initWithFrame:CGRectMake(kDeviceWidth - 40, 17, 32, 32)];
    
    //        [btn setBackgroundImage:[UIImage imageNamed:@"btn_back_normal"] forState:UIControlStateNormal];
    
    [self.addBtn setImage:[UIImage imageNamed:@"icon_tjdemand_nor"] forState:UIControlStateNormal];
    [self.addBtn setImage:[UIImage imageNamed:@"icon_tjdemand_sel"] forState:UIControlStateDisabled];
    
    [self.addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    [bgView addSubview:self.addBtn];
    
    
    return bgView;
}

- (void)addBtnClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(QHeadViewAddBtnClicked:)]){
        [_delegate QHeadViewAddBtnClicked:self];
    }
}

//if( self.resultRespone.isPlaying==YES){
//    
//    cell.myImageView.hidden = NO;
//    cell.myLabel.frame = CGRectMake(35, 0, kScreenWidth-20-40, 44.5);
//    cell.myImageView.frame = CGRectMake(10, 13,19, 14);
//    [self startAnimation:cell.myImageView];
//    
//}else{
//    
//    [cell.myImageView stopAnimating];
//    cell.myLabel.frame = CGRectMake(15, 0, kScreenWidth-20-25, 44.5);
//    cell.myImageView.hidden = YES;
//}

- (void)leftBtnClicked:(UIButton *)btn
{

    
//    NSLog(@"isPlay＝＝＝＝＝%d",self.isPlay);
    
//    btn.selected = !btn.selected;//新版改动为了没有设备按钮不点击
    
//    if (btn.selected) {
//          [_leftImage setImage:[UIImage imageNamed:@"icon_xbf01_sel"] forState:UIControlStateNormal];
//        
//
//        
//        _myImageView.hidden = NO;
//        _myImageView.frame = CGRectMake(CGRectGetMaxX(_leftImage.frame) + 11, 16,19, 14);
//        _nameLabel.frame =  CGRectMake(CGRectGetMaxX(_myImageView.frame) + 5, 16, kDeviceWidth -40 - CGRectGetMaxX(_leftImage.frame) - 11, 16);
//        _nameLabel.textColor = [UIColor colorWithRed:245/255.0 green:145/255.0 blue:1/255.0 alpha:1.0];
//        
//        [self startAnimation:_myImageView];
//    }
//    else
//    {
//        
//        [_leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
//        
//        [_myImageView stopAnimating];
//        _nameLabel.frame = CGRectMake(CGRectGetMaxX(_leftImage.frame) + 11, 16, kDeviceWidth -40 - CGRectGetMaxX(_leftImage.frame) - 11, 16);
//        _nameLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
//        _myImageView.hidden = YES;
//
//    }
//    
//    if (_delegate && [_delegate respondsToSelector:@selector(QHeadViewBtnClicked:)]){
//        [_delegate QHeadViewBtnClicked:self];
//    }
    
//        if (btn.selected) {
//              [_leftImage setImage:[UIImage imageNamed:@"icon_xbf01_sel"] forState:UIControlStateNormal];
//    
//        }
//        else
//        {
//    
//            [_leftImage setImage:[UIImage imageNamed:@"icon_xbf01_nor"] forState:UIControlStateNormal];
//    
//        }
    
        if (_delegate && [_delegate respondsToSelector:@selector(QHeadViewBtnClicked:leftBtn:)]){
            [_delegate QHeadViewBtnClicked:self leftBtn:btn];
        }

}


-(void)doSelected{
    //    [self setImage];
    if (_delegate && [_delegate respondsToSelector:@selector(selectedWith:)]){
     	[_delegate selectedWith:self];
    }
}
@end

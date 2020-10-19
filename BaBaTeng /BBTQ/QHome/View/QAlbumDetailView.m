//
//  QAlbumDetailView.m
//  BaBaTeng
//
//  Created by liu on 17/6/21.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

//#import "QAlbumDetailView.h"
//
//@implementation QAlbumDetailView
//
///*
//// Only override drawRect: if you perform custom drawing.
//// An empty implementation adversely affects performance during animation.
//- (void)drawRect:(CGRect)rect {
//    // Drawing code
//}
//*/
//
//@end


#import "QAlbumDetailView.h"
#import "AppDelegate.h"
#import "Header.h"


@interface QAlbumDetailView()
{
    UIView *_contentView;
}

@end

@implementation QAlbumDetailView

- (id)initWithFrame:(CGRect)frame
{
    if (self == [super initWithFrame:frame])
    {
        [self initContent];
    }
    
    return self;
}

- (void)initContent
{
    self.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
    
    
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.17];
    
    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    UIButton *collectBtn = [[UIButton alloc] initWithFrame:CGRectMake(41, 17, (kDeviceWidth - 3 * 41)/2, 44)];
    
    [collectBtn setTitle:@"收藏全部" forState:UIControlStateNormal];
    [collectBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:145/255.0 blue:1/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    collectBtn.layer.cornerRadius= 11.0f;
    
    collectBtn.layer.borderWidth = 1.2;
    collectBtn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:145/255.0 blue:1/255.0 alpha:1.0].CGColor;
    collectBtn.clipsToBounds = YES;//去除边界
    collectBtn.backgroundColor = [UIColor whiteColor];
    [collectBtn addTarget:self action:@selector(collectBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    UIButton *addBtn = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(collectBtn.frame) + 41, 17, (kDeviceWidth - 3 * 41)/2, 44)];
    
    [addBtn setTitle:@"添加全部" forState:UIControlStateNormal];
    
    [addBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:145/255.0 blue:1/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    addBtn.layer.cornerRadius= 11.0f;
    
    addBtn.layer.borderWidth = 1.2;
    addBtn.layer.borderColor = [UIColor colorWithRed:255/255.0 green:145/255.0 blue:1/255.0 alpha:1.0].CGColor;
    addBtn.clipsToBounds = YES;//去除边界
    addBtn.backgroundColor = [UIColor whiteColor];
    [addBtn addTarget:self action:@selector(addBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(addBtn.frame) + 16, kDeviceWidth, 1.0)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 200)/2.0, CGRectGetMaxY(lineView.frame) + 15, 200, 13)];
    [cancelBtn setTitle:@"关闭" forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13.0];
    [cancelBtn setTitleColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    //    [headView addSubview:cancelBtn];
    
     //适配iphone x
    if (_contentView == nil)
    {
         _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KDeviceHeight - 119-kDevice_Is_iPhoneX, kDeviceWidth,119+kDevice_Is_iPhoneX)];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        _contentView.layer.masksToBounds = YES; //没这句话它圆不起来
        _contentView.layer.cornerRadius = 11; //设置图片圆角的尺度
        [self addSubview:_contentView];
        [_contentView addSubview:addBtn];
        [_contentView addSubview:collectBtn];
        [_contentView addSubview:cancelBtn];
        

        [_contentView addSubview:lineView];
    }
    
}



- (void)loadMaskView
{
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    
//    if (!view)
//    {
//        return;
//    }
//    
//    [view addSubview:self];
//    [view addSubview:_contentView];
//    
//    [_contentView setFrame:CGRectMake(0, KDeviceHeight, kDeviceWidth, KDeviceHeight / 2.0)];
//    
//    [UIView animateWithDuration:0.3 animations:^{
//        
//        self.alpha = 1.0;
//        
//        [_contentView setFrame:CGRectMake(0,KDeviceHeight - 64 - 119, kDeviceWidth, 119)];
//        
//    } completion:nil];
    
    
    UIWindow *window = [UIApplication sharedApplication].windows[1];
    [window addSubview:self];
    
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView
{
    [_contentView setFrame:CGRectMake(0, KDeviceHeight - 119.0, kDeviceWidth, 119.0)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, KDeviceHeight, kDeviceWidth, KDeviceHeight / 2.0)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
//    tfSheetView.albumPlaystr = @"albumPlaystr";
    if (![self.albumPlaystr isEqualToString:@"albumPlaystr"]) {
            [[AppDelegate appDelegate]suspendButtonHidden:NO];
    }

    
    
}

- (void)addBtnClicked
{
    
    if ([self.delegate respondsToSelector:@selector(QDeviceVolumeViewAddBtnClicked:)]) {
        
        [self.delegate QDeviceVolumeViewAddBtnClicked:self];
    }
    
    [self disMissView];
    
}

- (void)collectBtnClicked
{
//    if ([self.delegate respondsToSelector:@selector(QDeviceVolumeViewAddBtnClicked:)]) {
//        
//        [self.delegate QDeviceVolumeViewAddBtnClicked:self];
//    }
    
    if ([self.delegate respondsToSelector:@selector(QDeviceVolumeViewAddFavoriteBtnClicked:)]) {
        
        [self.delegate QDeviceVolumeViewAddFavoriteBtnClicked:self];
    }
    
    [self disMissView];
}

- (void)cancelBtnClicked
{

    if ([self.delegate respondsToSelector:@selector(QDeviceVolumeViewBtnClicked:selectName:)]) {
        
        [self.delegate QDeviceVolumeViewBtnClicked:self selectName:@""];
    }
    
    [self disMissView];
}


@end

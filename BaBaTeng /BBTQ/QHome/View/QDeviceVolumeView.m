//
//  QDeviceVolumeView.m
//  BaBaTeng
//
//  Created by liu on 17/5/22.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "QDeviceVolumeView.h"
#import "AppDelegate.h"
#import "Header.h"
#import "TMCache.h"

@interface QDeviceVolumeView()<UIGestureRecognizerDelegate>
{
    UIView *_contentView;
}

@property(nonatomic, strong) UISlider *volumeSlider;
@property(nonatomic, strong) UILabel *valueLabel;
@property(nonatomic, strong) NSString *valueStr;

@end

@implementation QDeviceVolumeView

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
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 50)];
//    headView.backgroundColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(60, 20/667.0 * KDeviceHeight, kDeviceWidth - 120, 20/667.0 * KDeviceHeight)];
    
    titleLabel.text = @"音量调整";
    titleLabel.font = [UIFont systemFontOfSize:16.0];
    titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    
    [headView addSubview:titleLabel];
    

    self.valueLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 100) / 2, titleLabel.frame.origin.y + 57/667.0 * KDeviceHeight, 100, 12)];
    self.valueLabel.font = [UIFont systemFontOfSize:14.0];
    self.valueLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    self.valueLabel.textAlignment = NSTextAlignmentCenter;

    
    self.volumeSlider = [[UISlider alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(self.valueLabel.frame) + 15/667.0 * KDeviceHeight, kDeviceWidth - 100, 12/667.0 * KDeviceHeight)];
    
    self.volumeSlider.minimumValue = 40;// 设置最小值
    self.volumeSlider.maximumValue = 100;// 设置最大值
    
    NSString *devicevolumestr = [[TMCache sharedCache] objectForKey:@"DeviceVolume"];
    
    if (devicevolumestr.length != 0) {
        self.volumeSlider.value = [devicevolumestr floatValue];
        self.valueStr = devicevolumestr;
    }else
    {
        self.volumeSlider.value = 40;
    }
   
 
    
    UIImage *trackLeftImage = [[UIImage imageNamed:@"lt_yl_sel"]stretchableImageWithLeftCapWidth:14 topCapHeight:0];
    
    [self.volumeSlider setMinimumTrackImage:trackLeftImage forState:UIControlStateNormal];
    
    [self.volumeSlider setMaximumTrackImage:[UIImage imageNamed:@"lt_yl_nor"] forState:UIControlStateNormal];
    
    self.volumeSlider.continuous = YES;// 设置可连续变化
    

    
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"kg"] forState:UIControlStateNormal];
    [self.volumeSlider setThumbImage:[UIImage imageNamed:@"kg"] forState:UIControlStateHighlighted];

    
//    self.volumeSlider.continuous = YES;// 设置可连续变化
    
    [self.volumeSlider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];// 针对值变化添加响应方法
    
    // 单击手势
   UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(actionTapGesture:)];
    tapGesture.delegate = self;
    [self.volumeSlider addGestureRecognizer:tapGesture];
//    [self.view addSubview:self.timeSlider];
    
//    NSString *str2 = [NSString stringWithFormat:@"%.2f%%",[str1 floatValue]*100];
    
    self.valueLabel.text = [NSString stringWithFormat:@"%.f%%", self.volumeSlider.value /100 * 100 ];

    

    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.volumeSlider.frame) + 87/667.0 * KDeviceHeight, kDeviceWidth, 1.0)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake((kDeviceWidth - 200)/2.0, CGRectGetMaxY(lineView.frame) + 10/667.0 * KDeviceHeight, 200, 40/667.0 * KDeviceHeight)];
    [cancelBtn setTitle:@"完成" forState:UIControlStateNormal];
//    cancelBtn.titleLabel.font = [UIFont systemFontOfSize:15.0];
    [cancelBtn setTitleColor:[UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0] forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
//    [headView addSubview:cancelBtn];
    
    //适配iphone x
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KDeviceHeight - 259.0/667.0 * KDeviceHeight-kDevice_Is_iPhoneX, kDeviceWidth, 259.0/667.0 * KDeviceHeight+kDevice_Is_iPhoneX)];
        _contentView.backgroundColor = [UIColor whiteColor];
        
        _contentView.layer.masksToBounds = YES; //没这句话它圆不起来
        _contentView.layer.cornerRadius = 11; //设置图片圆角的尺度
        [self addSubview:_contentView];
        [_contentView addSubview:self.volumeSlider];
        [_contentView addSubview:self.valueLabel];
        [_contentView addSubview:cancelBtn];
        
        [_contentView addSubview:headView];
        [_contentView addSubview:lineView];
    }
    
}

- (void)actionTapGesture:(UITapGestureRecognizer *)sender {
//    CGPoint touchPoint = [sender locationInView:self.volumeSlider];
//    CGFloat value = (self.volumeSlider.maximumValue - self.volumeSlider.minimumValue) * (touchPoint.x / self.volumeSlider.frame.size.width );
//    [self.volumeSlider setValue:value animated:YES];
//
//    if (value < 40) {
//        return;
//
//    }
//
//    self.valueLabel.text = [NSString stringWithFormat:@"%.f%%", value];
//
//    self.valueStr = [NSString stringWithFormat:@"%.f%%", value];
    
    
}



// slider变动时改变label值
- (void)sliderValueChanged:(id)sender {
    UISlider *slider = (UISlider *)sender;
    
//    NSString *str2 = [NSString stringWithFormat:@"%.2f%%",[str1 floatValue]*100];
    self.valueLabel.text = [NSString stringWithFormat:@"%.f%%", slider.value];
//    NSLog(@"音量大小%@",[NSString stringWithFormat:@"%.1f", slider.value]);
    
    self.valueStr = [NSString stringWithFormat:@"%.f%%", slider.value];
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
//        [_contentView setFrame:CGRectMake(0, KDeviceHeight / 2.0, kDeviceWidth, KDeviceHeight / 2.0)];
//        
//    } completion:nil];
    
    UIWindow *window = [UIApplication sharedApplication].windows[1];
    [window addSubview:self];
    [window addSubview:_contentView];
    
    
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView
{
    [_contentView setFrame:CGRectMake(0,KDeviceHeight - 259.0/667.0 * KDeviceHeight, kDeviceWidth, 259.0/667.0 * KDeviceHeight)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, KDeviceHeight, kDeviceWidth, KDeviceHeight / 2.0)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
//    [[AppDelegate appDelegate]suspendButtonHidden:NO];

    
}

- (void)cancelBtnClicked
{
//    if ([self.delegate respondsToSelector:@selector(QDeviceViewBtnClicked:selectName:)]) {
//        
//        
//        //        [self.delegate Q3PlayListViewAddBtnClicked:self sectionIndex:listresponse.id ListTitle:listresponse.name];
//        
//        [self.delegate QDeviceViewBtnClicked:self selectName:name];
//        
//    }
    
    if ([self.delegate respondsToSelector:@selector(QDeviceVolumeViewBtnClicked:selectName:)]) {
        
        [self.delegate QDeviceVolumeViewBtnClicked:self selectName:self.valueStr];
    }
    
    [self disMissView];
}


@end

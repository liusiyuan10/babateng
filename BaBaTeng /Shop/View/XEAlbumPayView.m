
#import "XEAlbumPayView.h"
#import "Header.h"



@interface XEAlbumPayView()
{
    UIView *_contentView;
}


@property(nonatomic, strong) UILabel *priceLabel;

@end

@implementation XEAlbumPayView

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
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
    
    self.userInteractionEnabled = YES;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(disMissView)]];
    
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kDeviceWidth, 46)];
    headView.backgroundColor = [UIColor whiteColor];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((kDeviceWidth - 120)/2.0, 12, 120, 25)];
    
    titleLabel.text = @"支付方式";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor colorWithRed:80/255.0 green:80/255.0 blue:80/255.0 alpha:1.0];
    titleLabel.font = [UIFont systemFontOfSize:18.0];
    
    [headView addSubview:titleLabel];
    
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(17,17, 14, 14)];
    
    [cancelBtn setImage:[UIImage imageNamed:@"icon_Close_zf"] forState:UIControlStateNormal];
    

    
    [cancelBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:cancelBtn];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, kDeviceWidth, 1.0)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [headView addSubview:lineView];
    

    
    self.priceLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(headView.frame) + 23, kDeviceWidth , 24)];
    

    self.priceLabel.textColor = MNavBackgroundColor;
    self.priceLabel.font = [UIFont boldSystemFontOfSize:32.0];
    self.priceLabel.textAlignment = NSTextAlignmentCenter;
//    self.priceLabel.numberOfLines = 0;
    
    self.priceLabel.text = self.priceStr;
    
    UIButton *determineBtn = [[UIButton alloc] initWithFrame:CGRectMake(0,245, kDeviceWidth, 49)];
    
    determineBtn.backgroundColor = NavBackgroundColor;
    [determineBtn setTitle:@"确认支付" forState:UIControlStateNormal];
    [determineBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [determineBtn addTarget:self action:@selector(determineBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    //适配iphone x
    if (_contentView == nil)
    {
        _contentView = [[UIView alloc]initWithFrame:CGRectMake(0, KDeviceHeight - 294-kDevice_Is_iPhoneX, kDeviceWidth,294 +kDevice_Is_iPhoneX )];
        _contentView.backgroundColor = [UIColor whiteColor];
        //        _contentView.layer.masksToBounds = YES; //没这句话它圆不起来
        //        _contentView.layer.cornerRadius = 11; //设置图片圆角的尺度
        
        [self addSubview:_contentView];
        [_contentView addSubview:self.priceLabel];
        [_contentView addSubview:headView];
        //        [_contentView addSubview:cancelBtn];
        [_contentView addSubview:determineBtn];
     
    }
    

    
    
    
    
}

-(void)determineBtnClicked:(UIButton *)btn
{
    
    if ([self.delegate respondsToSelector:@selector(XEAlbumPayViewBtnClicked:)]) {

        [self.delegate XEAlbumPayViewBtnClicked:self];
    }
    [self disMissView];
}

- (void)loadMaskView
{
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    
    self.priceLabel.text = self.priceStr;
    
    UIWindow *window = [UIApplication sharedApplication].windows[1];
    [window addSubview:self];
    [window addSubview:_contentView];
    
    
    
}

//移除从上向底部弹下去的UIView（包含遮罩）
- (void)disMissView
{
    [_contentView setFrame:CGRectMake(0, KDeviceHeight - 294 -kDevice_Is_iPhoneX, kDeviceWidth,294+kDevice_Is_iPhoneX)];
    [UIView animateWithDuration:0.3f
                     animations:^{
                         
                         self.alpha = 0.0;
                         
                         [_contentView setFrame:CGRectMake(0, KDeviceHeight, kDeviceWidth, 294+kDevice_Is_iPhoneX)];
                     }
                     completion:^(BOOL finished){
                         
                         [self removeFromSuperview];
                         [_contentView removeFromSuperview];
                         
                     }];
    
    //    [[AppDelegate appDelegate]suspendButtonHidden:NO];
    
}




@end



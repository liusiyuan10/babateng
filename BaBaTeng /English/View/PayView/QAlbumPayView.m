
#import "QAlbumPayView.h"
#import "Header.h"
#import "QAlbumPayCell.h"




@interface QAlbumPayView()<UITableViewDelegate,UITableViewDataSource>
{
    UIView *_contentView;
}

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *titleArray;

@property(strong,nonatomic)  NSMutableArray *trackArticles; //推荐列表

@property(nonatomic,strong) NSString *payName;

@property(nonatomic,assign) NSInteger selectIndex;
@end

@implementation QAlbumPayView

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
    
    //    cancelBtn.backgroundColor = [UIColor redColor];
    //    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    //    [cancelBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    
    [cancelBtn addTarget:self action:@selector(disMissView) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:cancelBtn];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, kDeviceWidth, 1.0)];
    lineView.backgroundColor = [UIColor colorWithRed:224/255.0 green:223/255.0 blue:211/255.0 alpha:1.0];
    
    [headView addSubview:lineView];
    
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,CGRectGetMaxY(headView.frame),kDeviceWidth , 66*2) style:UITableViewStylePlain];
    //    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor=DefaultBackgroundColor;
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
    
    //    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(self.tableView.frame) + 20, kDeviceWidth - 40, 34)];
    
    UILabel *payLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame) + 20, kDeviceWidth , 17)];
    
    //    payLabel.text = @"注:你将购买《专辑名称》,购买后不支持退订,转让，请再次确认";
    payLabel.textColor = [UIColor colorWithRed:118/255.0 green:117/255.0 blue:107/255.0 alpha:1.0];
    payLabel.font = [UIFont systemFontOfSize:11.0];
    payLabel.textAlignment = NSTextAlignmentCenter;
    payLabel.numberOfLines = 0;
    
    //    cancelBtn.hidden = YES;
    //    [headView addSubview:cancelBtn];
    
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
        [_contentView addSubview:self.tableView];
        [_contentView addSubview:headView];
        //        [_contentView addSubview:cancelBtn];
        [_contentView addSubview:determineBtn];
        [_contentView addSubview:payLabel];
    }
    
    self.trackArticles = [[NSMutableArray alloc] init];
    
    self.selectIndex = 0;
    
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    
    
    
    
}

-(void)determineBtnClicked:(UIButton *)btn
{
    
    if ([self.delegate respondsToSelector:@selector(QAlbumPayViewBtnClicked:selectName:selectIndex:)]) {
        
        [self.delegate QAlbumPayViewBtnClicked:self selectName:self.payName selectIndex:self.selectIndex ];
    }
    [self disMissView];
}

- (void)loadMaskView
{
}

//展示从底部向上弹出的UIView（包含遮罩）
- (void)showInView:(UIView *)view
{
    
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

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    //    return self.titleArray.count;
    //
    
    return 2;
    
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *CellIdentifier = @"QAlbumPaycellID";
    QAlbumPayCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell = [[QAlbumPayCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        //        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        //通过RGB来定义自己的颜色
        //        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        //        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:255/255.0 green:210/255.0 blue:171/255.0 alpha:1.0];
        
    }
    

    
    if (indexPath.row == 0) {

        cell.iconImageView.image = [UIImage imageNamed:@"zhifubao"];
        cell.nameLabel.text = @"支付宝支付";


    }
    else
    {
        cell.iconImageView.image = [UIImage imageNamed:@"weixin"];
        cell.nameLabel.text = @"微信支付";

    }


    
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    

    
    self.selectIndex = indexPath.row;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 66.0;
}



@end



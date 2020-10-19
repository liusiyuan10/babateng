//
//  BBTMessageDetailsViewController.m
//  BaBaTeng
//
//  Created by MrfengJW on 17/5/28.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "BBTMessageDetailsViewController.h"
#import "MJExtension.h"
#import "BBTMineRequestTool.h"
#import "QMessage.h"
#import "QMessageDataList.h"
#import "QMessageData.h"
@interface BBTMessageDetailsViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,retain) UITableView *tableView;
@property (nonatomic,retain)  UIView *container;
@property (nonatomic, strong) UILabel *userName;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) UILabel *addtime;
@end

@implementation BBTMessageDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     [self setTitle:@"消息详情"];
    
    //self.content = @"小腾机器人外观相当具有亲和力，让孩子第一眼就爱上，它会聊天，会思考，会闹情绪，而且萌值极高。在设计小腾的初期，对儿童手掌大小进行了调研，小腾的尺寸完美贴合宝宝的手掌，能让孩子很轻松抱住，而且具有非常优质的手感和“抱感”，从小锻炼宝宝的抓握。而且小腾体态圆润，整体无棱角，大大降低了孩子的安全隐患。 Joybe作为巴巴腾旗下第一款教育机器人，结合了AI以及AR技术，赋予机器人以新的生命力，另外，巴巴腾还牵手哆哆天才乐园等知名教育资源平台深度整合资源，实施分龄分段的学习、识字、识图、数学等全方位综合性早教课程，并将课程融入游戏，实现了玩中学，学中玩。";
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,self.view.frame.size.height) style:UITableViewStylePlain];
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.scrollEnabled = YES;
    [self.view addSubview:self.tableView];
    [self autoRefresh];
    
    //适配iphone x
    if (iPhoneX) {
        do {\
            _Pragma("clang diagnostic push")\
            _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"")\
            if ([self.tableView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
                NSMethodSignature *signature = [UIScrollView instanceMethodSignatureForSelector:@selector(setContentInsetAdjustmentBehavior:)];\
                NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:signature];\
                NSInteger argument = 2;\
                invocation.target = self.tableView;\
                invocation.selector = @selector(setContentInsetAdjustmentBehavior:);\
                [invocation setArgument:&argument atIndex:2];\
                [invocation retainArguments];\
                [invocation invoke];\
            }\
            _Pragma("clang diagnostic pop")\
        } while (0);
    }

    // Do any additional setup after loading the view.
}
-(void)GETsystemNoticesID
{
    
    
    [BBTMineRequestTool GETsystemNoticeId:self.systemNoticeId upload:^(QMessage *respone) {
          [self.tableView.mj_header endRefreshing];
        if ([respone.statusCode isEqualToString:@"0"]) {
            
            
            self.content  = respone.data.content;
            
          
            self.userName.text =respone.data.title;
            self.addtime.text =  [NSString stringWithFormat:@"发送时间:%@",[self timeWithTimeIntervalString:respone.data.publishTime]];
            self.tableView.tableHeaderView = self.container;
            
            [self.tableView reloadData];
            
        }else{
            
            [self showToastWithString:respone.message];
        }

        
    } failure:^(NSError *error) {
          [self.tableView.mj_header endRefreshing];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置"];
        
    }];
    
    //#pragma mark -- 分页获取系统消息列表
    //    + (void)GETsystemNoticesbodyDic:(NSDictionary *)bodydic upload:(void(^)(BBTUserInfoRespone *registerRespone))success failure:(void(^)(NSError *error))failure;
    
}


- (NSString *)timeWithTimeIntervalString:(NSString *)timeString
{
    // 格式化时间
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    
    // 毫秒值转化为秒
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[timeString doubleValue]/ 1000.0];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}




#pragma mark UITableView + 下拉刷新 默认
- (void)autoRefresh
{
    __unsafe_unretained __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf loadNewData];
    }];
    
    // 马上进入刷新状态
    [self.tableView.mj_header beginRefreshing];
    
    
}

-(void)loadNewData{
    
  //  [self connectionData];
    
     [self GETsystemNoticesID];
    
}

#pragma mark - UITableView Delegate methods

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return 1;
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"detailsCell";
    
    UITableViewCell *cell =(UITableViewCell*) [self.tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == nil){
        //设置cell 样式
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
    
   // NSLog(@"self.msgsRespone.content==%@", self.msgsRespone.content);
    
    cell.textLabel.text = self.content;
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.numberOfLines = 0;
    [cell.textLabel setTextColor:[UIColor grayColor]];
    return cell;
    
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString *inforStr =self.content;
    //self.msgsRespone.content;
    UIFont *font = [UIFont systemFontOfSize:13];
    CGSize size = CGSizeMake(300,2000);
    CGSize labelsize = [inforStr sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByCharWrapping];
    return labelsize.height+50;
}

-(void)connectionData{
    
    
        [self.tableView.mj_header endRefreshing];
    
        self.tableView.tableHeaderView = self.container;
        
        [self.tableView reloadData];
        
        
    

}


-(UIView*)container{
    
    if (_container == nil) {
        
        _container = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 60)];
        _container.backgroundColor = [UIColor whiteColor];
        
    }
    
    //名称
    
    self.userName.frame  = CGRectMake(10,5,kDeviceWidth -20, 30);
    self.userName .font = [UIFont systemFontOfSize:18.0];
    [self.userName setTextAlignment:NSTextAlignmentCenter];
    [self.userName setTextColor:MainFontColor];
    // NSLog(@"self.msgsRespone.title==%@",self.msgsRespone.title);
    //self.userName.text = @"巴巴腾新品上市了";//self.msgsRespone.title;
    self.userName.backgroundColor = [UIColor clearColor];
    self.userName.userInteractionEnabled = YES;
    
    
    self.addtime.frame  = CGRectMake(10,35,kDeviceWidth -20, 20);
    self.addtime .font = [UIFont systemFontOfSize:14.0];
    [self.addtime setTextAlignment:NSTextAlignmentLeft];
    [self.addtime setTextColor:[UIColor grayColor]];
    //self.addtime.text =  [NSString stringWithFormat:@"发送时间:2017年12月25日"];
    // NSLog(@"self.msgsRespone.addtime==%@",self.msgsRespone.addtime);
    self.addtime.backgroundColor = [UIColor clearColor];
    self.addtime.userInteractionEnabled = YES;
    
    
    [_container  addSubview:self.userName];
    
    [_container  addSubview:self.addtime];
    
    return _container;
    
}


-(UILabel *)userName{
    
    if (!_userName) {
        _userName = [[UILabel alloc]init];
    }
    
    return _userName;
}


-(UILabel *)addtime{
    
    if (!_addtime) {
        _addtime = [[UILabel alloc]init];
    }
    
    return _addtime;
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

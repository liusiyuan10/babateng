//
//  QClockBellViewController.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/6/28.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "QClockBellViewController.h"

#import "QClockBellCell.h"

#import "QClockRequestTool.h"

#import "QClockBell.h"
#import "QClockBellData.h"

#import "MusicPlayerView.h"

#import "VedioModel.h"

@interface QClockBellViewController ()<UITableViewDelegate,UITableViewDataSource,MusicPlayerViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

//列表Arr
@property(strong,nonatomic)NSArray *titlearray;

@property (nonatomic, assign) NSInteger btnTag;//默认选中的Tag

@property(nonatomic, copy) NSString *clockBellStr;

@property(nonatomic, copy) NSString *clockBellId;

@property(nonatomic,strong) MusicPlayerView *playerView;

@end

@implementation QClockBellViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.title = @"铃声";
    self.btnTag = -1;
//    self.titlearray = @[@"铃声1",@"铃声2",@"铃声3",@"铃声4",@"铃声5"];
    self.titlearray = [NSArray array];
    
    self.clockBellStr = @"";
    self.clockBellId = @"";
    
    [self LoadChlidView];
    
    [self GetClockSound];
    
    IsPlaying = NO;
    self.playerView =[[MusicPlayerView alloc]init];
    self.playerView.musicPlayerDelegate = self;
    
}


- (void)LoadChlidView
{
    [self setUpNavigationItem];
    
    self.tableView=[[UITableView alloc] initWithFrame:CGRectMake(0,0,kDeviceWidth , KDeviceHeight)style:UITableViewStylePlain];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    self.tableView.backgroundColor= [UIColor clearColor];
    self.tableView.delegate=self;
    self.tableView.dataSource=self;
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.tableView setShowsVerticalScrollIndicator:NO];
    
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
    
    [self.view addSubview:self.tableView];
    
    
}

- (void)GetClockSound
{
    
    [self startLoading];
    
    [QClockRequestTool getclockSoundsParameter:nil success:^(QClockBell *response) {
        
        
        [self stopLoading];
        if ([response.statusCode isEqualToString:@"0"]) {
            
            self.titlearray = response.data;
            
            [self.tableView reloadData];

        }
        else{
            
            [self showToastWithString:response.message];
        }
        
        
    } failure:^(NSError *error) {
        
        [self stopLoading];
        [self showToastWithString:@"网络连接失败，请检查您的网络设置!"];
        
    }];
}
- (void)setUpNavigationItem
{
    
    UIButton *rightbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 18)];
    
    [rightbutton setTitle:@"确定" forState:UIControlStateNormal];
    [rightbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightbutton addTarget:self action:@selector(storageBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    rightbutton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:rightbutton];
}


- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.titlearray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 64;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellID = @"QClockBellcellID";
    QClockBellCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[QClockBellCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];

        
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }

    QClockBellData *belldata = [self.titlearray objectAtIndex:indexPath.row];
    cell.titleLabel.text = belldata.soundName;
    
    cell.selectBtn.tag = indexPath.row;
    if (cell.selectBtn.tag == self.btnTag) {
        cell.isSelect = YES;
        cell.selectBtn.selected = YES;
     
    }else{
        cell.isSelect = NO;
        cell.selectBtn.selected = NO;
    }
    __weak QClockBellCell *weakCell = cell;
    
    [cell setQhxSelectBlock:^(BOOL choice,NSInteger btnTag){
        if (choice) {
            weakCell.selectBtn.selected = YES;
            self.btnTag = btnTag;
            NSLog(@"$$$$$$%ld",(long)btnTag);
//            NSLog(@"选中的铃声为=====================%@",self.titlearray[indexPath.row]);
//            self.clockBellStr = self.titlearray[indexPath.row];
            
            QClockBellData *belldata = [self.titlearray objectAtIndex:btnTag];
            
            self.clockBellStr =belldata.soundName;
            self.clockBellId =belldata.soundId;
            
            if (IsPlaying) {
                
                VedioModel *model = [[VedioModel alloc]init];
                model.musicURL = belldata.soundUrl;

                [self.playerView changeMusic:model];
                IsPlaying = YES;
                
                
            }else{
                
                
                VedioModel *model = [[VedioModel alloc]init];
                model.musicURL =belldata.soundUrl;

                [self.playerView setUp:model];
                IsPlaying = YES;
                
            }
            
            
            [self.tableView reloadData];
        }
        else{
            //选中一个之后，再次点击，是未选中状态，图片仍然设置为选中的图片，记录下tag，刷新tableView，这个else 也可以注释不用，tag只记录选中的就可以
             weakCell.selectBtn.selected = YES;
            self.btnTag = btnTag;
            [self.tableView reloadData];
            NSLog(@"#####%ld",(long)btnTag);
        }
    }];
    

    return  cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"选择了%ld行",(long)indexPath.row);
}




- (void)storageBtnClicked
{
    if (self.clockBellStr.length == 0) {
        
        [self showToastWithString:@"请选择铃声"];
        return;
        
    }
    
    
    NSDictionary *jsonDict = @{@"ClockBell" : self.clockBellStr , @"ClockBellID" : self.clockBellId};

        
    [[NSNotificationCenter defaultCenter] postNotificationName:@"QClockBellRefresh" object:self userInfo:jsonDict];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark MusicPlayerViewDelegate
//播放失败的代理方法
-(void)playerViewFailed{
    IsPlaying =NO;
    NSLog(@"播放失败111");
}
//缓存中的代理方法
-(void)playerViewBuffering{
    
    NSLog(@"缓存中");
}
//播放完毕的代理方法
-(void)playerViewFinished{
    
    NSLog(@"播放完成");
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    if (IsPlaying) {
        [self.playerView removeObserver];//注销观察者
    }
    
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

//
//  StudentStyleViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/9/7.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import "StudentStyleViewController.h"
#import "YGPlayerView.h"
#import "YGVideoTool.h"
#import "YGPlayInfo.h"
#import "UIDevice+TFDevice.h"
#import "AppDelegate.h"


@interface StudentStyleViewController ()<YGPlayerViewDelegate>

@property (nonatomic, strong) YGPlayerView *playerView;

@end

@implementation StudentStyleViewController



- (NSMutableArray *)playInfos
{
    if (_playInfos == nil) {
        _playInfos = [[NSMutableArray alloc] init];
    }
    
    return _playInfos;
    
}
//此状态一定要是 NO  不然无法对旋转后的尺寸进行适配
-(BOOL)shouldAutorotate{
    
    return NO;
}
//支持的状态
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    // 如果该界面需要支持横竖屏切换
    return UIInterfaceOrientationMaskLandscapeRight | UIInterfaceOrientationMaskPortrait;
    
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
     YGPlayInfo *playInfo = [self.playInfos objectAtIndex:self.playIndex];
    
    self.title = playInfo.title;
    
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    //允许转成横屏
    appDelegate.allowRotation = YES;
    //调用转屏代码
    [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    
    
    NSLog(@"------sss-----%@", self.playInfos);
    
    NSLog(@"------gggggg-----%ld", (long)self.playIndex);
    
    [self setupPlayerView];
    
    
}




- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning-------");
}

// 初始化播放器View
- (void)setupPlayerView
{
    YGPlayerView *playerView = [[[NSBundle mainBundle] loadNibNamed:@"YGPlayerView" owner:nil options:nil] lastObject];

    playerView.delegate = self;
    playerView.playInfos = self.playInfos;

    [self.view addSubview:playerView];

    self.playerView = playerView;


    YGPlayInfo *playInfo = [self.playInfos objectAtIndex:self.playIndex];

    [playerView playWithPlayInfo:playInfo];


}

- (void)YGPlayerViewBtnClicked:(YGPlayerView *)view
{

    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];

    [self.navigationController popViewControllerAnimated:YES];



}

- (void)backForePage
{
    AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
    //切换到竖屏
    [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];

    [self.playerView YGbackForePage];

    [self.navigationController popViewControllerAnimated:YES];
}

- (void)YGPlayerViewrotateBtnClicked:(YGPlayerView *)view RType:(NSString *)type
{
    if ([type isEqualToString:@"0"]) {

         NSLog(@"转至竖屏111111111111111");

        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        appDelegate.allowRotation = NO;//关闭横屏仅允许竖屏
        //切换到竖屏
        [UIDevice switchNewOrientation:UIInterfaceOrientationPortrait];

    }
    else
    {
        NSLog(@"转至heng屏5565656565651");
        AppDelegate * appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //允许转成横屏
        appDelegate.allowRotation = YES;
        //调用转屏代码
        [UIDevice switchNewOrientation:UIInterfaceOrientationLandscapeRight];
    }
}


- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    [[self rdv_tabBarController] setTabBarHidden:YES animated:YES];
    
    [[AppDelegate appDelegate]suspendButtonHidden:YES];
    
    self.navigationController.navigationBar.hidden = YES;
    
    
    
}

- (void)viewWillDisappear:(BOOL)animated;
{
    [super viewWillDisappear:animated];
    NSLog(@"ddddddddssssss");
    
    self.navigationController.navigationBar.hidden = NO;
}



@end

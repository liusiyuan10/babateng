//
//  BBTAgreementViewController.m
//  BaBaTeng
//
//  Created by liu on 16/10/14.
//  Copyright © 2016年 ShenzhenHiTech. All rights reserved.
//

#import "BBTAgreementViewController.h"
#import "Header.h"

@interface BBTAgreementViewController ()<UIWebViewDelegate>

@property(nonatomic,strong) UIWebView *webView;

@end

@implementation BBTAgreementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"用户协议";
    
    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1.0];
    
    
    
//    self.view.backgroundColor = [UIColor colorWithRed:240/255.0 green:240/255.0 blue:242/255.0 alpha:1.0];
//    UIView *navView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 64)];
//    navView.backgroundColor = [UIColor orangeColor];
//    [self.view addSubview:navView];
    
    CGRect webViewRect=CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
    self.webView=[[UIWebView alloc]initWithFrame:webViewRect];
    self.webView.contentMode = UIViewContentModeScaleToFill;
    self.webView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.webView.scalesPageToFit = YES;
    [self.webView setUserInteractionEnabled:YES];
    self.webView.delegate = self;
    [self.view  addSubview:self.webView];
    
    
    [self loadMyView];
    
    
}

-(void) loadMyView{
    dispatch_async(dispatch_get_main_queue(), ^{
        
        
        // 打开本地网页
        //
        NSURL *fileURL = [[NSBundle mainBundle] URLForResource:@"qus/协议.html" withExtension:nil];
        NSURLRequest *request = [NSURLRequest requestWithURL:fileURL];
        [self.webView loadRequest:request];
        
        
        
    });
}


- (void) viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}


-(void)viewWillDisappear:(BOOL)animated{
    
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = YES;
    
}



@end

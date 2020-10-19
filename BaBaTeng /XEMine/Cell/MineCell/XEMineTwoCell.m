//
//  XEMineTwoCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/5/6.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "XEMineTwoCell.h"
#import "Header.h"


@implementation XEMineTwoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView*cellView = [self contentViewCell];
        [self.contentView addSubview:cellView];
        
    }
    return self;
}

-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,180 + 16)];
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,0, kDeviceWidth - 32,180)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    [bgView addSubview:backView];
    
    CGFloat ViewW = (kDeviceWidth - 32 - 2)/4.0;
    
    UIView *AssetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewW, 90)];
    AssetView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:AssetView];
    
    _AssetBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _AssetBtn.backgroundColor = [UIColor clearColor];
    [_AssetBtn setBackgroundImage:[UIImage imageNamed:@"BBT_Mineincome"] forState:UIControlStateNormal];
    
    
    [AssetView addSubview:_AssetBtn];
    
    
    UILabel *AssetLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_AssetBtn.frame) + 10, ViewW, 12)];
    AssetLabel.font = [UIFont systemFontOfSize:12.0];
    AssetLabel.backgroundColor = [UIColor clearColor];
    AssetLabel.text = @"收益";
    AssetLabel.textAlignment = NSTextAlignmentCenter;
    AssetLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [AssetView addSubview:AssetLabel];
    
    UIView *MemberView = [[UIView alloc] initWithFrame:CGRectMake( (ViewW) , 0, ViewW, 90)];
    MemberView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:MemberView];
    
    _memberBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _memberBtn.backgroundColor = [UIColor clearColor];
    [_memberBtn setBackgroundImage:[UIImage imageNamed:@"BBT_Minevip"] forState:UIControlStateNormal];
    
    
    [MemberView addSubview:_memberBtn];
    
    
    UILabel *memberLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_memberBtn.frame) + 10, ViewW, 12)];
    memberLabel.font = [UIFont systemFontOfSize:12.0];
    memberLabel.backgroundColor = [UIColor clearColor];
    memberLabel.text = @"会员中心";
    memberLabel.textAlignment = NSTextAlignmentCenter;
    memberLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [MemberView addSubview:memberLabel];
    
    UIView *FriendView = [[UIView alloc] initWithFrame:CGRectMake(ViewW * 2, 0, ViewW, 90)];
    FriendView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:FriendView];
    
    _FriendBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _FriendBtn.backgroundColor = [UIColor clearColor];
    [_FriendBtn setBackgroundImage:[UIImage imageNamed:@"BBT_Minefriend"] forState:UIControlStateNormal];
    
    
    [FriendView addSubview:_FriendBtn];
    
    UILabel *FriendLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_FriendBtn.frame) + 10, ViewW, 12)];
    FriendLabel.font = [UIFont systemFontOfSize:12.0];
    FriendLabel.backgroundColor = [UIColor clearColor];
    FriendLabel.text = @"邀请好友";
    FriendLabel.textAlignment = NSTextAlignmentCenter;
    FriendLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [FriendView addSubview:FriendLabel];
    
    UIView *FrienlistdView = [[UIView alloc] initWithFrame:CGRectMake(ViewW * 3, 0, ViewW, 90)];
    FrienlistdView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:FrienlistdView];
    
    _FriendlistBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _FriendlistBtn.backgroundColor = [UIColor clearColor];
    [_FriendlistBtn setBackgroundImage:[UIImage imageNamed:@"BBT_Minelist"] forState:UIControlStateNormal];
    
    
    [FrienlistdView addSubview:_FriendlistBtn];
    
    UILabel *FriendlistLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_FriendBtn.frame) + 10, ViewW, 12)];
    FriendlistLabel.font = [UIFont systemFontOfSize:12.0];
    FriendlistLabel.backgroundColor = [UIColor clearColor];
    FriendlistLabel.text = @"好友列表";
    FriendlistLabel.textAlignment = NSTextAlignmentCenter;
    FriendlistLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [FrienlistdView addSubview:FriendlistLabel];
    
    
    UIView *WalletView = [[UIView alloc] initWithFrame:CGRectMake(0, 90, ViewW, 90)];
    WalletView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:WalletView];
    
    _WalletBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _WalletBtn.backgroundColor = [UIColor clearColor];
    [_WalletBtn setBackgroundImage:[UIImage imageNamed:@"BBT_Mineintellegence"] forState:UIControlStateNormal];
    
    
    [WalletView addSubview:_WalletBtn];
    
    UILabel *WalletLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_WalletBtn.frame) + 10, ViewW, 12)];
    WalletLabel.font = [UIFont systemFontOfSize:12.0];
    WalletLabel.backgroundColor = [UIColor clearColor];
    WalletLabel.text = @"获取智力";
    WalletLabel.textAlignment = NSTextAlignmentCenter;
    WalletLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [WalletView addSubview:WalletLabel];
    

    
    
    
    UIView *RealNameView = [[UIView alloc] initWithFrame:CGRectMake( ViewW , 90, ViewW, 90)];
    RealNameView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:RealNameView];
    
    _RealNameBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _RealNameBtn.backgroundColor = [UIColor clearColor];
    [_RealNameBtn setBackgroundImage:[UIImage imageNamed:@"BBT_Mine_adress"] forState:UIControlStateNormal];
    
    
    [RealNameView addSubview:_RealNameBtn];
    
    
    UILabel *RealNameLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_RealNameBtn.frame) + 10, ViewW, 12)];
    RealNameLabel.font = [UIFont systemFontOfSize:12.0];
    RealNameLabel.backgroundColor = [UIColor clearColor];
    RealNameLabel.text = @"收货地址";
    RealNameLabel.textAlignment = NSTextAlignmentCenter;
    RealNameLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [RealNameView addSubview:RealNameLabel];
    

    
//LearnCardBtn
    
    _LearnCardView = [[UIView alloc] initWithFrame:CGRectMake( ViewW *2, 90, ViewW, 90)];
    _LearnCardView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:_LearnCardView];
    
    _LearnCardBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _LearnCardBtn.backgroundColor = [UIColor clearColor];
    [_LearnCardBtn setBackgroundImage:[UIImage imageNamed:@"BBT_Minestudycard"] forState:UIControlStateNormal];
    
    
    [_LearnCardView addSubview:_LearnCardBtn];
    
    
    
    UILabel *LearnCardLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_LearnCardBtn.frame) + 10, ViewW, 12)];
    LearnCardLabel.font = [UIFont systemFontOfSize:12.0];
    LearnCardLabel.backgroundColor = [UIColor clearColor];
    LearnCardLabel.text = @"卡包";
    LearnCardLabel.textAlignment = NSTextAlignmentCenter;
    LearnCardLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [_LearnCardView addSubview:LearnCardLabel];
    

    
    _SettingView = [[UIView alloc] initWithFrame:CGRectMake( ViewW *3, 90, ViewW, 90)];
    _SettingView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:_SettingView];
    
    _SettingBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _SettingBtn.backgroundColor = [UIColor clearColor];
    [_SettingBtn setBackgroundImage:[UIImage imageNamed:@"BBT_Minesetting"] forState:UIControlStateNormal];
    
    
    [_SettingView addSubview:_SettingBtn];
    
    
    
    UILabel *SettingLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_SettingBtn.frame) + 10, ViewW, 12)];
    SettingLabel.font = [UIFont systemFontOfSize:12.0];
    SettingLabel.backgroundColor = [UIColor clearColor];
    SettingLabel.text = @"设置";
    SettingLabel.textAlignment = NSTextAlignmentCenter;
    SettingLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [_SettingView addSubview:SettingLabel];
    
    return bgView;
    
}

- (void)layoutSubviews {
    
      CGFloat ViewW = (kDeviceWidth - 32 - 2)/4.0;
    
    if (self.LearnCardView.hidden == YES) {
        self.SettingView.frame = CGRectMake( ViewW *2, 90, ViewW, 90);
    }
    else
    {
       self.SettingView.frame = CGRectMake( ViewW *3, 90, ViewW, 90);
    }
}

@end

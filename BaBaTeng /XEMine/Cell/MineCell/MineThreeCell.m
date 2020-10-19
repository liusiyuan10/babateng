//
//  MineThreeCell.m
//  BaBaTeng
//
//  Created by xyj on 2019/4/2.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import "MineThreeCell.h"
#import "Header.h"


@implementation MineThreeCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,90 + 16)];
    bgView.backgroundColor = [UIColor whiteColor];
    //    bgView.backgroundColor = [UIColor whiteColor];
    
    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(16,16, kDeviceWidth - 32,90)];
    backView.backgroundColor = [UIColor whiteColor];
    
    backView.layer.cornerRadius= 15.0f;
    
    backView.layer.borderWidth = 1.0;
    backView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    backView.clipsToBounds = YES;//去除边界
    backView.layer.masksToBounds = YES;
    
    [bgView addSubview:backView];
    
    CGFloat ViewW = (kDeviceWidth - 32 - 2)/3.0;
    
    UIView *MemberView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ViewW, 90)];
    MemberView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:MemberView];
    
   _memberBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _memberBtn.backgroundColor = [UIColor clearColor];
    [_memberBtn setBackgroundImage:[UIImage imageNamed:@"vip"] forState:UIControlStateNormal];
    
    
    [MemberView addSubview:_memberBtn];
    
    
    UILabel *memberLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_memberBtn.frame) + 10, ViewW, 12)];
    memberLabel.font = [UIFont systemFontOfSize:12.0];
    memberLabel.backgroundColor = [UIColor clearColor];
    memberLabel.text = @"会员中心";
    memberLabel.textAlignment = NSTextAlignmentCenter;
    memberLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [MemberView addSubview:memberLabel];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(ViewW, 18, 1.0, 90 - 18 -16 )];
    
    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    [backView addSubview:lineView];
    
    UIView *FriendView = [[UIView alloc] initWithFrame:CGRectMake(ViewW + 1, 0, ViewW, 90)];
    FriendView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:FriendView];
    
    _FriendBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _FriendBtn.backgroundColor = [UIColor clearColor];
    [_FriendBtn setBackgroundImage:[UIImage imageNamed:@"mine_friends"] forState:UIControlStateNormal];
    
    
    [FriendView addSubview:_FriendBtn];
    
    UILabel *FriendLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_FriendBtn.frame) + 10, ViewW, 12)];
    FriendLabel.font = [UIFont systemFontOfSize:12.0];
    FriendLabel.backgroundColor = [UIColor clearColor];
    FriendLabel.text = @"邀请好友";
    FriendLabel.textAlignment = NSTextAlignmentCenter;
    FriendLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [FriendView addSubview:FriendLabel];
    
    UIImageView *line1View = [[UIImageView alloc] initWithFrame:CGRectMake(ViewW * 2 + 1, 18, 1.0, 90 - 18 -16 )];
    
    line1View.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
    
    [backView addSubview:line1View];
    
    UIView *SettingView = [[UIView alloc] initWithFrame:CGRectMake( (ViewW + 1) *2, 0, ViewW, 90)];
    SettingView.backgroundColor = [UIColor clearColor];
    
    [backView addSubview:SettingView];
    
    _SettingBtn = [[UIButton alloc]initWithFrame:CGRectMake( (ViewW - 36)/2.0, 18 ,36, 36)];
    
    _SettingBtn.backgroundColor = [UIColor clearColor];
    [_SettingBtn setBackgroundImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    
    
    [SettingView addSubview:_SettingBtn];
    
    
    
    UILabel *SettingLabel = [[UILabel alloc] initWithFrame:CGRectMake( 0, CGRectGetMaxY(_SettingBtn.frame) + 10, ViewW, 12)];
    SettingLabel.font = [UIFont systemFontOfSize:12.0];
    SettingLabel.backgroundColor = [UIColor clearColor];
    SettingLabel.text = @"设置";
    SettingLabel.textAlignment = NSTextAlignmentCenter;
    SettingLabel.textColor = [UIColor colorWithRed:144/255.0 green:144/255.0 blue:144/255.0 alpha:1.0];
    [SettingView addSubview:SettingLabel];
    
    return bgView;
    
}


//-(UIView*)contentViewCell{
//    
//    
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,64)];
//    //    NSLog(@"cell的高度%f" );
//    bgView.backgroundColor = [UIColor whiteColor];
//    
//    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 21, 24, 24)];
//    _leftImage.image = [UIImage imageNamed:@"friends"];
//
//    _leftImage.userInteractionEnabled = YES;
//    
//    [bgView addSubview:_leftImage];
//    
//    _labTip = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 20, 25, 100, 16)];
//    _labTip.font = [UIFont systemFontOfSize:16.0];
//    _labTip.backgroundColor = [UIColor clearColor];
//    //        _labTip.textColor = [UIColor light_Black_Color];
//    _labTip.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    [bgView addSubview:_labTip];
//    
//
//    
//    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(kDeviceWidth - 22 - 16, (64 - 26)/2.0, 22, 26)];
//    
//    arrow.image = [UIImage imageNamed:@"btn_genduo2_nor"];
//    //    self.accessoryView = arrow;
//    
//    [bgView addSubview:arrow];
//    
//
//    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 63, kDeviceWidth - 32, 1.0)];
//    
//    lineView.backgroundColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0];
//    
//    [bgView addSubview:lineView];
//    
//    return bgView;
//}
@end

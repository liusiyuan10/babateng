//
//  EnglishTeacherCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/18.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "EnglishTeacherCell.h"
#import "Header.h"
#import <sys/utsname.h>

@implementation EnglishTeacherCell

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
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,113)];
    //    bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:231/255.0 alpha:1.0];
    bgView.backgroundColor = [UIColor whiteColor];
    
    
    _iocnView = [[UIImageView alloc]initWithFrame:CGRectMake(16, 16, 81, 81)];
    _iocnView.userInteractionEnabled = YES;
    _iocnView.backgroundColor = [UIColor clearColor];
    _iocnView.contentMode = UIViewContentModeScaleToFill;
    _iocnView.layer.cornerRadius= 15.0f;
    _iocnView.layer.borderWidth = 1.0;
    _iocnView.layer.borderColor = [UIColor colorWithRed:238/255.0 green:238/255.0 blue:238/255.0 alpha:1.0].CGColor;
    _iocnView.clipsToBounds = YES;//去除边界
    _iocnView.layer.masksToBounds = YES;
    _iocnView.image = [UIImage imageNamed:@"Teacher"];

    [bgView addSubview:_iocnView];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + 16, 40,kDeviceWidth - CGRectGetMaxX(_iocnView.frame) - 16 - 70, 20)];
    
    _nameLabel.font = [UIFont boldSystemFontOfSize:18];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    _nameLabel.text = @"Teacher A";
    _nameLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview:_nameLabel];

    
    
     _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + 16,CGRectGetMaxY(_nameLabel.frame) + 12, 200, 16)];
    
     _numLabel.font = [UIFont systemFontOfSize:14];
     _numLabel.backgroundColor = [UIColor clearColor];
     _numLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
     _numLabel.text = @"剩余可预约次数:20";
     _numLabel.textAlignment = NSTextAlignmentLeft;
    
    [bgView addSubview: _numLabel];
    
//    _numLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(surplusLabel.frame), CGRectGetMaxY(_nameLabel.frame) + 9, 50, 16)];
//
//    _numLabel.font = [UIFont systemFontOfSize:11];
//    _numLabel.backgroundColor = [UIColor clearColor];
//    _numLabel.textColor = [UIColor colorWithRed:254/255.0 green:221/255.0 blue:192/255.0 alpha:1.0];
//    _numLabel.text = @"20";
//    _numLabel.textAlignment = NSTextAlignmentLeft;
//
//    [bgView addSubview:_numLabel];
//
    
//    _experienceBtn = [[UIButton alloc]initWithFrame:CGRectMake(kDeviceWidth - 80 -16,39 ,80, 36)];
    
    CGFloat exBtnW = 0;
    NSString *iphoneType = [self deviceVersion];
    
    NSLog(@"iphoneType============%@",iphoneType);
    
    if ([iphoneType isEqualToString:@"iPhone 5"] ||[iphoneType isEqualToString:@"iPhone 5C"]||[iphoneType isEqualToString:@"iPhone 5S"]||[iphoneType isEqualToString:@"iPhone SE"]) {
        exBtnW = 127;
    }else if ([iphoneType isEqualToString:@"iPhone 6 Plus"] ||[iphoneType isEqualToString:@"iPhone 7 plus"]||[iphoneType isEqualToString:@"iPhone 8 plus"]||[iphoneType isEqualToString:@"iPhone 6s Plus"])
    {
        exBtnW = 220;
    }
    else if ([iphoneType isEqualToString:@"iPhone 6"] ||[iphoneType isEqualToString:@"iPhone 7"]||[iphoneType isEqualToString:@"iPhone 8"]||[iphoneType isEqualToString:@"iPhone 6s"]||[iphoneType isEqualToString:@"iPhone X"])
    {
        exBtnW = 182;
    }else
    {
        exBtnW = 220;
    }
  _experienceBtn = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_iocnView.frame) + exBtnW,39 ,80, 36)];
    
    
    
    _experienceBtn.backgroundColor = MNavBackgroundColor;
    _experienceBtn.contentMode = UIViewContentModeScaleAspectFill;
    
    [_experienceBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_experienceBtn setTitle:@"预约" forState:UIControlStateNormal];
    
    _experienceBtn.titleLabel.font = [UIFont boldSystemFontOfSize:15.0];
    
    _experienceBtn.layer.cornerRadius= 18.0f;
    
    _experienceBtn.clipsToBounds = YES;//去除边界
    
    
    [bgView addSubview:_experienceBtn];
    
    UIImageView *lineView = [[UIImageView alloc] initWithFrame:CGRectMake(113, 112, kDeviceWidth - 113 - 16, 1.0)];
    
    lineView.backgroundColor = [UIColor colorWithRed:229/255.0 green:229/255.0 blue:229/255.0 alpha:1.0];
    
    [bgView addSubview:lineView];
    
    
    
    return bgView;
    
}

- (NSString*)deviceVersion

{
    
    struct utsname systeminfo;
    uname(&systeminfo);
    

 NSString *deviceString = [NSString stringWithCString:systeminfo.machine encoding:NSUTF8StringEncoding];



if ([deviceString isEqualToString:@"iPhone5,1"]) return @"iPhone 5";
if ([deviceString isEqualToString:@"iPhone1,2"]) return @"iPhone 5";
if ([deviceString isEqualToString:@"iPhone5,3"]) return @"iPhone 5C";
if ([deviceString isEqualToString:@"iPhone5,4"]) return @"iPhone 5C";
if ([deviceString isEqualToString:@"iPhone6,1"]) return @"iPhone 5S";
if ([deviceString isEqualToString:@"iPhone6,2"]) return @"iPhone 5S";
if ([deviceString isEqualToString:@"iPhone8,4"]) return @"iPhone SE";

    
if ([deviceString isEqualToString:@"iPhone7,2"]) return @"iPhone 6";
if ([deviceString isEqualToString:@"iPhone8,1"]) return @"iPhone 6s";
    
    
if ([deviceString isEqualToString:@"iPhone7,1"]) return @"iPhone 6 Plus";
if ([deviceString isEqualToString:@"iPhone8,2"]) return @"iPhone 6s Plus";

    if ([deviceString isEqualToString:@"iPhone9,1"]) return @"iPhone 7";
    if ([deviceString isEqualToString:@"iPhone9,3"]) return @"iPhone 7";

    if ([deviceString isEqualToString:@"iPhone9,4"]) return @"iPhone 7 plus";
    if ([deviceString isEqualToString:@"iPhone9,2"]) return @"iPhone 7 plus";

    if ([deviceString isEqualToString:@"iPhone10,1"]) return @"iPhone 8";
    if ([deviceString isEqualToString:@"iPhone10,4"]) return @"iPhone 8";

    if ([deviceString isEqualToString:@"iPhone10,5"]) return @"iPhone 8 plus";
    if ([deviceString isEqualToString:@"iPhone10,2"]) return @"iPhone 8 plus";

    if ([deviceString isEqualToString:@"iPhone10,3"]) return @"iPhone X";
    if ([deviceString isEqualToString:@"iPhone10,3"]) return @"iPhone X";

    return deviceString;

}
    
@end

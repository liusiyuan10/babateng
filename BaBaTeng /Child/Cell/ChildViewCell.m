//
//  ChildViewCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/4/23.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "ChildViewCell.h"
#import "Header.h"

#import "BulletinData.h"
#import "ChildFrame.h"

#import "UIImageView+AFNetworking.h"

@implementation ChildViewCell

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


    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = DefaultBackgroundColor;

    _backView = [[UIView alloc]init];
    _backView.backgroundColor = [UIColor whiteColor];
    
    _backView.layer.cornerRadius= 3.0f;
    _backView.clipsToBounds = YES;//去除边界

    [_bgView addSubview:_backView];


    _iocnView = [[UIImageView alloc]init];
    _iocnView.userInteractionEnabled = NO;
    _iocnView.backgroundColor = [UIColor clearColor];
    _iocnView.contentMode = UIViewContentModeScaleToFill;

    [_backView addSubview:_iocnView];

    _tilteLabel = [[UILabel alloc] init];

    _tilteLabel.font = [UIFont boldSystemFontOfSize:18];
    _tilteLabel.backgroundColor = [UIColor clearColor];
    _tilteLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
    _tilteLabel.text = @"Teacher A";
    _tilteLabel.textAlignment = NSTextAlignmentLeft;
    _tilteLabel.numberOfLines = 0;

    [_backView addSubview:_tilteLabel];

    _contentLabel = [[UILabel alloc] init];

    _contentLabel.font = [UIFont systemFontOfSize:15];
    _contentLabel.backgroundColor = [UIColor clearColor];
    _contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:102/255.0];
    _contentLabel.text = @"摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容";
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.numberOfLines = 0;

    [_backView addSubview:_contentLabel];

    return _bgView;

}

-(void)setChildFrame:(ChildFrame *)childFrame
{
    _childFrame = childFrame;
    
    [self settingData];
    [self settingFrame];
}

- (void)settingData
{
    
    BulletinData *bulletindata = self.childFrame.bulltindata;

    NSString *encodedString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)bulletindata.bulletinIcon, (CFStringRef)@"!NULL,'()*+,-./:;=?@_~%#[]", NULL, kCFStringEncodingUTF8));

    [self.iocnView setImageWithURL:[NSURL URLWithString:encodedString] placeholderImage:[UIImage imageNamed:@"yuerbanner"]];

    self.tilteLabel.text = bulletindata.bulletinTitle;
    self.contentLabel.text = bulletindata.bulletinSummary;

}

- (void)settingFrame
{
    self.bgView.frame = self.childFrame.bgViewFrame;
    self.backView.frame = self.childFrame.backViewFrame;
    self.iocnView.frame = self.childFrame.iocnFrame;
    self.tilteLabel.frame = self.childFrame.tilteFrame;
    self.contentLabel.frame = self.childFrame.contentFrame;
}

//
//-(UIView*)contentViewCell{
//
////    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,168 + 87)];
////    bgView.backgroundColor = [UIColor whiteColor];
//
//    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,168 + 87 + 8)];
//    bgView.backgroundColor = DefaultBackgroundColor;
//
//    UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,168 + 87)];
//    backView.backgroundColor = [UIColor whiteColor];
//
//    [bgView addSubview:backView];
//
//
//    _iocnView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kDeviceWidth, 168)];
//    _iocnView.userInteractionEnabled = NO;
//    _iocnView.backgroundColor = [UIColor clearColor];
//    _iocnView.contentMode = UIViewContentModeScaleToFill;
//
//    [backView addSubview:_iocnView];
//
//    _tilteLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_iocnView.frame) + 8,kDeviceWidth - 32, 25)];
//
//    _tilteLabel.font = [UIFont boldSystemFontOfSize:18];
//    _tilteLabel.backgroundColor = [UIColor clearColor];
//    _tilteLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0];
//    _tilteLabel.text = @"Teacher A";
//    _tilteLabel.textAlignment = NSTextAlignmentLeft;
//
//    [backView addSubview:_tilteLabel];
//
//    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(_tilteLabel.frame) + 6, kDeviceWidth - 32, 18)];
//
//    _contentLabel.font = [UIFont systemFontOfSize:14];
//    _contentLabel.backgroundColor = [UIColor clearColor];
//    _contentLabel.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:102/255.0];
//    _contentLabel.text = @"摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容摘要内容";
//    _contentLabel.textAlignment = NSTextAlignmentLeft;
//
//    [backView addSubview:_contentLabel];
//
//    return bgView;
//
//}


@end

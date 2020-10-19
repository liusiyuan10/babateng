//
//  FamilyMessageDetailsCell.m
//  BaBaTeng
//
//  Created by OwenYang2017 on 2017/8/14.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "FamilyMessageDetailsCell.h"
#import "Header.h"
@implementation FamilyMessageDetailsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}



- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        UIView*cellView = [self contentViewCell];
        [self.contentView addSubview:cellView];
        
    }
    return self;
}


-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,60)];
    
    bgView.backgroundColor = [UIColor whiteColor];//CellBackgroundColor;
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, 200, 40)];
    _nameLabel.font = [UIFont systemFontOfSize:18];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = [UIColor blackColor];
     _nameLabel.text = @"你好吗哈哈哈";
    [bgView addSubview:_nameLabel];
    
    _subNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth-220, 10, 180, 40)];
    _subNameLabel.font = [UIFont systemFontOfSize:14];
    _subNameLabel.backgroundColor = [UIColor clearColor];
    _subNameLabel.textColor = [UIColor lightGrayColor];
    _subNameLabel.textAlignment = NSTextAlignmentRight;

    _subNameLabel.text = @"哈哈放放风";
    [bgView addSubview:_subNameLabel];
    
    
    //需要画一条横线
    UIImageView *topImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15,59.5,[UIScreen mainScreen].bounds.size.width-30, 0.5)];
    topImageView.image = [UIImage imageNamed:@"line.png"];
    
    [bgView addSubview:topImageView];
    
    
    
    return bgView;
}

@end

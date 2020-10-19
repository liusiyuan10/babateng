//
//  NewMultilevelTableViewCell.m
//  YijietongBuy
//
//  Created by YangGH on 15/11/19.
//  Copyright © 2015年 YangGH. All rights reserved.
//

#import "NewMultilevelTableViewCell.h"
#import "UIColor+Helper.h"
@implementation NewMultilevelTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];//[UIColor cellBackViewColor];
        
        
//        _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(25,10,30, 30)];
//        _leftImage.contentMode = UIViewContentModeScaleAspectFit;
//        [self.contentView addSubview:_leftImage];
        
        _labTip = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, 90, 20)];
        _labTip.font = [UIFont systemFontOfSize:14];
      
        _labTip.textColor = [UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1];;
        _labTip.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_labTip];
        

        
//        self.rightLineImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cellSeparatorLine.png"]];
//        self.rightLineImage.frame = CGRectMake(39.7,0,0.3,40);
//        [self.contentView addSubview:self.rightLineImage];
        

    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setZero{
    
    if ([self respondsToSelector:@selector(setLayoutMargins:)]) {
        self.layoutMargins=UIEdgeInsetsZero;
    }
    if ([self respondsToSelector:@selector(setSeparatorInset:)]) {
        self.separatorInset=UIEdgeInsetsZero;
    }
    
}


@end

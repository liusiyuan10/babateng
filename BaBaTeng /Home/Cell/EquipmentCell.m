//
//  FavoriteCell.m
//  BaBaTeng
//
//  Created by liu on 17/2/17.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import "EquipmentCell.h"
#import "Header.h"

@implementation EquipmentCell

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
     
        self.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:cellView];
        
    }
    return self;
}

-(UIView*)contentViewCell{
    //适配iphone x
    CGFloat myHeight;
    CGFloat myHeightwo;
    if (iPhoneX) {
        myHeight=71;
        myHeightwo =80;
    }else{
        myHeight=81;
        myHeightwo =90;
        
        
    }
    
    _bgImageView = [[UIImageView alloc]initWithFrame:CGRectMake(8,0, kDeviceWidth-16,myHeight/568.0*KDeviceHeight)];
    _bgImageView.backgroundColor = [UIColor clearColor];
    _bgImageView.layer.cornerRadius = 5;
    _bgImageView.contentMode  = UIViewContentModeScaleToFill;
    _bgImageView.clipsToBounds = YES;
    
    _leftImage = [[UIImageView alloc] initWithFrame:CGRectMake(12, 5, 67, 70/568.0*KDeviceHeight)];
    _leftImage.contentMode  = UIViewContentModeScaleAspectFit;
    _leftImage.backgroundColor = [UIColor clearColor];
    
    [_bgImageView addSubview:_leftImage];
    
    _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 15, 0, 200, myHeight/568.0*KDeviceHeight)];
    _nameLabel.font = [UIFont systemFontOfSize:15];
    _nameLabel.backgroundColor = [UIColor clearColor];
    _nameLabel.textColor = MainFontColorTWO;
    [_bgImageView addSubview:_nameLabel];
    
//    _onlineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_leftImage.frame) + 15, 35, 200, 30/568.0*KDeviceHeight)];
//    _onlineLabel.font = [UIFont systemFontOfSize:15];
//    _onlineLabel.backgroundColor = [UIColor yellowColor];
//    _onlineLabel.textColor = [UIColor lightGrayColor];
//    [_bgImageView addSubview:_onlineLabel];
    
    
    //    //需要画一条横线
    //    _topImageView= [[UIImageView alloc] initWithFrame:CGRectMake(15,89.5,[UIScreen mainScreen].bounds.size.width-30, 0.5)];
    //    _topImageView.image = [UIImage imageNamed:@"line.png"];
    //
    //     [_bgImageView addSubview:_topImageView];
    
    
    _normalCellBG = [[UIImageView alloc] initWithFrame:CGRectMake(8,0, kDeviceWidth-16,myHeight/568.0*KDeviceHeight)];
    _normalCellBG.clipsToBounds = YES;
    _normalCellBG.contentMode = UIViewContentModeScaleToFill;
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,myHeightwo/568.0*KDeviceHeight)];
    [self.backgroundView addSubview:_normalCellBG];
    
    _selecetedCellBG = [[UIImageView alloc] initWithFrame:CGRectMake(8,0, kDeviceWidth-16,myHeight/568.0*KDeviceHeight)];
    _selecetedCellBG.clipsToBounds = YES;
    _selecetedCellBG.contentMode = UIViewContentModeScaleToFill;
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth,myHeightwo/568.0*KDeviceHeight)];
    [self.selectedBackgroundView addSubview:_selecetedCellBG];
    
    
    return _bgImageView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self dealDeleteButton];
}
- (void)dealDeleteButton {
    
    for (UIView *subView in self.subviews) {
        
        if ([subView isKindOfClass:NSClassFromString(@"UITableViewCellDeleteConfirmationView")]) {
            
            subView.backgroundColor = [UIColor clearColor];
            //            subView.frame.origin.x = kDeviceWidth - 100;
            
            for (UIButton *button in subView.subviews) {
                
                if ([button isKindOfClass:[UIButton class]]) {
                    //适配iphone x
                    CGFloat myHeight;
                    
                    if (iPhoneX) {
                        myHeight=71;
                        
                    }else{
                        
                        myHeight=81;
                        
                    }
                    button.frame = CGRectMake(0, 0, 80, myHeight/568.0*KDeviceHeight);
                    button.backgroundColor = [UIColor redColor];
                    button.titleLabel.font = [UIFont systemFontOfSize:14.0];
                    button.titleLabel.text = @"删除";
                    
                }
            }
        }
    }
}



@end

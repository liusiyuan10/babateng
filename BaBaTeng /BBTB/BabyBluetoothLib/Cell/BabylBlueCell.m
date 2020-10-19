//
//  ToolBlueCell.m
//  BaBaTeng
//
//  Created by 柳思源 on 2018/5/31.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import "BabylBlueCell.h"

#import "Header.h"

@implementation BabylBlueCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        UIView*cellView = [self contentViewCell];
        [self.contentView addSubview:cellView];
        
    }
    return self;
}



-(UIView*)contentViewCell{
    
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0,0, kDeviceWidth,64)];
//        bgView.backgroundColor = [UIColor colorWithRed:255/255.0 green:253/255.0 blue:231/255.0 alpha:1.0];
    bgView.backgroundColor = DefaultBackgroundColor;
    
    UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, kDeviceWidth - 20,44)];
    
    backView.backgroundColor = [UIColor whiteColor];
    
    [bgView addSubview:backView];
    
    
    _bluenameLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 12,150, 20)];
    
    _bluenameLabel.font = [UIFont systemFontOfSize:14];
    _bluenameLabel.backgroundColor = [UIColor clearColor];
    _bluenameLabel.textColor = [UIColor blackColor];
//    _bluenameLabel.text = @"课程次数:";
    _bluenameLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_bluenameLabel];
    
    _blueUUIDLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 28,kDeviceWidth - 20, 20)];
    
    _blueUUIDLabel.font = [UIFont systemFontOfSize:11];
    _blueUUIDLabel.backgroundColor = [UIColor clearColor];
    _blueUUIDLabel.textColor = [UIColor blackColor];
    //    _bluenameLabel.text = @"课程次数:";
    _blueUUIDLabel.textAlignment = NSTextAlignmentLeft;
    
    [backView addSubview:_blueUUIDLabel];
    
    _stateLabel= [[UILabel alloc] initWithFrame:CGRectMake(kDeviceWidth - 20 - 50 -10,12, 50, 20)];
    
    _stateLabel.font = [UIFont systemFontOfSize:14];
    _stateLabel.backgroundColor = [UIColor clearColor];//109, 209, 254
    _stateLabel.textColor = [UIColor colorWithRed:109/255.0 green:209/255.0 blue:254/255.0 alpha:1.0];
  
    _stateLabel.textAlignment = NSTextAlignmentRight;
    
    [backView addSubview:_stateLabel];
    
    
    return bgView;
    
}


- (void)setPeripheral:(CBPeripheral *)peripheral
{
    _peripheral = peripheral ;
    
    self.bluenameLabel.text = peripheral.name ;
    self.blueUUIDLabel.text = [NSString stringWithFormat:@"%@",peripheral.identifier];
//    self.RSSILabel.text = [NSString stringWithFormat:@"%@",peripheral.RSSI ];

//    self.servicesLabel.text = [NSString stringWithFormat:@"%zd Services",serviceArray.count];
    
    if (peripheral.state == CBPeripheralStateConnected) {
        self.stateLabel.text = @"已配对";
//        self.stateLabel.backgroundColor = [UIColor greenColor];
    }else{
//        self.stateLabel.backgroundColor = [UIColor orangeColor];
        self.stateLabel.text = @"配对";
    }
}
@end

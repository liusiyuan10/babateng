//
//  Drawer_TableViewCell.h
//  XTZL
//
//  Created by 虞海飞 on 16/8/4.
//  Copyright © 2016年 虞海飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Drawer_TableViewCell : UITableViewCell

/**  标题 */
@property (weak, nonatomic) IBOutlet UILabel *label_Title;


@property (nonatomic,strong) NSDictionary *dic_Data;

@end

//
//  ViewController.h
//  BaBaTeng
//
//  Created by liu on 17/5/20.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonViewController.h"

@interface QFavoriteViewController : CommonViewController{

     BOOL  IsAddPlayList;//是否第一次点播的时候添加到播放列表
     BOOL  IsPlay;//当前歌曲是否是播放还是暂停状态
}

@end

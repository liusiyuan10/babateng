//
//  MyEnglishDataModel.h
//  BaBaTeng
//
//  Created by 柳思源 on 2018/11/1.
//  Copyright © 2018年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyEnglishDataModel : NSObject

@property (nonatomic, copy)    NSString *downloadUrl;
@property (nonatomic, copy)    NSString   *duration;
@property (nonatomic, copy)    NSString *isAddToSongList;
@property (nonatomic, copy)    NSString *isCollected;
@property (nonatomic, copy)    NSString *playUrl;

@property (nonatomic, copy)    NSString *trackIcon;
@property (nonatomic, copy)    NSString   *trackId;
@property (nonatomic, copy)    NSString *trackListId;
@property (nonatomic, copy)    NSString *trackName;
@property (nonatomic, copy)    NSString *trackNamePinyin;
@property (nonatomic, copy)    NSString *trackSize;

@end

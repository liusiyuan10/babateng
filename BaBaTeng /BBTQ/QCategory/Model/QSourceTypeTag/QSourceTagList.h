//
//  QSourceTagList.h
//  BaBaTeng
//
//  Created by liu on 17/7/10.
//  Copyright © 2017年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QSourceTagList : NSObject

//"downloadUrl": "http://orfvq12yi.bkt.clouddn.com/track/1/%E5%81%A5%E5%BA%B7%E6%AD%8C.mp3",
//"duration": 174,
//"playUrl": "http://orfvq12yi.bkt.clouddn.com/track/1/%E5%81%A5%E5%BA%B7%E6%AD%8C.mp3",
//"trackIcon": "http://orfvq12yi.bkt.clouddn.com/image/icon/%E5%84%BF%E6%AD%8C%E7%B2%BE%E9%80%89.jpg",
//"trackId": 3,
//"trackListId": 1,
//"trackName": "健康歌",
//"trackNamePinyin": "jiankangge",
//"trackSize": 2793761

@property (nonatomic, copy) NSString *downloadUrl;
@property (nonatomic, copy) NSString *duration;
@property (nonatomic, copy) NSString *playUrl;
@property (nonatomic, copy) NSString *trackIcon;
@property (nonatomic, copy) NSString *trackId;
@property (nonatomic, copy) NSString *trackListId;
@property (nonatomic, copy) NSString *trackName;
@property (nonatomic, copy) NSString *trackNamePinyin;
@property (nonatomic, copy) NSString *trackSize;


@property (nonatomic, copy) NSString *isAddToSongList;
@property (nonatomic, copy) NSString *isCollected;



@property(nonatomic, assign) BOOL  isListening;//是否正在试听
@property(nonatomic, assign) BOOL  IsDeviceplay;//是否正在试听

@end

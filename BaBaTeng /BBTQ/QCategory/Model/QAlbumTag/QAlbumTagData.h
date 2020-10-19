//
//  QAlbumTagData.h
//  BaBaTeng
//
//  Created by xyj on 2019/2/13.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface QAlbumTagData : NSObject

@property (nonatomic, copy) NSString *createTime;

@property (nonatomic, copy) NSString *panelId;
@property (nonatomic, copy) NSString *trackListAuthor;
@property (nonatomic, copy) NSString *trackListDescription;
@property (nonatomic, copy) NSString *trackListIcon;
@property (nonatomic, copy) NSString *trackListId;
@property (nonatomic, copy) NSString *trackListName;
@property (nonatomic, copy) NSString *pages;

@end

NS_ASSUME_NONNULL_END

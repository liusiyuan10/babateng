//
//  studentVideoList.h
//  BaBaTeng
//
//  Created by xyj on 2019/9/11.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface studentVideoList : NSObject


@property (nonatomic, copy) NSString   *appStatus;
@property (nonatomic, copy) NSString   *coverUrl;
@property (nonatomic, copy) NSString   *id;
@property (nonatomic, copy) NSString   *introduction;
@property (nonatomic, copy) NSString   *plateId;
@property (nonatomic, copy) NSString   *plateName;

@property (nonatomic, copy) NSString   *studentName;
@property (nonatomic, copy) NSString   *updateDate;

@property (nonatomic, copy) NSString   *videoName;
@property (nonatomic, copy) NSString   *videoUrl;
@end

NS_ASSUME_NONNULL_END

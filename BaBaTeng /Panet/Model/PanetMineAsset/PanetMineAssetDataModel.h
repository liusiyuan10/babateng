//
//  PanetMineAssetDataModel.h
//  BaBaTeng
//
//  Created by xyj on 2019/3/5.
//  Copyright © 2019年 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PanetMineAssetDataModel : NSObject

//    资产总数    number    @mock=56.99
//peasValue    最近释放的英豆    number    @mock=3000
//scoreVlue    昨天收益的知识豆
//@property (nonatomic, copy) NSString *myAssets;
//@property (nonatomic, copy) NSString *peasValue;
//@property (nonatomic, copy) NSString *scoreVlue;
//@property (nonatomic, copy) NSString *sumPeasValue;
//@property (nonatomic, copy) NSString *sumScoreVlue;

@property (nonatomic, assign) CGFloat myAssets;
@property (nonatomic, assign) CGFloat peasValue;
@property (nonatomic, assign) CGFloat scoreVlue;
@property (nonatomic, assign) CGFloat sumPeasValue;
@property (nonatomic, assign) CGFloat sumScoreVlue;

@end

NS_ASSUME_NONNULL_END

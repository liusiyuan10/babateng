//
//  TreeView.h
//  仿支付宝蚂蚁森林
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "PanetKnIntelDataModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    FruitTypeUnknown,
    FruitTypeTimeLimited,
    FruitTypeUnlimited,
} FruitType;

@protocol TreeViewDelegate <NSObject>

- (void)selectTimeLimitedBtnAtIndex:(NSInteger)index;

- (void)selectUnlimitedBtnAtIndex:(NSInteger)index;

- (void)TimeLimitedCollected;
- (void)UnlimitedCollected;
@end

@interface TreeView : UIView

@property (nonatomic, strong) NSArray <PanetKnIntelDataModel *> *timeLimitedArr;

@property (nonatomic, strong) NSArray <PanetKnIntelDataModel *> *unimitedArr;
//@property (nonatomic, strong) NSArray <NSString *> *unimitedArr;


- (void)createRandomBtnWithType:(FruitType)fruitType andText:(NSString *)textString andproduceId:(NSUInteger)produceId;

//- (void)removeRandomIndex:(NSInteger)index;
- (void)removeTimeLimitedIndex:(NSInteger)index;

- (void)removeunlimitedIndex:(NSInteger)index;

- (void)removeAlltimeLimitedBtn;

- (void)removeAllunlimiteBtn;

- (void)removeAllRandomBtn;

@property (nonatomic, weak) id <TreeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

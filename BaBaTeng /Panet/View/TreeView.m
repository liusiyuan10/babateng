//
//  TreeView.m
//  仿支付宝蚂蚁森林
//
//  Created by Dian Xin on 2019/1/6.
//  Copyright © 2019年 com.ovix. All rights reserved.
//

#import "TreeView.h"
#import "Header.h"
#import "JXButton.h"
#import <AVFoundation/AVFoundation.h>
#import "TMCache.h"


@interface TreeView ()<AVAudioPlayerDelegate>

@property (nonatomic, strong) NSMutableArray <NSValue *> *centerPointArr;

@property (nonatomic, strong) NSMutableArray <JXButton *> *randomBtnArr;

@property (nonatomic, strong) NSMutableArray <JXButton *> *randomBtnArrX;

@property (nonatomic, strong) NSMutableArray <JXButton *> *timeLimitedBtnArr;

@property (nonatomic, strong) NSMutableArray <JXButton *> *unlimitedBtnArr;

@property (nonatomic,strong)  AVAudioPlayer  *player;

@end

@implementation TreeView

static NSInteger const kTimeLimitedBtnTag = 20000;
static NSInteger const kUnlimitedBtnTag = 30000;

static CGFloat const kMargin = 10.0;
static CGFloat const kBtnDiameter = 80.0;
static CGFloat const kBtnMinX = kBtnDiameter * 0.5 + 0;
static CGFloat const kBtnMinY = 0.0;


#pragma mark - life cycle

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {

    }
    return self;
}

- (void)dealloc
{
    
}


#pragma mark - setter

- (void)setTimeLimitedArr:(NSArray<PanetKnIntelDataModel *> *)timeLimitedArr
{
    _timeLimitedArr = timeLimitedArr;
    
    for (int i = 0; i < timeLimitedArr.count; i ++) {
        [self createRandomBtnWithType:FruitTypeTimeLimited andText:timeLimitedArr[i]];
//        PanetKnIntelDataModel *model = timeLimitedArr[i];
//        [self createRandomBtnWithType:FruitTypeTimeLimited andText:model.producePeasValue andproduceId:[model.produceId integerValue]];
    }
}

- (void)setUnimitedArr:(NSArray<PanetKnIntelDataModel *> *)unimitedArr
{
    _unimitedArr = unimitedArr;
    
    NSLog(@"ssssssunimitedArr======%@",unimitedArr);
    for (int i = 0; i < unimitedArr.count; i ++) {
//        PanetKnIntelDataModel *model = unimitedArr[i];
//        NSLog(@"ssssssmodel====%@",unimitedArr[i]);
        NSLog(@"=========ssssssmodel====");
        [self createRandomBtnWithType:FruitTypeUnlimited andText:unimitedArr[i]];
//        [self createRandomBtnWithType:FruitTypeUnlimited andText:model.producePeasValue andproduceId:[model.produceId integerValue]];
//        [self createRandomBtnWithType:FruitTypeUnlimited andText:@"111" andproduceId:i+1000];
    }
}


#pragma mark - getter

- (NSMutableArray <NSValue *> *)centerPointArr
{
    if (_centerPointArr == nil) {
        _centerPointArr = [NSMutableArray array];
    }
    return _centerPointArr;
}

- (NSMutableArray<JXButton *> *)randomBtnArr
{
    if (_randomBtnArr == nil) {
        _randomBtnArr = [NSMutableArray array];
    }
    return _randomBtnArr;
}

- (NSMutableArray<JXButton *> *)randomBtnArrX
{
    if (_randomBtnArrX == nil) {
        _randomBtnArrX = [NSMutableArray array];
    }
    return _randomBtnArrX;
}

- (NSMutableArray<JXButton *> *)timeLimitedBtnArr
{
    if (_timeLimitedBtnArr == nil) {
        _timeLimitedBtnArr = [NSMutableArray array];
    }
    return _timeLimitedBtnArr;
}

- (NSMutableArray<JXButton *> *)unlimitedBtnArr
{
    if (_unlimitedBtnArr == nil) {
        _unlimitedBtnArr = [NSMutableArray array];
    }
    return _unlimitedBtnArr;
}


#pragma mark - 随机数

- (NSInteger)getRandomNumber:(CGFloat)from to:(CGFloat)to
{
    return (NSInteger)(from + (arc4random() % ((NSInteger)to - (NSInteger)from + 1)));
}


#pragma mark - 随机按钮

- (void)createRandomBtnWithType:(FruitType)fruitType andText:(PanetKnIntelDataModel *)panetKnModl
//- (void)createRandomBtnWithType:(FruitType)fruitType andText:(NSString *)textString andproduceId:(NSUInteger)produceId
{
    NSLog(@"dsfsdfsdfsdfdsfs");
    CGFloat minY = kBtnMinY + kBtnDiameter * 0.5 + kMargin;
    CGFloat maxY = self.bounds.size.height - kBtnDiameter * 0.5 - kMargin;
    CGFloat minX = kBtnMinX + kMargin;
    CGFloat maxX = kDeviceWidth -  kBtnDiameter * 0.5 - 0 - kMargin;
    
    CGFloat x = [self getRandomNumber:minX to:maxX];
    CGFloat y = [self getRandomNumber:minY to:maxY];
    
    BOOL success = YES;
    
//    for (int i = 0; i < self.centerPointArr.count; i ++) {
//        NSValue *pointValue = self.centerPointArr[i];
//        CGPoint point = [pointValue CGPointValue];
//        //如果是圆 /^2 如果不是圆 不用/^2
//        if (sqrt(pow(point.x - x, 2) + pow(point.y - y, 2)) <= kBtnDiameter + kMargin) {
//            success = NO;
//            
//            [self createRandomBtnWithType:fruitType andText:panetKnModl];
//            NSLog(@"===========================");
////            [self createRandomBtnWithType:fruitType andText:textString andproduceId:produceId];
//            
//            return;
//        }
//    }
    
    if (success == YES) {
        NSValue *pointValue = [NSValue valueWithCGPoint:CGPointMake(x, y)];
        [self.centerPointArr addObject:pointValue];
        
        JXButton *randomBtn = [JXButton buttonWithType:0];
        randomBtn.bounds = CGRectMake(0, 0, kBtnDiameter, kBtnDiameter);
        randomBtn.center = CGPointMake(x, y);
        [randomBtn setTitleColor:[UIColor whiteColor] forState:0];
        [self addSubview:randomBtn];
        

        
//        [self.randomBtnArr addObject:randomBtn];
//        [self.randomBtnArrX addObject:randomBtn];
       
        //区分
        if (fruitType == FruitTypeTimeLimited) {
//            randomBtn.tag = kUnlimitedBtnTag + self.centerPointArr.count - 1;
            randomBtn.tag = [panetKnModl.produceId integerValue];
//            randomBtn.tag = produceId;
            
            [self.timeLimitedBtnArr addObject:randomBtn];
            randomBtn.backgroundColor = [UIColor clearColor];
//            randomBtn.imageView.image = [UIImage imageNamed:@"english_beans"];knowledge_beans
            [randomBtn setImage:[UIImage imageNamed:@"knowledge_beans"] forState:UIControlStateNormal];

            [randomBtn addTarget:self action:@selector(timeLimitedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [randomBtn setTitle:[NSString stringWithFormat:@"%.5f",panetKnModl.produceScoreValue] forState:0];
        } else if (fruitType == FruitTypeUnlimited) {
//            randomBtn.tag = kTimeLimitedBtnTag + self.centerPointArr.count - 1;
            randomBtn.tag = [panetKnModl.produceId integerValue];
//            randomBtn.tag = produceId;
            [self.unlimitedBtnArr addObject:randomBtn];
            randomBtn.backgroundColor = [UIColor clearColor];
            [randomBtn setImage:[UIImage imageNamed:@"english_beans"] forState:UIControlStateNormal];
            
            [randomBtn addTarget:self action:@selector(unlimitedBtnClick:) forControlEvents:UIControlEventTouchUpInside];
            [randomBtn setTitle:[NSString stringWithFormat:@"%.5f",panetKnModl.produceScoreValue] forState:0];

            NSLog(@"chuangjiangyingdou    -----");

        }
        
//        [randomBtn setTitle:textString forState:0];
        
        [self animationScaleOnceWithView:randomBtn];
        [self animationUpDownWithView:randomBtn];
    }
}


#pragma mark - 随机按钮被点击

//- (void)randomBtnClick:(UIButton *)randomBtn
//{
//    [self playCoinSound];
//
//    [UIView animateWithDuration:0.1 animations:^{
//        randomBtn.transform = CGAffineTransformMakeScale(1.15, 1.15);
//
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.1 animations:^{
//            randomBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
//
//        } completion:^(BOOL finished) {
//            if (randomBtn.tag >= kUnlimitedBtnTag) {
//                if (self.delegate && [self.delegate respondsToSelector:@selector(selectTimeLimitedBtnAtIndex:)]) {
//                    [self.delegate selectTimeLimitedBtnAtIndex:randomBtn.tag - kUnlimitedBtnTag];
//                }
//            } else if (randomBtn.tag >= kTimeLimitedBtnTag) {
//                if (self.delegate && [self.delegate respondsToSelector:@selector(selectUnlimitedBtnAtIndex:)]) {
//                    [self.delegate selectUnlimitedBtnAtIndex:randomBtn.tag - kTimeLimitedBtnTag];
//                }
//            }
//        }];
//    }];
//}

- (void)timeLimitedBtnClick:(UIButton *)randomBtn
{
     NSString *soundstr = [[TMCache sharedCache]  objectForKey:@"PanetMineSound"];
    if ([soundstr isEqualToString:@"0"]) {
        
    }else
    {
         [self playCoinSound];
    }
    
    
        [UIView animateWithDuration:0.1 animations:^{
            randomBtn.transform = CGAffineTransformMakeScale(1.15, 1.15);
    
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                randomBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
    
            } completion:^(BOOL finished) {
//                if (randomBtn.tag >= kUnlimitedBtnTag) {
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTimeLimitedBtnAtIndex:)]) {
//                        [self.delegate selectTimeLimitedBtnAtIndex:randomBtn.tag - kUnlimitedBtnTag];
//                    }
//                } else if (randomBtn.tag >= kTimeLimitedBtnTag) {
//                    if (self.delegate && [self.delegate respondsToSelector:@selector(selectUnlimitedBtnAtIndex:)]) {
//                        [self.delegate selectUnlimitedBtnAtIndex:randomBtn.tag - kTimeLimitedBtnTag];
//                    }
//                }
                
                if (self.delegate && [self.delegate respondsToSelector:@selector(selectTimeLimitedBtnAtIndex:)]) {
                    [self.delegate selectTimeLimitedBtnAtIndex:randomBtn.tag];
                }
            }];
        }];
}


- (void)unlimitedBtnClick:(UIButton *)randomBtn
{
    NSString *soundstr = [[TMCache sharedCache]  objectForKey:@"PanetMineSound"];
    if ([soundstr isEqualToString:@"0"]) {
        
    }else
    {
        [self playCoinSound];
    }
    
    [UIView animateWithDuration:0.1 animations:^{
        randomBtn.transform = CGAffineTransformMakeScale(1.15, 1.15);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            randomBtn.transform = CGAffineTransformMakeScale(1.0, 1.0);
            
        } completion:^(BOOL finished) {
            //                if (randomBtn.tag >= kUnlimitedBtnTag) {
            //                    if (self.delegate && [self.delegate respondsToSelector:@selector(selectTimeLimitedBtnAtIndex:)]) {
            //                        [self.delegate selectTimeLimitedBtnAtIndex:randomBtn.tag - kUnlimitedBtnTag];
            //                    }
            //                } else if (randomBtn.tag >= kTimeLimitedBtnTag) {
            //                    if (self.delegate && [self.delegate respondsToSelector:@selector(selectUnlimitedBtnAtIndex:)]) {
            //                        [self.delegate selectUnlimitedBtnAtIndex:randomBtn.tag - kTimeLimitedBtnTag];
            //                    }
            //                }
            
            if (self.delegate && [self.delegate respondsToSelector:@selector(selectUnlimitedBtnAtIndex:)]) {
                [self.delegate selectUnlimitedBtnAtIndex:randomBtn.tag];
            }
        }];
    }];
}
#pragma mark - 按钮点击的声音
- (void)playCoinSound {
//   //创建SystemSoundID对象，用于绑定声音文件
//   SystemSoundID soundFileObj;
//    //获取声音文件的路径
//   NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"shouquzhishidou" ofType:@"wav"];
//    //将string转为url
//   NSURL *sourceUrl = [NSURL fileURLWithPath:sourcePath];
// //将声音文件和SystemSoundID绑定
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(sourceUrl), &soundFileObj);
//    //播放声音，但此方法只能播放30s以内的文件
//   AudioServicesPlaySystemSound(soundFileObj);
//    SystemSoundID soundFileObj;
//    NSString *sourcePath = [[NSBundle mainBundle] pathForResource:@"do" ofType:@"mp3"];
//    NSURL *sourceUrl = [NSURL fileURLWithPath:sourcePath];
//    AudioServicesCreateSystemSoundID((__bridge CFURLRef _Nonnull)(sourceUrl), &soundFileObj);
//    AudioServicesPlaySystemSound(soundFileObj);
    
 
            //
        NSURL *musicURL = [[NSBundle mainBundle] URLForResource:@"shouquzhishidou" withExtension:@"wav"];
        
        NSLog(@"musicURL=======%@",musicURL);
        
        [self play:musicURL];
    
}

-(void)play:(NSURL *)playPath{
    
    AVAudioSession *session = [AVAudioSession sharedInstance];
    [session setCategory:AVAudioSessionCategoryPlayback error:nil];
    [session setActive:YES error:nil];
    
    
    NSError *playerError;
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:playPath error:&playerError];
    _player.delegate = self;
    if (_player == NULL)
    {
        NSLog(@"fail to play audio :(");
        return;
    }
    //    [_player setNumberOfLoops:7];//循环播放12次
    // [_player setVolume:1];
    //    _player.volume = 1;
    [_player prepareToPlay];
    [_player play];
    
    
}


#pragma mark - 移除随机按钮

//- (void)removeRandomIndex:(NSInteger)index
//{
//    JXButton *randomBtn = self.randomBtnArr[index];
//
//    [UIView animateWithDuration:0.5 animations:^{
//        randomBtn.transform = CGAffineTransformMakeScale(0.01, 0.01);
////        randomBtn.hidden = YES;
////        randomBtn.alpha = 0.0;
//    } completion:^(BOOL finished) {
//        [randomBtn removeFromSuperview];
//        [self.randomBtnArrX removeObject:randomBtn];
//
//
//        if ([self.timeLimitedBtnArr containsObject:randomBtn]) {
//            [self.timeLimitedBtnArr removeObject:randomBtn];
//        } else if ([self.unlimitedBtnArr containsObject:randomBtn]) {
//            [self.unlimitedBtnArr removeObject:randomBtn];
//        }
//        if (self.timeLimitedBtnArr.count == 0 && self.unlimitedBtnArr.count == 0) {
//            if (self.delegate && [self.delegate respondsToSelector:@selector(allCollected)]) {
//                [self.delegate allCollected];
//            }
//        }
//    }];
//}

- (void)removeTimeLimitedIndex:(NSInteger)index
{
    JXButton *jxrandomBtn = [[JXButton alloc] init];
    for (int i= 0; i <self.timeLimitedBtnArr.count; i++) {
//        NSString *indexStr = [NSString stringWithFormat:@"%@",index];
         JXButton *randomBtn = self.timeLimitedBtnArr[i];
        if (randomBtn.tag == index) {
            jxrandomBtn = randomBtn;
        }
        
    }

    [UIView animateWithDuration:0.5 animations:^{
        jxrandomBtn.transform = CGAffineTransformMakeScale(0.01, 0.01);
//        randomBtn.hidden = YES;
//        randomBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [jxrandomBtn removeFromSuperview];
    

        [self.timeLimitedBtnArr removeObject:jxrandomBtn];
    
        if (self.timeLimitedBtnArr.count == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(TimeLimitedCollected)]) {
                [self.delegate TimeLimitedCollected];
            }
        }
    }];
}

- (void)removeunlimitedIndex:(NSInteger)index
{
    JXButton *jxrandomBtn = [[JXButton alloc] init];
    for (int i= 0; i <self.unlimitedBtnArr.count; i++) {
  
        JXButton *randomBtn = self.unlimitedBtnArr[i];
        if (randomBtn.tag == index) {
            jxrandomBtn = randomBtn;
        }
        
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        jxrandomBtn.transform = CGAffineTransformMakeScale(0.01, 0.01);
        //        randomBtn.hidden = YES;
        //        randomBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [jxrandomBtn removeFromSuperview];
        
        //        [self.randomBtnArrX removeObject:randomBtn];
        
        [self.unlimitedBtnArr removeObject:jxrandomBtn];
        
        if (self.unlimitedBtnArr.count == 0) {
            if (self.delegate && [self.delegate respondsToSelector:@selector(UnlimitedCollected)]) {
                [self.delegate UnlimitedCollected];
            }
        }
    }];
}

- (void)removeAllRandomBtn
{
    for (int i = 0; i < self.randomBtnArr.count; i ++) {
        UIButton *randomBtn = self.randomBtnArr[i];
        [randomBtn removeFromSuperview];
    }
    
    for (int i = 0; i < self.unlimitedBtnArr.count; i ++) {
        UIButton *randomBtn = self.unlimitedBtnArr[i];
        [randomBtn removeFromSuperview];
    }
    
    for (int i = 0; i < self.timeLimitedBtnArr.count; i ++) {
        UIButton *randomBtn = self.timeLimitedBtnArr[i];
        [randomBtn removeFromSuperview];
    }
    self.unlimitedBtnArr = [NSMutableArray array];
    self.timeLimitedBtnArr = [NSMutableArray array];
    self.randomBtnArr = [NSMutableArray array];
    self.randomBtnArrX = [NSMutableArray array];

//    self.centerPointArr = [NSMutableArray array];
    [self.centerPointArr removeAllObjects];
    
}


- (void)removeAllunlimiteBtn
{
//    for (int i = 0; i < self.randomBtnArr.count; i ++) {
//        UIButton *randomBtn = self.randomBtnArr[i];
//        [randomBtn removeFromSuperview];
//    }
    self.unlimitedBtnArr = [NSMutableArray array];
//    self.timeLimitedBtnArr = [NSMutableArray array];
    self.randomBtnArr = [NSMutableArray array];
    self.randomBtnArrX = [NSMutableArray array];
    
    self.centerPointArr = [NSMutableArray array];
}


- (void)removeAlltimeLimitedBtn
{
    //    for (int i = 0; i < self.randomBtnArr.count; i ++) {
    //        UIButton *randomBtn = self.randomBtnArr[i];
    //        [randomBtn removeFromSuperview];
    //    }
//    self.unlimitedBtnArr = [NSMutableArray array];
    self.timeLimitedBtnArr = [NSMutableArray array];
    self.randomBtnArr = [NSMutableArray array];
    self.randomBtnArrX = [NSMutableArray array];
    
    self.centerPointArr = [NSMutableArray array];
}

#pragma mark - 动画

- (void)animationScaleOnceWithView:(UIView *)view
{
    [UIView animateWithDuration:0.2 animations:^{
        view.transform = CGAffineTransformMakeScale(1.05, 1.05);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.2 animations:^{
            view.transform = CGAffineTransformMakeScale(1.0, 1.0);
        } completion:^(BOOL finished) {
        }];
    }];
}

- (void)animationUpDownWithView:(UIView *)view
{
    CALayer *viewLayer = view.layer;
    CGPoint position = viewLayer.position;
    CGPoint fromPoint = CGPointMake(position.x, position.y);
    CGPoint toPoint = CGPointZero;
    
    uint32_t typeInt = arc4random() % 100;
    CGFloat distanceFloat = 0.0;
    while (distanceFloat == 0) {
        distanceFloat = (6 + (int)(arc4random() % (9 - 7 + 1))) * 100.0 / 101.0;
    }
    if (typeInt % 2 == 0) {
        toPoint = CGPointMake(position.x, position.y - distanceFloat);
    } else {
        toPoint = CGPointMake(position.x, position.y + distanceFloat);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.removedOnCompletion = NO;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    animation.fromValue = [NSValue valueWithCGPoint:fromPoint];
    animation.toValue = [NSValue valueWithCGPoint:toPoint];
    animation.autoreverses = YES;
    CGFloat durationFloat = 0.0;
    while (durationFloat == 0.0) {
        durationFloat = 0.9 + (int)(arc4random() % (100 - 70 + 1)) / 31.0;
    }
    [animation setDuration:durationFloat];
    [animation setRepeatCount:MAXFLOAT];

    [viewLayer addAnimation:animation forKey:nil];
}

@end

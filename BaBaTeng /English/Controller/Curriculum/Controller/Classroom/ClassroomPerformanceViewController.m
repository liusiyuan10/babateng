//
//  ClassroomPerformanceViewController.m
//  BaBaTeng
//
//  Created by xyj on 2019/9/10.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import "ClassroomPerformanceViewController.h"
#import "BBTStudentProgressView.h"
#import "EnglishRequestTool.h"
#import "ClassroomPerformance.h"
#import "ClassroomPerformanceData.h"


@interface ClassroomPerformanceViewController ()<UIScrollViewDelegate>

@property(nonatomic, retain)UIScrollView *backScrollView;

@property(nonatomic, strong)ClassroomPerformanceData *performancedata;


@end

@implementation ClassroomPerformanceViewController

- (UIScrollView *)backScrollView
{
    if (!_backScrollView)
    {
        _backScrollView = [[UIScrollView alloc] init];
        
        
        _backScrollView.frame = CGRectMake(0, 0, kDeviceWidth, KDeviceHeight);
        _backScrollView.contentSize = CGSizeMake(0,KDeviceHeight+ 180);
        //
        _backScrollView.scrollEnabled = YES;
        _backScrollView.showsVerticalScrollIndicator =  NO;
        _backScrollView.showsHorizontalScrollIndicator = NO;
        
        _backScrollView.pagingEnabled = NO;
        
        _backScrollView.delegate = self;
        _backScrollView.bounces = YES;
        
        _backScrollView.backgroundColor = [UIColor whiteColor];
        _backScrollView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        
        [self.view addSubview:_backScrollView];
        
    }
    return _backScrollView;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"课堂表现";
    
//    [self LoadChlidView];
    
    [self GetClassroomPerformance];
    
    
}

- (void)GetClassroomPerformance
{
    
    [self startLoading];
    
    [EnglishRequestTool getteacherEvaluationCourseId:self.courseId success:^(ClassroomPerformance *respone) {
        
        [self stopLoading];
        
        if ([respone.statusCode isEqualToString:@"0"]) {
            self.performancedata = respone.data;
            
            [self LoadChlidView];
            
        }else{
            
            [self showToastWithString:respone.message];
        }
        
    } failure:^(NSError *error) {
        
    }];
}

- (void)LoadChlidView
{
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(16,24, kDeviceWidth-32, 23)];
    titleName.backgroundColor = [UIColor clearColor];

    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    titleName.font = [UIFont boldSystemFontOfSize:24.0f];
    
    titleName.text =  @"课堂表现";
    
    [self.backScrollView addSubview:titleName];
    
    
    UIView *OralexpressionView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(titleName.frame) + 24, kDeviceWidth - 32, 55)];
    
    [self setViewWithView:OralexpressionView titleName:@"口语表达力" Score:self.performancedata.oralExpression];
    
    [self.backScrollView addSubview:OralexpressionView];
    
    UIView *KnowledgereceptivityView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(OralexpressionView.frame) + 10, kDeviceWidth - 32, 55)];
    
    [self setViewWithView:KnowledgereceptivityView titleName:@"知识接受度" Score:self.performancedata.knowledgeAcceptance];
    
    [self.backScrollView addSubview:KnowledgereceptivityView];
    
    UIView *ClassroomcooperationView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(KnowledgereceptivityView.frame) + 10, kDeviceWidth - 32, 55)];
    
    [self setViewWithView:ClassroomcooperationView titleName:@"课堂配合度" Score:self.performancedata.classCooperation];
    
    [self.backScrollView addSubview:ClassroomcooperationView];
    
    UIView *ClassroomconcentrationView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(ClassroomcooperationView.frame) + 10, kDeviceWidth - 32, 55)];
    
    [self setViewWithView:ClassroomconcentrationView titleName:@"课堂专注度" Score:self.performancedata.classConcentration];
    
    [self.backScrollView addSubview:ClassroomconcentrationView];
    
    UIView *MemorypersistenceView = [[UIView alloc] initWithFrame:CGRectMake(16, CGRectGetMaxY(ClassroomconcentrationView.frame) + 10, kDeviceWidth - 32, 55)];
    
    [self setViewWithView:MemorypersistenceView titleName:@"记忆持久度" Score:self.performancedata.memoryPersistence];
    
    [self.backScrollView addSubview:MemorypersistenceView];
    
    UILabel *title1Name = [[UILabel alloc] initWithFrame:CGRectMake(16,CGRectGetMaxY(MemorypersistenceView.frame) + 33, kDeviceWidth-32, 23)];
    title1Name.backgroundColor = [UIColor clearColor];
    
    title1Name.textAlignment = NSTextAlignmentLeft;
    title1Name.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    title1Name.font = [UIFont boldSystemFontOfSize:24.0f];
    
    title1Name.text =  @"课堂记录";
    
    [self.backScrollView addSubview:title1Name];
    
    UIView *chinaView = [[UILabel alloc] init];
    chinaView.backgroundColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:0/255.0 alpha:0.1];
    

    chinaView.layer.cornerRadius = 15;
    chinaView.layer.masksToBounds = YES;
    
    [self.backScrollView addSubview:chinaView];
    
    
    
    UILabel *chinaTitleLabel = [[UILabel alloc] init];
    chinaTitleLabel.backgroundColor = [UIColor clearColor];
    
    chinaTitleLabel.textAlignment = NSTextAlignmentLeft;
    chinaTitleLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    chinaTitleLabel.font = [UIFont systemFontOfSize:14.0f];
//    chinaTitleLabel.layer.cornerRadius = 15;
//    chinaTitleLabel.layer.masksToBounds = YES;
    
    chinaTitleLabel.numberOfLines = 0;
    
    if (self.performancedata.cnEvaluateContent.length == 0) {
        chinaTitleLabel.text =  @"暂无记录";
        
        CGFloat memberRuleH = [self getLabelHeightWithText:@"暂无记录" width:kDeviceWidth - 32*2 font:14.0];//self.performancedata.remark
        
        chinaTitleLabel.frame = CGRectMake(16,16, kDeviceWidth-32*2, memberRuleH);
        
        
        [chinaView addSubview:chinaTitleLabel];
        
        
        
        chinaView.frame = CGRectMake(16,CGRectGetMaxY(title1Name.frame) + 24, kDeviceWidth-32, memberRuleH + 16*2 );
        
        CGFloat backScrollViewH = CGRectGetMaxY(chinaView.frame) + 80;
        
        self.backScrollView.contentSize = CGSizeMake(0, backScrollViewH);
    }
    else
    {
        chinaTitleLabel.text =  self.performancedata.cnEvaluateContent;
        
        CGFloat memberRuleH = [self getLabelHeightWithText:self.performancedata.cnEvaluateContent width:kDeviceWidth - 32*2 font:14.0];//self.performancedata.remark
        
        chinaTitleLabel.frame = CGRectMake(16,16, kDeviceWidth-32*2, memberRuleH);
        
        
        [chinaView addSubview:chinaTitleLabel];
        
        
        
        chinaView.frame = CGRectMake(16,CGRectGetMaxY(title1Name.frame) + 24, kDeviceWidth-32, memberRuleH + 16*2 );
        
        CGFloat backScrollViewH = CGRectGetMaxY(chinaView.frame) + 80;
        
        self.backScrollView.contentSize = CGSizeMake(0, backScrollViewH);
    }

    
//    UILabel *englishTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(16,CGRectGetMaxY(chinaTitleLabel.frame) + 16, kDeviceWidth-32, 50)];
//    englishTitleLabel.backgroundColor = [UIColor colorWithRed:255/255.0 green:128/255.0 blue:0/255.0 alpha:0.1];
//
//    englishTitleLabel.textAlignment = NSTextAlignmentLeft;
//    englishTitleLabel.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
//    englishTitleLabel.font = [UIFont systemFontOfSize:14.0f];
//    englishTitleLabel.layer.cornerRadius = 15;
//    englishTitleLabel.layer.masksToBounds = YES;
//
//    englishTitleLabel.text =  @"课堂记录";
//
//    [self.backScrollView addSubview:englishTitleLabel];
    
    

    
    
    
}

- (CGFloat)getLabelHeightWithText:(NSString *)text width:(CGFloat)width font: (CGFloat)font

{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil];
    

    return rect.size.height;
    
    
    
    
}



-(void)setViewWithView:(UIView *)view titleName:(NSString *)titlename Score:(CGFloat)score
{
    UILabel *titleName = [[UILabel alloc] initWithFrame:CGRectMake(0,0, kDeviceWidth-32, 13)];
    titleName.backgroundColor = [UIColor clearColor];
    
    titleName.textAlignment = NSTextAlignmentLeft;
    titleName.textColor = [UIColor colorWithRed:83/255.0 green:83/255.0 blue:83/255.0 alpha:1.0];
    titleName.font = [UIFont systemFontOfSize:14.0f];
    
    titleName.text =  titlename;
    
    [view addSubview:titleName];
    
    BBTStudentProgressView *progressView = [[BBTStudentProgressView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(titleName.frame) + 10, kDeviceWidth - 32 - 30, 30)];
    
    progressView.progress = score/10.0;

    [view addSubview:progressView];
    
    
    UILabel *titlesubName = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(progressView.frame),CGRectGetMaxY(titleName.frame) + 10, 30, 12)];
    titlesubName.backgroundColor = [UIColor clearColor];
    
    titlesubName.textAlignment = NSTextAlignmentRight;
    titlesubName.textColor = [UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1.0];
    titlesubName.font = [UIFont systemFontOfSize:12.0f];
    
    titlesubName.text =  @"10分";
    
    [view addSubview:titlesubName];
    
    
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

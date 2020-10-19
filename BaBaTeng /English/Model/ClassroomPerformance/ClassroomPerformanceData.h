//
//  ClassroomPerformanceData.h
//  BaBaTeng
//
//  Created by xyj on 2019/9/11.
//  Copyright © 2019 ShenzhenHiTech. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ClassroomPerformanceData : NSObject

//classConcentration    课堂专注度    number    @mock=5
//classCooperation    课堂配合度    number    @mock=5
//courseId    课程ID    number    @mock=4400
//createTime    创建时间    string    @mock=2019-09-10 10:40:11
//description    描述    string    @mock=afsdf

//evaluationId    主键ID    number    @mock=1
//knowledgeAcceptance    知识接受度    number    @mock=5
//memoryPersistence    记忆持久度    number    @mock=5
//oralExpression    口语表达力

@property (nonatomic, assign) CGFloat   classConcentration;
@property (nonatomic, assign) CGFloat   classCooperation;
@property (nonatomic, assign) CGFloat   memoryPersistence;
@property (nonatomic, assign) CGFloat   knowledgeAcceptance;
@property (nonatomic, assign) CGFloat   oralExpression;

@property (nonatomic, copy) NSString   *courseId;
@property (nonatomic, copy) NSString   *createTime;


//@property (nonatomic, copy) NSString   *description;

@property (nonatomic, copy) NSString   *enEvaluateContent;

@property (nonatomic, copy) NSString   *evaluationId;

@property (nonatomic, copy) NSString   *cnEvaluateContent;  //  顾问评价内容


@end

NS_ASSUME_NONNULL_END

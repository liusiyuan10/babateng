//
//  MultilevelMenu.m
//  MultilevelMenu
//
//  Created by gitBurning on 15/3/13.
//  Copyright (c) 2015年 BR. All rights reserved.
//

#import "MultilevelMenu.h"
#import "NewMultilevelTableViewCell.h"
#import "NewMultilevelCollectionViewCell.h"
#import "UIImageView+WebCache.h"
#import "Header.h"
#import "UIColor+Helper.h"
#import "UIColor+SNFoundation.h"
#import "NewCollectionHeader.h"

#define kCellRightLineTag 100
#define kImageDefaultName @"tempShop"
#define kMultilevelCollectionViewCell @"MultilevelCollectionViewCell"
#define kMultilevelCollectionHeader   @"CollectionHeader"//CollectionHeader
#define kScreenWidth [UIScreen mainScreen].bounds.size.width

#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface MultilevelMenu()

@property(strong,nonatomic ) UITableView * leftTablew;
@property(strong,nonatomic ) UICollectionView * rightCollection;
/**
 *  左边菜单栏图片的高亮和正常
 */
@property(strong,nonatomic) NSArray * normalImageArray;
@property(strong,nonatomic) NSArray * highlightImageArray;
@property (nonatomic,strong)NSArray *demoColors;

@property(assign,nonatomic) BOOL isReturnLastOffset;

@end
@implementation MultilevelMenu


-(instancetype)initWithFrame:(CGRect)frame WithData:(NSArray *)data withSelectIndex:(void (^)(NSInteger, NSInteger,NSInteger, id))selectIndex
{
    self=[super initWithFrame:frame];
    if (self) {
        if (data.count==0) {
            return nil;
        }
        
        _block=selectIndex;
        self.leftSelectColor=[UIColor orangeColor];
        self.leftSelectBgColor= [UIColor whiteColor];//[UIColor colorWithRed:0.933 green:0.933 blue:0.918 alpha:1];//[UIColor redColor];
        self.leftBgColor= [UIColor colorWithRGBHex:0xfbfafa];//UIColorFromRGB(0xF3F4F6);
        self.leftSeparatorColor=  UIColorFromRGB(0xE5E5E5);
        self.leftUnSelectBgColor= [UIColor colorWithRGBHex:0xfbfafa];//[UIColor colorWithRed:0.933 green:0.933 blue:0.918 alpha:1]; //UIColorFromRGB(0xF3F4F6);
        self.leftUnSelectColor= [UIColor lightGrayColor];
        
        _selectIndex=0;
        _allData=data;
        
        
        /**
         左边的视图
        */
        self.leftTablew=[[UITableView alloc] initWithFrame:CGRectMake(0, 0, kLeftWidth, frame.size.height-10)];
        self.leftTablew.dataSource=self;
        self.leftTablew.delegate=self;
        
        self.leftTablew.tableFooterView=[[UIView alloc] init];
        [self addSubview:self.leftTablew];
        self.leftTablew.backgroundColor= self.leftBgColor;
        if ([self.leftTablew respondsToSelector:@selector(setLayoutMargins:)]) {
            self.leftTablew.layoutMargins=UIEdgeInsetsZero;
        }
        if ([self.leftTablew respondsToSelector:@selector(setSeparatorInset:)]) {
            self.leftTablew.separatorInset=UIEdgeInsetsZero;
        }
        self.leftTablew.separatorColor=self.leftSeparatorColor;
        //self.leftTablew.separatorStyle = UITableViewCellSeparatorStyleNone;
        
        /**
         右边的视图
         */
        UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
        flowLayout.minimumInteritemSpacing=0.f;//左右间隔
        flowLayout.minimumLineSpacing=0.f;
        float leftMargin =0;
        self.rightCollection=[[UICollectionView alloc] initWithFrame:CGRectMake(kLeftWidth+leftMargin,0,kScreenWidth-kLeftWidth-leftMargin*2,frame.size.height-10) collectionViewLayout:flowLayout];
        
        self.rightCollection.delegate=self;
        self.rightCollection.dataSource=self;
        

        [self.rightCollection registerClass:[NewMultilevelCollectionViewCell class]forCellWithReuseIdentifier:kMultilevelCollectionViewCell];
        

        
        [self.rightCollection registerClass:[NewCollectionHeader class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kMultilevelCollectionHeader];
        
        [self addSubview:self.rightCollection];
        
      
        self.isReturnLastOffset=YES;
        
        self.rightCollection.backgroundColor= self.leftSelectBgColor;

        self.backgroundColor=self.leftSelectBgColor;
        
        
        
        
        self.normalImageArray  = @[@"ic_muying@2x",@"ic_meizhuang@2x",@"ic_jinkou@2x",@"ic_baojian@2x",@"ic_riyong@2x"];
       
        self.highlightImageArray  = @[@"ic_muying_hl@2x",@"ic_meizhuang_hl@2x",@"ic_jinkou_hl@2x",@"ic_baojian_hl@2x",@"ic_riyong_hl@2x"];
        
        [self doDemoColor];
    }
    return self;
}



- (void)doDemoColor
{
    UIColor *red =[UIColor colorWithRGBHex:0xffb220];//[UIColor colorWithRed:255 green:178 blue:32 alpha:1];
    UIColor *burgundy = [UIColor colorWithRGBHex:0xff2d65];//[UIColor colorWithRed:255 green:45 blue:101 alpha:1];
    UIColor *blue = [UIColor colorWithRGBHex:0xb22b2b];//[UIColor colorWithRed:178 green:43 blue:43 alpha:1];
    UIColor *aqua = [UIColor colorWithRGBHex:0x789d01];//[UIColor colorWithRed:120 green:157 blue:1 alpha:1];
    UIColor *aquaComplement =[UIColor colorWithRGBHex:0x2cb4ff];//[UIColor colorWithRed:44 green:180 blue:255 alpha:1];
  
    self.demoColors = @[red,burgundy,blue,aqua,aquaComplement];
   
  
}

///**
// *  左边菜单栏图片的高亮和正常以及文字颜色
// */



- (NSArray *)demoColors
{
    if (!_demoColors) {
        
        _demoColors = [NSArray array];
        
    }
    return _demoColors;
}


- (NSArray *)normalImageArray
{
    if (!_normalImageArray) {
        
        _normalImageArray = [NSArray array];
        
    }
    return _normalImageArray;
}

- (NSArray *)highlightImageArray
{
    if (!_highlightImageArray) {
        
        _highlightImageArray = [NSArray array];
        
    }
    return _highlightImageArray;
}

-(void)setNeedToScorllerIndex:(NSInteger)needToScorllerIndex{
    
        /**
         *  滑动到 指定行数
         */
        [self.leftTablew selectRowAtIndexPath:[NSIndexPath indexPathForRow:needToScorllerIndex inSection:0] animated:YES scrollPosition:UITableViewScrollPositionTop];

        _selectIndex=needToScorllerIndex;
        
        [self.rightCollection reloadData];

        _needToScorllerIndex=needToScorllerIndex;
}


-(void)setLeftBgColor:(UIColor *)leftBgColor{
    _leftBgColor=leftBgColor;
    self.leftTablew.backgroundColor=leftBgColor;
   
}
-(void)setLeftSelectBgColor:(UIColor *)leftSelectBgColor{
    
    _leftSelectBgColor=leftSelectBgColor;
    self.rightCollection.backgroundColor=leftSelectBgColor;
    
    self.backgroundColor=leftSelectBgColor;
}
-(void)setLeftSeparatorColor:(UIColor *)leftSeparatorColor{
    _leftSeparatorColor=leftSeparatorColor;
    self.leftTablew.separatorColor=leftSeparatorColor;
}
-(void)reloadData{
    
    [self.leftTablew reloadData];
    [self.rightCollection reloadData];
    
}
-(void)setLeftTablewCellSelected:(BOOL)selected withCell:(NewMultilevelTableViewCell*)cell cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UILabel * line=(UILabel*)[cell viewWithTag:kCellRightLineTag];
    if (selected) {
        cell.leftImage.highlighted = YES;
       
        line.backgroundColor=cell.backgroundColor;
//        cell.labTip.textColor= self.demoColors[indexPath.row];//  self.leftSelectColor;
        cell.labTip.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
        cell.backgroundColor=self.leftSelectBgColor;
        cell.rightLineImage.hidden = YES;
        
    }
    else{
        cell.labTip.textColor=[UIColor colorWithRed:117.0/255.0 green:117.0/255.0 blue:117.0/255.0 alpha:1];
        cell.backgroundColor=self.leftUnSelectBgColor;
        line.backgroundColor=_leftTablew.separatorColor;
        //cell.leftImage.hidden = YES;
        cell.leftImage.highlighted = NO;
        cell.rightLineImage.hidden = NO;
    }
   

}

#pragma mark---左边的tablew 代理
#pragma mark--deleagte
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    NSLog(@"self.allData.count%lu",(unsigned long)self.allData.count);
    return self.allData.count;
   
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString * Identifier=@"MultilevelTableViewCell";
    NewMultilevelTableViewCell * cell=[tableView dequeueReusableCellWithIdentifier:Identifier];
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    
    if (!cell) {
        //cell=[[NSBundle mainBundle] loadNibNamed:@"MultilevelTableViewCell" owner:self options:nil][0];
        cell = [[NewMultilevelTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:Identifier];

    }
    
    
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    rightMeun * title=self.allData[indexPath.row];
    cell.labTip.text=title.meunName;
    

    
    if (indexPath.row==self.selectIndex) {
       // NSLog(@"设置 点中");
        [self setLeftTablewCellSelected:YES withCell:cell cellForRowAtIndexPath:indexPath];
    }
    else{
        
        [self setLeftTablewCellSelected:NO withCell:cell cellForRowAtIndexPath:indexPath];

       // NSLog(@"设置 不点中");

    }
    

    
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        cell.layoutMargins=UIEdgeInsetsZero;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        cell.separatorInset=UIEdgeInsetsZero;
    }
    
    
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 50;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NewMultilevelTableViewCell * cell=(NewMultilevelTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];
   

    _selectIndex=indexPath.row;
    
    [self setLeftTablewCellSelected:YES withCell:cell cellForRowAtIndexPath:indexPath];

    rightMeun * title=self.allData[indexPath.row];
    
    [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    
    self.isReturnLastOffset=NO;
    
    
    [self.rightCollection reloadData];
    
    if (self.isRecordLastScroll) {
        [self.rightCollection scrollRectToVisible:CGRectMake(0, title.offsetScorller, self.rightCollection.frame.size.width, self.rightCollection.frame.size.height) animated:self.isRecordLastScrollAnimated];
    }
    else{
    
         [self.rightCollection scrollRectToVisible:CGRectMake(0, 0, self.rightCollection.frame.size.width, self.rightCollection.frame.size.height) animated:self.isRecordLastScrollAnimated];
   }
    

}


-(void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath{
    NewMultilevelTableViewCell * cell=(NewMultilevelTableViewCell*)[tableView cellForRowAtIndexPath:indexPath];


    [self setLeftTablewCellSelected:NO withCell:cell cellForRowAtIndexPath:indexPath];

    cell.backgroundColor=self.leftUnSelectBgColor;
}

#pragma mark---imageCollectionView--------------------------

//设置分区
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    
//    if (self.allData.count==0) {
//        return 0;
//    }
//    
//    rightMeun * title=self.allData[self.selectIndex];
//    
//     return   title.secondArray.count;
    
    return 1;
    
    
}
//每个分区上的元素个数
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    rightMeun * title=self.allData[self.selectIndex];
    
//    if (title.nextArray.count>0) {
//        
//        rightMeun *sub=title.nextArray[section];
//        
//        if (sub.nextArray.count==0)//没有下一级
//        {
//            return 1;
//        }
//        else
//            return sub.nextArray.count;
//        
//    }
//    else{
//    return title.nextArray.count;
//    }
    
    return title.secondArray.count;
    
    
}
//点击元素触发事件
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    rightMeun * title=self.allData[self.selectIndex];
    NSArray * list;
    
    
    
    rightMeun * meun;
    
    meun=title.nextArray[indexPath.section];
    
    if (meun.nextArray.count>0) {
        meun=title.nextArray[indexPath.section];
        list=meun.nextArray;
        meun=list[indexPath.row];
    }


    void (^select)(NSInteger left, NSInteger rightGroup,NSInteger right,id info) = self.block;
    
    select(self.selectIndex,indexPath.section,indexPath.row,meun);
    
}

////为collection view添加一个补充视图(页眉或页脚)
//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
//    
//    NSString *reuseIdentifier;
//    if ([kind isEqualToString: UICollectionElementKindSectionFooter ]){
//        reuseIdentifier = @"footer";
//    }else{
//        reuseIdentifier = kMultilevelCollectionHeader;
//    }
//    
//    rightMeun * title=self.allData[self.selectIndex];
//    
//    NewCollectionHeader *view =  [collectionView dequeueReusableSupplementaryViewOfKind :kind   withReuseIdentifier:reuseIdentifier   forIndexPath:indexPath];
//    view.backgroundColor = [UIColor whiteColor];
//    
//    if ([kind isEqualToString:UICollectionElementKindSectionHeader]){
//        
//        if (title.nextArray.count>0) {
//            
//            rightMeun * meun;
//            meun=title.nextArray[indexPath.section];
//            
//            view.headerTitile.text=meun.meunName;
////            view.headerImageView.backgroundColor = self.demoColors[self.selectIndex];
//            view.headerImageView.backgroundColor = [UIColor orangeColor];
//            
//            
//            
//        }
//        else{
//            view.headerTitile.text=@"暂无";
//        }
//    }
//    else if ([kind isEqualToString:UICollectionElementKindSectionFooter]){
//        view.backgroundColor = [UIColor lightGrayColor];
//        view.headerTitile.text = [NSString stringWithFormat:@"这是footer:%ld",(long)indexPath.section];
//    }
//    return view;
//}

//设置元素内容
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NewMultilevelCollectionViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:kMultilevelCollectionViewCell forIndexPath:indexPath];
    rightMeun * title=self.allData[self.selectIndex];

    NSArray * list;
    
    rightMeun * meun;

    meun=title.secondArray[indexPath.section];

//    if (meun.nextArray.count>0) {
//        meun=title.nextArray[indexPath.section];
//        list=meun.nextArray;
//        meun=list[indexPath.row];
//    }
    

    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:meun.urlName] placeholderImage:nil];
    cell.titile.text=meun.meunName;
//    cell.titile.text = @"sdfdf";
    cell.titile.textColor = [UIColor colorWithRed:51.0/255.0 green:51.0/255.0 blue:51.0/255.0 alpha:1];
    cell.titile.backgroundColor = [UIColor whiteColor];//UIColorFromRGB(0xF8FCF8);


    return cell;
    

}


//设置元素大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    return CGSizeMake((kDeviceWidth-100)/3, 100);
}
//设置元素的的大小框
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    
//    return UIEdgeInsetsMake(5, 5, 0, 5);
    
        return UIEdgeInsetsMake(0, 5, 0, 5);

}

//设置顶部的大小
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    CGSize size={kScreenWidth,20};
    return size;
}



#pragma mark---记录滑动的坐标
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if ([scrollView isEqual:self.rightCollection]) {

        
        self.isReturnLastOffset=YES;
    }
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if ([scrollView isEqual:self.rightCollection]) {
        
        rightMeun * title=self.allData[self.selectIndex];
        
        title.offsetScorller=scrollView.contentOffset.y;
        self.isReturnLastOffset=NO;
        
    }

 }

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if ([scrollView isEqual:self.rightCollection]) {
        
        rightMeun * title=self.allData[self.selectIndex];
        
        title.offsetScorller=scrollView.contentOffset.y;
        self.isReturnLastOffset=NO;
        
    }

}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if ([scrollView isEqual:self.rightCollection] && self.isReturnLastOffset) {
        rightMeun * title=self.allData[self.selectIndex];
        
        title.offsetScorller=scrollView.contentOffset.y;

        
    }
}



#pragma mark--Tools
-(void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delay * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end



@implementation rightMeun



@end

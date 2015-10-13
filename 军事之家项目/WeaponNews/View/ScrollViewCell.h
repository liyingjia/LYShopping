//
//  ScrollViewCell.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

typedef void (^SkipToNextView)(MainModel * model);

@interface ScrollViewCell : UITableViewCell<UIScrollViewDelegate>
{
    //数据源
    NSMutableArray *_images;
    UIScrollView *_backView;
    //图片信息说明
    UILabel *_imageContent;
    UIPageControl *_pageControl;
}
@property(nonatomic,strong)NSMutableArray *images;
@property(nonatomic,copy)SkipToNextView myBlock;

//初始化
-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
//填充数据
-(void)setDataToCellWithImages:(NSArray *)images jumpBlock:(SkipToNextView)block;

@end

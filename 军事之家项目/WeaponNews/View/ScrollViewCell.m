//
//  ScrollViewCell.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/8.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "ScrollViewCell.h"
#import "Factory.h"
#import "UIView+Addition.h"
#import "MainModel.h"
#import "UIImageView+WebCache.h"
#import "MainModel.h"
#import "AFNetworking.h"

@implementation ScrollViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self createView];
    }
    return self;
}

-(void)createView
{
    _backView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 160)];
    _backView.delegate = self;
    _backView.pagingEnabled = YES;
    [self.contentView addSubview:_backView];
    
    //用来显示图片信息
    _imageContent = [Factory createLabelWithTitle:nil frame:CGRectMake(0, _backView.height-30, _backView.width, 30) textColor:[UIColor whiteColor] fontSize:14.f];
    _imageContent.backgroundColor = RGBA(0, 0, 0, 0.6);
    [self.contentView addSubview:_imageContent];
    
}


-(void)setDataToCellWithImages:(NSMutableArray *)images jumpBlock:(SkipToNextView)block
{
    self.images = images;
    self.myBlock = block;
    for (int i=0; i<[self.images count]; i++) {
        UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(i*_backView.width, 0, _backView.width, _backView.height)];
        view.userInteractionEnabled = YES;
        view.tag = 101 + i;
        MainModel *model = self.images[i];
        [view sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed:@"listhead_icon_default"]];
        [_backView addSubview:view];
        _imageContent.text = model.title;
        [self addGestureToView:view];
    }
    [_backView setContentSize:CGSizeMake(_backView.width *[self.images count], 0)];
    [self createPageControl];
}



-(void)addGestureToView:(UIImageView *)imageView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClicked:)];
    [imageView addGestureRecognizer:tap];
}

-(void)viewClicked:(UITapGestureRecognizer *)gesture
{
//    NSLog(@"tag:%ld",gesture.view.tag);
    if(self.myBlock){
        MainModel *model =  self.images[gesture.view.tag-101];
        self.myBlock(model);
    }
}

-(void)createPageControl
{
    //创建pageControl
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, _backView.height-50, _backView.width, 20)];
    _pageControl.numberOfPages = self.images.count;
    _pageControl.currentPage = 0;
    _pageControl.hidesForSinglePage = YES;
    _pageControl.backgroundColor = [UIColor clearColor];
//    _pageControl.userInteractionEnabled = NO;
    [self.contentView addSubview:_pageControl];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.width;
    MainModel *model = self.images[page];
    _imageContent.text = model.title;
    _pageControl.currentPage = page;
}



- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

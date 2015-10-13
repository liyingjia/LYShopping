//
//  ADView.m
//  LYShop
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "ADView.h"
#import "AFNetworking.h"
#import "MainModel.h"
#import "UIImageView+WebCache.h"
#include "WebViewController.h"
#import "BrandDetailModel.h"


@implementation ADView
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSMutableArray *_scrollArr;
    NSMutableArray *_dataArr;
    NSTimer *_timer;
    AFHTTPRequestOperationManager *_manager;
    MainModel *_model;
    NSInteger _count;
    BOOL _isTimeUp;
}

-(id)initWithFrame:(CGRect)frame block:(SkipToView)block
{
    if (self = [super initWithFrame:frame]) {
        self.myBlock = block;
        [self createHttpRequest];
        
    }
    return self;
}
#pragma mark - 创建连接
-(void)createHttpRequest
{
    _scrollArr = [[NSMutableArray alloc] init];
    _dataArr = [[NSMutableArray alloc] init];
    _model = [[MainModel alloc] init];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
   
    [self downloadDataWithUrl:kHomeUrl];
}
#pragma mark - 下载数据
-(void)downloadDataWithUrl:(NSString *)url
{
    __weak typeof(self)weakSelf = self;
    [_manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *list = dict[@"result"][@"toplst"];
        for (NSDictionary *item in list) {
            [_model setValuesForKeysWithDictionary:item];
            [_dataArr addObject:_model.appImgUrl];
            [_scrollArr addObject:_model.url];
        }
        [weakSelf createView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 创建视图
-(void)createView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth*130/320)];
    for (int i=0; i<_dataArr.count+2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i, 0, ScreenWidth, ScreenWidth*130/320)];
        if (i==0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[_dataArr.count-1]] placeholderImage:[UIImage imageNamed: @"homebg"]];
        }else if (i==_dataArr.count+1){
            [imageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[0]] placeholderImage:[UIImage imageNamed: @"homebg"]];
        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[i-1]] placeholderImage:[UIImage imageNamed: @"homebg"]];
//             NSLog(@"df:%@",_dataArr[i-1]);
        }
       
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    //设置宽度
    _scrollView.contentSize = CGSizeMake((_dataArr.count+2) *ScreenWidth, ScreenWidth*130/320);
    //设置默认位置
    [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
    _count = 1;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, ScreenWidth*100/320, ScreenWidth, 30)];
    _pageControl.numberOfPages = _dataArr.count;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];
    
     _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
    _isTimeUp = NO;
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [_timer setFireDate:[NSDate distantPast]];
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(animalMoveImage) userInfo:nil repeats:YES];
}

#pragma mark - 滚动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollView.contentOffset.x == 0) {
        [_scrollView setContentOffset:CGPointMake(ScreenWidth*_dataArr.count, 0)];
        _count = _dataArr.count;
        _pageControl.currentPage = (_pageControl.currentPage-1)%_dataArr.count;
        
    } else if(_scrollView.contentOffset.x == ScreenWidth*(_dataArr.count+1)){
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
        _count = 1;
        _pageControl.currentPage = (_pageControl.currentPage+1)%_dataArr.count;
    }
//    if (!_isTimeUp) {
//        [_timer setFireDate:[NSDate dateWithTimeIntervalSinceNow:2]];
//    }
//    _isTimeUp = NO;
}
#pragma mark - 添加的手势 点击事件
-(void)tapClick
{
    NSInteger page =  _pageControl.currentPage;
    NSString *url = _scrollArr[page];
    if (self.myBlock) {
        self.myBlock(url);
    }
}

#pragma mark - 定时器事件
-(void)animalMoveImage
{
    if (_count == _dataArr.count+1) {
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
        _count = 1;
        _pageControl.currentPage = _count;
    }
    _count ++;
    [_scrollView setContentOffset:CGPointMake(ScreenWidth*_count, 0) animated:YES];

    _pageControl.currentPage = (_count-1)%_dataArr.count;
    
    _isTimeUp = YES;
    
}

-(void)dealloc
{
    [_timer invalidate];
}


@end
























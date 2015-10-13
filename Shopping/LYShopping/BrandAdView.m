//
//  BrandAdView.m
//  LYShopping
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BrandAdView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "BrandDetailModel.h"


@implementation BrandAdView
{
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSMutableArray *_scrollArr;
    NSMutableArray *_dataArr;
    AFHTTPRequestOperationManager *_manager;
    NSInteger _count;
}

-(id)initWithId:(NSString *)productId
{
    if (self = [super init]) {
        self.productId = productId;
        [self createHttpRequest];
    }
    return self;
}
#pragma mark - 创建连接
-(void)createHttpRequest
{
    _scrollArr = [[NSMutableArray alloc] init];
    _dataArr = [[NSMutableArray alloc] init];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [self downloadDataWithUrl:kCategoryDetail1];
}
#pragma mark - 下载数据
-(void)downloadDataWithUrl:(NSString *)url
{
    __weak typeof(self)weakSelf = self;
    //productid=%@&noStock=1&v=2.0"
//    NSLog(@"fs:%@",self.productId);
    NSDictionary *dict = @{@"productid":self.productId,@"noStock":@"1",@"v":@"2.0"};
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *list = dict[@"result"][@"ProductsMImages"];
        for (int i=0;i<list.count;i++) {
            [_dataArr addObject:list[i]];
        }
        [weakSelf createView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

#pragma mark - 创建视图
-(void)createView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/2)];
    for (int i=0; i<_dataArr.count+2; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth*i+ScreenWidth/6, 0, ScreenWidth*2/3, ScreenHeight/2)];
        if (i==0) {
            [imageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[_dataArr.count-1]] placeholderImage:[UIImage imageNamed: @"detailbg"]];
        }else if (i==_dataArr.count+1){
            [imageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[0]] placeholderImage:[UIImage imageNamed: @"detailbg"]];
        }else{
            [imageView sd_setImageWithURL:[NSURL URLWithString:_dataArr[i-1]] placeholderImage:[UIImage imageNamed: @"detailbg"]];
        }
        
        imageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick)];
        [imageView addGestureRecognizer:tap];
        [_scrollView addSubview:imageView];
    }
    //设置宽度
    _scrollView.contentSize = CGSizeMake((_dataArr.count+2) *ScreenWidth, ScreenHeight/2);
    //设置默认位置
    [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
    _count = 1;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.bounces = NO;
    _scrollView.delegate = self;
    [self addSubview:_scrollView];
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(10, ScreenHeight/2-30, ScreenWidth, 30)];
    _pageControl.numberOfPages = _dataArr.count;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor grayColor];
    _pageControl.currentPageIndicatorTintColor = [UIColor redColor];
    [self addSubview:_pageControl];

}
#pragma mark - 滚动结束
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
//    if (_count == _dataArr.count+1) {
//        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
//        _count = 1;
//        _pageControl.currentPage = _count;
//    }
//    _count ++;
//    [_scrollView setContentOffset:CGPointMake(ScreenWidth*_count, 0) animated:YES];
//
//    _pageControl.currentPage = (_count-1)%_dataArr.count;
    
    if (_scrollView.contentOffset.x == 0) {
        [_scrollView setContentOffset:CGPointMake(_dataArr.count*ScreenWidth, 0)];
    }else if(_scrollView.contentOffset.x == (_dataArr.count+1)*ScreenWidth){
        [_scrollView setContentOffset:CGPointMake(ScreenWidth, 0)];
    }
    _pageControl.currentPage = _scrollView.contentOffset.x/ScreenWidth-1;
}


#pragma mark - 添加的手势 点击事件
-(void)tapClick
{
   // NSInteger page =  _pageControl.currentPage;
}










@end

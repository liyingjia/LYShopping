//
//  ContainerViewController.m
//  ContainerDemo
//
//  Created by qianfeng on 15/3/3.
//  Copyright (c) 2015年 WeiZhenLiu. All rights reserved.
//

#import "ContainerViewController.h"
#import "Topbar.h"
#import "ViewWillShow.h"

@interface ContainerViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) Topbar *topbar;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, strong)UIImageView *imageView;
@end

@implementation ContainerViewController

- (id)initWithViewControllers:(NSArray *)viewControllers {
    if (self = [super init]) {
        _viewControllers = viewControllers;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.backgroundColor = [UIColor whiteColor];
}

- (Topbar *)topbar {
    if (!_topbar) {
        _topbar = [[Topbar alloc] initWithFrame:CGRectMake(0, [[UIApplication sharedApplication] statusBarFrame].size.height+50, CGRectGetWidth(self.view.frame), kTopbarHeight)];
//        _topbar.backgroundColor = [UIColor blueColor];
        _topbar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed: @"third_menu_bar_bg"]];
        __block ContainerViewController *_self = self;
        _topbar.blockHandler = ^(NSInteger currentPage) {
            [_self setCurrentPage:currentPage];
        };
        [self.view addSubview:_topbar];
        [self createImageView];
    }
    return _topbar;
}

-(void)createImageView
{
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, self.view.frame.size.width,50)];
    self.imageView.image = [UIImage imageNamed:@"banner"];
    self.imageView.userInteractionEnabled = YES;
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(ScreenWidth-120, 10, 100, 30)];
    imageView.image = [UIImage imageNamed:self.imageName];
    [self.imageView addSubview:imageView];
    
    UIButton *backBtn = [Factory createButtonWithTitle:nil frame:CGRectMake(20, 10, 40, 30) target:self selector:@selector(toBackView:)];
    [backBtn setImage:[UIImage imageNamed: @"back_btn_h"] forState:UIControlStateNormal];
    [self.imageView addSubview:backBtn];
    [self.view addSubview:self.imageView];
}

-(void)toBackView:(UIButton *)button
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.topbar.frame), CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-kTopbarHeight)];
        _scrollView.backgroundColor = [UIColor whiteColor];
        _scrollView.delegate                       = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator   = NO;
        _scrollView.bounces                        = NO;
        _scrollView.pagingEnabled                  = YES;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    _viewControllers = [NSArray arrayWithArray:viewControllers];
    CGFloat x = 0.0;
    for (UIViewController *viewController in _viewControllers) {
        [viewController willMoveToParentViewController:self];
        viewController.view.frame = CGRectMake(x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
        [self.scrollView addSubview:viewController.view];
        [viewController didMoveToParentViewController:self];
        
        x += CGRectGetWidth(self.scrollView.frame);
        _scrollView.contentSize   = CGSizeMake(x, _scrollView.frame.size.width);
    }
    
    self.topbar.titles = [_viewControllers valueForKey:@"title"];
}

- (void)setCurrentPage:(NSInteger)currentPage {
    _currentPage = currentPage;
    [self.scrollView setContentOffset:CGPointMake(_currentPage*_scrollView.frame.size.width, 0) animated:NO]; //
}

- (void)layoutSubViews
{
    CGFloat x = 0.0;
    for (UIViewController *viewController in self.viewControllers) {
        viewController.view.frame = CGRectMake(x, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        x += CGRectGetWidth(self.scrollView.frame);
    }
    self.scrollView.contentSize   = CGSizeMake(x, _scrollView.frame.size.width);
    //self.scrollView.contentOffset = CGPointMake(_scrollView.frame.size.width, 0);
}

#pragma mark - <UIScrollViewDelegate>
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    NSInteger currentPage = _scrollView.contentOffset.x / _scrollView.frame.size.width;
    _topbar.currentPage   = currentPage;
    _currentPage = currentPage;
    [self callbackSubViewControllerWillShow];
}

// call back if scroll to special view controller
- (void)callbackSubViewControllerWillShow {
    UIViewController<ViewWillShow> *controller = [self.viewControllers objectAtIndex:self.currentPage];
    if ([controller conformsToProtocol:@protocol(ViewWillShow)] && [controller respondsToSelector:@selector(viewWillShow)]) {
        [controller viewWillShow];
    }
}

@end




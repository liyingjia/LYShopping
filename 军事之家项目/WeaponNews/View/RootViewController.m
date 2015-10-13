//
//  RootViewController.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "RootViewController.h"
#import "HotCell.h"
#import "MainModel.h"
#import "AFNetworking.h"
#import "LZXHelper.h"
#import "JHRefresh.h"
#import "UIImageView+WebCache.h"
#import "ScrollViewCell.h"
#import "FunsCell.h"
#import "PhotosCell.h"
#import "BookCell.h"
#import "BookModel.h"
#import "WebViewController.h"
#import "DDMenuController.h"

@interface RootViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    UITableView *_tableView;
    AFHTTPRequestOperationManager *_manager;
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    //图片信息说明
    UILabel *_imageContent;
    UIView *_view;
}
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)NSMutableArray *imagesArr;
@property(nonatomic,strong)NSMutableArray *bookArr;
@property(nonatomic,assign)BOOL isRefresh;
@property(nonatomic,assign)BOOL isLoadingMore;
@property(nonatomic,strong)UIScrollView *scrollView;
@property(nonatomic,strong)UIPageControl *pageControl;

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self initData];
    [self createView];
    [self firstDownLoad];
//    [self createTableViewHeaderView];
    [self createRefreshView];
}


-(void)initData
{
    self.dataArr = [[NSMutableArray alloc] init];
    self.imagesArr = [[NSMutableArray alloc] init];
    self.bookArr = [[NSMutableArray alloc] init];
}

-(void)createView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-70-35) style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView setSeparatorColor:[UIColor grayColor]];
//    [self.view addSubview:self.tableView];
    
    //注册cell 如果创建的有xib 就用这种方法注册
    [self.tableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:@"HotCell"];
    //如果没用创建xib  就用这种方式 注册
    [self.tableView registerClass:[ScrollViewCell class] forCellReuseIdentifier:@"ScrollViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"PhotosCell" bundle:nil] forCellReuseIdentifier:@"PhotosCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"FunsCell" bundle:nil] forCellReuseIdentifier:@"FunsCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookCell" bundle:nil] forCellReuseIdentifier:@"BookCell"];
}
#pragma mark -创建tableView头视图
-(void)createTableViewHeaderView
{
    if (self.imagesArr.count!=0) {
         [self createScrollView:self.imagesArr];
    }
    [self.view addSubview:self.tableView];
}
#pragma mark -第一次加载
-(void)firstDownLoad
{
    self.isRefresh = NO;
    self.isLoadingMore = NO;
    self.page = 1;
    self.requestUrl = [NSString stringWithFormat:kMainUrl,self.action,self.sa];
    [self addTaskUrl:self.requestUrl isRefresh:NO];
}
#pragma mark -获取数据
-(void)addTaskUrl:(NSString *)url isRefresh:(BOOL)isRefresh
{
    //显示特效
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"下载数据" status:@"loading..."];

    //缓存
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[LZXHelper getFullPathWithFile:url]];
    //文件是否超时  1小时
    BOOL isTimerOut = [LZXHelper isTimeOutWithFile:url timeOut:60*60];
    ////走本地满足3个条件 1.缓存文件存在2.不是刷新 3.没有超时
    if ((isExist == YES)&&(isRefresh==NO)&&(isTimerOut == NO)) {
        //读缓存
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:url]];
        //解析
        NSDictionary *item = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *head = item[@"head"];
        [self.imagesArr removeAllObjects];
        //取出滚动视图的图片资源
        for (NSDictionary *dict in head) {
            MainModel *model = [[MainModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [self.imagesArr addObject:model];
        }
        //判断是否为读书页面  读书界面数据为嵌套数组
        [self.dataArr removeAllObjects];
        if ([self.sa isEqualToString:@"dushu"]) {
            NSArray *list = item[@"list"];
            for (NSDictionary *dict in list) {
                MainModel *model = [[MainModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                NSMutableArray *images = [[NSMutableArray alloc] init];
                NSArray *itemList = list[0][@"list"];
                for (NSDictionary *dict in itemList) {
                    BookModel *bookModel = [[BookModel alloc] init];
                    [bookModel setValuesForKeysWithDictionary:dict];
                    [images addObject:bookModel];
                }
                model.list = images;
                [self.dataArr addObject:model];
            }
        }else{
            NSArray *list = item[@"list"];
            for (NSDictionary *dict in list) {
                MainModel *model = [[MainModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [self.dataArr addObject:model];
            }
        }
        [self createTableViewHeaderView];
        [self.tableView reloadData];
        [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载数据"];
        [self endRefresh];
       
        return;
    }
    
    __weak typeof(self) weakSelf = self;
    //拼接参数
    NSDictionary *dict = @{@"offset":[NSString stringWithFormat:@"%ld",(weakSelf.page-1)*20],@"count":@"20",@"uid":@"13907332",@"platform":@"a",@"mobile":@"GT-S7562i",@"pid":@"10106",@"e":@"90fff795f0a1f0daecf160e0606761b9"};
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //获取网络数据
    [_manager POST:weakSelf.requestUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            //判断当前页是否是第1页
            if (weakSelf.page == 1) {
                //从缓存中加载第一页
               [weakSelf.dataArr removeAllObjects];
                NSData *data=(NSData *)responseObject;
                NSString *filePath=[LZXHelper getFullPathWithFile:url];
                [data writeToFile:filePath atomically:YES];
            }
            NSDictionary *item = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *head = item[@"head"];
            [weakSelf.imagesArr removeAllObjects];
           // 取出滚动视图的图片资源
            for (NSDictionary *dict in head) {
                MainModel *model = [[MainModel alloc] init];
                [model setValuesForKeysWithDictionary:dict];
                [weakSelf.imagesArr addObject:model];
            }
           //判断是否为读书页面  读书界面数据为嵌套数组
            if ([weakSelf.sa isEqualToString:@"dushu"]) {
                NSArray *list = item[@"list"];
                for (NSDictionary *dict in list) {
                    MainModel *model = [[MainModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    NSMutableArray *images = [[NSMutableArray alloc] init];
                    NSArray *itemList = list[0][@"list"];
                    for (NSDictionary *dict in itemList) {
                        BookModel *bookModel = [[BookModel alloc] init];
                        [bookModel setValuesForKeysWithDictionary:dict];
                        [images addObject:bookModel];
                    }
                    model.list = images;
                    [weakSelf.dataArr addObject:model];
                }
            }else{
                NSArray *list = item[@"list"];
                for (NSDictionary *dict in list) {
                     MainModel *model = [[MainModel alloc] init];
                    [model setValuesForKeysWithDictionary:dict];
                    [weakSelf.dataArr addObject:model];
                }
            }
            [self createTableViewHeaderView];
            [weakSelf.tableView reloadData];
            [weakSelf endRefresh];
            //关闭特效
            [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载数据"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"连接失败");
        [weakSelf endRefresh];
        //关闭特效
        [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载数据"];
    }];
}
#pragma -mark 创建滚动视图
-(void)createScrollView:(NSMutableArray *)arr
{
    _view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight/4)];
    self.scrollView=[[UIScrollView alloc]initWithFrame:_view.bounds];
    _imageContent = [Factory createLabelWithTitle:@"" frame:CGRectMake(0, _view.height-30, _view.width,30) textColor:[UIColor whiteColor]];
    _imageContent.backgroundColor = RGBA(0, 0, 0, 0.6);
    
    for(NSInteger i=0;i<arr.count;i++){
        MainModel *model=arr[i];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.scrollView.bounds.size.width*i, 0, ScreenWidth, self.scrollView.bounds.size.height)];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed:@"listhead_icon_default"]];
        imageView.userInteractionEnabled = YES;
        imageView.tag = 101+i;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClieck:)];
        [imageView addGestureRecognizer:tap];
        _imageContent.text = model.title;
        [self.scrollView addSubview:imageView];
    }
    self.scrollView.contentSize=CGSizeMake(self.imagesArr.count*self.scrollView.width, self.scrollView.height);
    self.scrollView.contentOffset=CGPointMake(0, 0);
    self.scrollView.bounces=NO;
    self.scrollView.pagingEnabled=YES;
    self.scrollView.delegate=self;
    
    _view.backgroundColor=[UIColor grayColor];
    
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0,_imageContent.top-20, ScreenWidth, ScreenHeight/568*20)];
    self.pageControl.numberOfPages = self.imagesArr.count;
    self.pageControl.currentPageIndicatorTintColor=[UIColor orangeColor];
    self.pageControl.hidesForSinglePage = YES;
//    self.pageControl.currentPage = 0;
    [self.pageControl addTarget:self action:@selector(pageControl:) forControlEvents:UIControlEventValueChanged];
    
     [_view addSubview:self.scrollView];
    [_view addSubview:self.pageControl];
    [_view addSubview:_imageContent];
    self.tableView.tableHeaderView=_view;
    [self.tableView reloadData];
}
#pragma -mark 滚动视图点击事件
-(void)tapClieck:(UITapGestureRecognizer *)gesture
{
    MainModel *model = self.dataArr[gesture.view.tag-101];
    WebViewController *web = [[WebViewController alloc] initWithModel:model action:self.action];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
    NSInteger i = 0;
    i++;
    if (i==1) {
        self.isReturn = YES;
    }else{
        self.isReturn = NO;
        i = 0;
    }
    [self presentViewController:nav animated:YES completion:nil];
}

- (void)pageControl:(UIPageControl *)page{
    [_scrollView setContentOffset:CGPointMake(self.pageControl.currentPage*ScreenWidth, 0) animated:YES];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    int page = scrollView.contentOffset.x/scrollView.width;
    if (self.imagesArr.count != 0) {
        MainModel *model = self.imagesArr[page];
        _imageContent.text = model.title;
        _pageControl.currentPage = page;
    }
}

#pragma -mark 创建刷新视图
-(void)createRefreshView
{
    __weak typeof(self) weakSelf = self;
    [self.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefresh) {
            return;
        }
        weakSelf.isRefresh = YES;
        weakSelf.page = 1;
        [weakSelf addTaskUrl:weakSelf.requestUrl isRefresh:YES];
    }];
    
    [self.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadingMore || [weakSelf.sa isEqualToString:@"dushu"]) {
            return;
        }
        weakSelf.isLoadingMore = YES;
        weakSelf.page ++;
        [weakSelf addTaskUrl:weakSelf.requestUrl isRefresh:YES];
    }];
}
#pragma -mark 结束刷新
-(void)endRefresh
{
    if (self.isRefresh) {
        self.isRefresh = NO;
        [self.tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadingMore) {
        self.isLoadingMore = NO;
        [self.tableView footerEndRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UITableViewDelegate 协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;
    MainModel *model = self.dataArr[indexPath.row];
    
    if ([model.icon componentsSeparatedByString:@","].count==4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"FunsCell" forIndexPath:indexPath];
        [(FunsCell *)cell showDataToCell:model];
        
    }else if(([self.sa isEqualToString:@"tuba"]||[self.sa isEqualToString:@"youji"]) && [model.icon componentsSeparatedByString:@","].count!=4){
        cell = [tableView dequeueReusableCellWithIdentifier:@"PhotosCell" forIndexPath:indexPath];
        [(PhotosCell *)cell showDataToCell:model];
    
    }else if ([self.sa isEqualToString:@"dushu"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"BookCell" forIndexPath:indexPath];
        [(BookCell *)cell showDataToCell:model.list];
      
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell" forIndexPath:indexPath];
        [(HotCell *)cell showDataToCell:model];
    }
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.sa isEqualToString:@"tuba"]||[self.sa isEqualToString:@"youji"]){
        return 200.f;
    }else if ([self.sa isEqualToString:@"dushu"]){
        return 357.f;
    }
    return 90.f;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.sa isEqualToString:@"dushu"]) {
        if (self.dataArr.count !=0) {
            MainModel *model = self.dataArr[0];
            return model.title;
        }
    }
    return nil;
}



-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if ([self.sa isEqualToString:@"dushu"]) {
        return;
    }else{
        MainModel *model = self.dataArr[indexPath.row];
        [self skipToWebView:model];
    }
}

-(void)skipToWebView:(MainModel *)model
{
    WebViewController *web = [[WebViewController alloc] initWithModel:model action:self.action];
    if ([self.sa isEqualToString:@"tuba"]||[self.sa isEqualToString:@"youji"]) {
        NSArray *images = [model.icon componentsSeparatedByString:@","];
        [web showDateWithImages:images];
    }
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
    NSInteger i = 0;
    i++;
    if (i==1) {
        self.isReturn = YES;
    }else{
        self.isReturn = NO;
        i = 0;
    }
    
    [self presentViewController:nav animated:YES completion:nil];
//    [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
}

#pragma mark - 视图将要出现时 判断是否是从 webView返回来的
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    CGRect frame = self.tableView.frame;
    //如果是 就设置 tableView的 y偏移量
    if (self.isReturn) {
        frame.origin.y = 105;
    }
    self.tableView.frame = frame;
    [self.tableView reloadData];
    if ([self.sa isEqualToString:@"tuba"]||[self.sa isEqualToString:@"youji"]||[self.sa isEqualToString:@"dushu"]) {
        [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
}

@end

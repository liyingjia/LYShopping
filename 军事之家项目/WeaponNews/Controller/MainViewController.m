//
//  MainViewController.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "MainViewController.h"
#import "JHRefresh.h"
#import "MainCell.h"
#import "MainModel.h"
#import "LZXHelper.h"
#import "SubCell.h"
#import "UIImageView+AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "WebViewController.h"
#import "SettingViewController.h"
#import "CategoryViewController.h"



@interface MainViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_dataArr;
    NSInteger _page;
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,assign)BOOL isRefresh;
@property (nonatomic,assign)BOOL isLoadingMore;
@property (nonatomic)UITableView *tableView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"兵器之家";
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationController.navigationBar.translucent = NO;
//    [self.navigationController.navigationBar setBarTintColor:[UIColor cyanColor]];
    self.navigationController.navigationBar.tintColor = [UIColor orangeColor];
}

#pragma mark - 初始化数据
-(void)initData
{
    _dataArr = [[NSMutableArray alloc] init];
    self.action = @"top";
    self.sa = @"home_top";
    self.page = 1;
    self.requestUrl = [NSString stringWithFormat:kMainUrl,self.action,self.sa];
    [self addTaskUrl:self.requestUrl isRefresh:NO];
}

#pragma mark - 创建视图
-(void)createView
{
    //设置按钮
    UIBarButtonItem *rightSet=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"setting_btn_h"] style:UIBarButtonItemStylePlain target:self action:@selector(toSowSettingView)];
    self.navigationItem.rightBarButtonItem=rightSet;
    
    //创建TableView
    [self createTableView];
    //添加刷新控件
    [self createRefreshView];
}

#pragma mark - 设置界面
-(void)toSowSettingView
{
    SettingViewController *set = [[SettingViewController alloc] init];
    [self.navigationController pushViewController:set animated:YES];
}

-(void)createTableView
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
   
    [_tableView registerNib:[UINib nibWithNibName:@"MainCell" bundle:nil] forCellReuseIdentifier:@"MainCell"];
    [_tableView registerNib:[UINib nibWithNibName:@"SubCell" bundle:nil] forCellReuseIdentifier:@"SubCell"];
     [self.view addSubview:_tableView];
}

#pragma mark - 下载数据
-(void)addTaskUrl:(NSString *)url isRefresh:(BOOL)isRefresh
{
    
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"下载数据" status:@"loading..."];
    
    //缓存
    BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:[LZXHelper getFullPathWithFile:url]];
    BOOL isTimerOut = [LZXHelper isTimeOutWithFile:[LZXHelper getFullPathWithFile:url] timeOut:60*60];
    if ((isExist == YES)&&(isRefresh==NO)&&(isTimerOut == NO)) {
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:url]];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *temp = dict[@"list"];
        [self.dataArr removeAllObjects];
        NSMutableArray *arr;
        for (int i=0;i<temp.count;i++) {
            NSDictionary *itemDict = temp[i];
            MainModel *model = [[MainModel alloc] init];
            [model setValuesForKeysWithDictionary:itemDict];
            if (i % 5==0) {
                arr = [[NSMutableArray alloc] init];
                [self.dataArr addObject:model];
            }else{
                [arr addObject:model];
                if (arr.count == 4) {
                    [self.dataArr addObject:arr];
                }
            }
        }
        [self.tableView reloadData];
        [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载数据"];
        [self endRefresh];
     return;
    }
    __weak typeof(self) weakSelf = self;
    NSDictionary *dict = @{@"offset":[NSString stringWithFormat:@"%ld",(weakSelf.page-1)*10],@"count":@"10",@"uid":@"13907332",@"platform":@"a",@"mobile":@"GT-S7562i",@"pid":@"10106",@"e":@"90fff795f0a1f0daecf160e0606761b9"};
    
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    //从网络获取数据
    [_manager POST:weakSelf.requestUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (weakSelf.page == 1) {
                [weakSelf.dataArr removeAllObjects];
                NSData *data=(NSData *)responseObject;
                NSString *filePath=[LZXHelper getFullPathWithFile:url];
                [data writeToFile:filePath atomically:YES];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *temp = dict[@"list"];
            NSMutableArray *arr;
            for (int i=0;i<temp.count;i++) {
                NSDictionary *itemDict = temp[i];
                MainModel *model = [[MainModel alloc] init];
                [model setValuesForKeysWithDictionary:itemDict];
                if (i % 5 == 0) {
                    arr = [[NSMutableArray alloc] init];
                    [weakSelf.dataArr addObject:model];
                }else{
                    [arr addObject:model];
                    if (arr.count == 4) {
                        [weakSelf.dataArr addObject:arr];
                    }
                }
            }
            [weakSelf.tableView reloadData];
            [weakSelf endRefresh];
            [MMProgressHUD dismissWithSuccess:@"下载数据" title:@"OK"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"请求失败");
        [MMProgressHUD dismissWithError:@"下载数据" title:@"失败"];
        [weakSelf endRefresh];
    }];
}
#pragma mark - 创建刷新视图
-(void)createRefreshView
{
    //将self改为弱引用
    __weak typeof(self) weakSelf = self;
    //添加头部下拉刷新
    [_tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefresh) {
            return;
        }
        weakSelf.isRefresh = YES;
        weakSelf.page = 1;
        //获取网络请求
        [weakSelf addTaskUrl:weakSelf.requestUrl isRefresh:YES];
    }];
    //添加底部上啦加载
    [_tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadingMore) {
            return;
        }
        weakSelf.isLoadingMore = YES;
        //增加页码
        weakSelf.page ++;
        //获取网络数据
        [weakSelf addTaskUrl:weakSelf.requestUrl isRefresh:YES];
    }];
}
#pragma mark - 结束刷新
-(void)endRefresh
{
    if (_isRefresh) {
        _isRefresh = NO;
        [_tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (_isLoadingMore) {
        _isLoadingMore = NO;
        [_tableView footerEndRefreshing];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UITableVIewDelegate协议
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArr.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row%2==0) {
        MainCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MainCell" forIndexPath:indexPath];
        MainModel *model = _dataArr[indexPath.row];
        [cell showDataToCell:model];
        return cell;
    }else{
        
        SubCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SubCell" forIndexPath:indexPath];
        //实现block 完成页面跳转
        [cell showLeftTopDataWithModel:_dataArr[indexPath.row][0] jumpBlock:^(MainModel *model) {
            WebViewController *web = [[WebViewController alloc] initWithModel:model action:self.action];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
            [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }];
        
        [cell showRightTopDataWithModel:_dataArr[indexPath.row][1] jumpBlock:^(MainModel *model) {
            WebViewController *web = [[WebViewController alloc] initWithModel:model action:self.action];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
            [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }];
        
        [cell showLeftBottompDataWithModel:_dataArr[indexPath.row][2] jumpBlock:^(MainModel *model) {
            WebViewController *web = [[WebViewController alloc] initWithModel:model action:self.action];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
            [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }];
        
        [cell showRightBottomDataWithModel:_dataArr[indexPath.row][3] jumpBlock:^(MainModel *model) {
            WebViewController *web = [[WebViewController alloc] initWithModel:model action:self.action];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
            [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
        }];
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row % 2==0) {
        MainModel *model = _dataArr[indexPath.row];
        WebViewController *web = [[WebViewController alloc] initWithModel:model action:self.action];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
        [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
    }else{
        return;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 198.f;
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

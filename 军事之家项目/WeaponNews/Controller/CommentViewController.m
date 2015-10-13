//
//  CommentViewController.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/14.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "CommentViewController.h"
#import "MainModel.h"
#import "AFNetworking.h"
#import "CommentCell.h"
#import "CommentSubmitController.h"
#import "JHRefresh.h"


@interface CommentViewController ()<UITableViewDataSource,UITableViewDelegate>
{
     AFHTTPRequestOperationManager *_manager;
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSMutableArray *dataArr;
@property(nonatomic,strong)MainModel *model;
@property(nonatomic,copy)NSString *url;
@property(nonatomic,copy)NSString *pid;
@property(nonatomic,strong)UILabel *label;
@property(nonatomic,strong)NSString *count;
@end


@implementation CommentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title = @"评论";
    [self initData];
//    [self addTaskUrl:kCommentSubmit isRefresh:NO];
    [self createView];
   [self createRefreshView];
}
-(id)initWithId:(NSString *)uid
{
    if (self = [super init]) {
        self.pid = uid;
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    self.url = [NSString stringWithFormat:kCommentSubmit,self.pid];
    [self addTaskUrl:kCommentSubmit isRefresh:NO];
    
    [self.tableView reloadData];
}

-(void)initData
{
    self.dataArr = [[NSMutableArray alloc] init];
    self.page = 1;
    self.isRefreshing = NO;
    self.isLoadingMore = NO;
}

-(void)createRefreshView
{
    //将self改为弱引用
    __weak typeof(self) weakSelf = self;
    //添加头部下拉刷新
    [_tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isRefreshing) {
            return;
        }
        weakSelf.isRefreshing = YES;
        weakSelf.page = 1;
        //获取网络请求
        [weakSelf addTaskUrl:weakSelf.url isRefresh:YES];
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
        [weakSelf addTaskUrl:weakSelf.url isRefresh:YES];
    }];
}

-(void)endRefreshView
{
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [_tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (_isLoadingMore) {
        _isLoadingMore = NO;
        [_tableView footerEndRefreshing];
    }
}

-(void)createView
{
    UIButton *button1 = [Factory createButtonWithTitle:nil frame:CGRectMake(0, 0, 40, 40) target:self selector:@selector(btnClieck)];
    [button1 setBackgroundImage:[UIImage imageNamed: @"back_btn_n"] forState:UIControlStateNormal];
    [button1 setBackgroundImage:[UIImage imageNamed: @"back_btn_h"] forState:UIControlStateHighlighted];
    UIBarButtonItem *leftBtn = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.leftBarButtonItem = leftBtn;
    
    self.label = [Factory createLabelWithTitle:nil frame:CGRectMake(0, 0, 40, 40) fontSize:13.f];
    UIBarButtonItem *rightLabel = [[UIBarButtonItem alloc] initWithCustomView:self.label];
    self.navigationItem.rightBarButtonItem = rightLabel;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight-40) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
     //设置 预估cell高度 设置之后可以结合 autolayout 自动 动态算出cell 的高度（ios8之后可以）
//    self.tableView.estimatedRowHeight = 44;
    [self.view addSubview:self.tableView];
    [self.tableView registerNib:[UINib nibWithNibName:@"CommentCell" bundle:nil] forCellReuseIdentifier:@"Cell"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, ScreenHeight-40, ScreenWidth, 4*LeftDistance)];
    view.backgroundColor = [UIColor grayColor];
    UIButton *writeBtn = [Factory createButtonWithTitle:@"写评论" frame:CGRectMake(LeftDistance,LeftDistance/2, view.width-2*LeftDistance, view.height-LeftDistance) target:self selector:@selector(toWrite)];
    [writeBtn setImage:[UIImage imageNamed:@"article_comment_bg.9.png"] forState:UIControlStateNormal];
    writeBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
    [view addSubview:writeBtn];
    [self.view addSubview:view];
}

-(void)btnClieck
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)toWrite
{
    CommentSubmitController *submit = [[CommentSubmitController alloc] initWithId:self.pid];
    [self.navigationController pushViewController:submit animated:YES];
}

-(void)addTaskUrl:(NSString *)url isRefresh:(BOOL)isRefresh
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showWithTitle:@"加载数据" status:@"loading..."];
    __weak typeof(self)weakSelf = self;
    //&offset=0&count=20&uid=13907332&platform=a&mobile=GT-S7562i&pid=10106& e=90fff795f0a1f0daecf160e0606761b9
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSDictionary *dict = @{@"id":[NSString stringWithFormat:@"%@",self.pid],@"offset":[NSString stringWithFormat:@"%ld",(self.page-1)*10],@"count":@"20",@"uid":@"13907332",@"platform":@"a",@"mobile":@"GT-S7562i&",@"pid":@"10106",@"e":@"90fff795f0a1f0daecf160e0606761b9"};
    [_manager POST:KCommentUrl parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        self.count = dict[@"count"];
        NSArray *arr = dict[@"list"];
        if (weakSelf.page == 1) {
            [weakSelf.dataArr removeAllObjects];
        }
        for (NSDictionary *dicts in arr) {
            MainModel *model = [[MainModel alloc] init];
            model.count = dicts[@"count"];
            [model setValuesForKeysWithDictionary:dicts];
            [weakSelf.dataArr addObject:model];
        }
        [weakSelf.tableView reloadData];
         [weakSelf endRefreshView];
        [MMProgressHUD dismissWithSuccess:@"OK" title:@"加载数据"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"失败");
    }];
}

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
    CommentCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    MainModel *model = self.dataArr[indexPath.row];
    [cell showDataToCell:model];
//    self.label.text = [NSString stringWithFormat:@"%@条",self.count];
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

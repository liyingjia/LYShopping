//
//  AllBrandViewController.m
//  LYShopping
//
//  Created by qianfeng on 15/9/27.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "AllBrandViewController.h"
#import "AFNetworking.h"
#import "MainModel.h"
#import "RootViewController.h"
#import "ContainerViewController.h"

@interface AllBrandViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong) NSArray *titles;
@end

@implementation AllBrandViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    [self createButton];
    [self createHttpRequest];
    [self createView];
}

-(void)initData
{
    self.dataArr = [[NSMutableArray alloc] init];
}

-(void)createButton
{
    UIBarButtonItem *rightBtn = [[UIBarButtonItem alloc] initWithTitle:@"热门品牌" style:UIBarButtonItemStylePlain target:self action:@selector(btnClick:)];
    [rightBtn setTintColor:[UIColor redColor]];
    self.navigationItem.rightBarButtonItem = rightBtn;
}

-(void)btnClick:(UIBarButtonItem *)button
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)createHttpRequest
{
    __weak typeof(self)weakSelf = self;
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.titles = @[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"I",@"J",@"K",@"L",@"M",@"N",@"O",@"P",@"Q",@"R",@"S",@"T",@"U",@"V",@"W",@"X",@"Y",@"Z"];
    NSDictionary *dict = @{@"charactergroup":@"A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z",@"v":@"2.0"};
    [self.manager POST:kAllBrand parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            for (NSInteger i=0;i<self.titles.count; i++) {
                NSArray *arr = dict[self.titles[i]];
                NSMutableArray *array = [[NSMutableArray alloc] init];
                for (NSDictionary *item in arr) {
                    MainModel *model = [[MainModel alloc] init];
                    [model setValuesForKeysWithDictionary:item];
                    [array addObject:model];
                }
                [weakSelf.dataArr addObject:array];
            }
//            NSLog(@"da:%ld",weakSelf.dataArr.count);
            [weakSelf.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)createView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.sectionIndexBackgroundColor = [UIColor clearColor];
    [self.view addSubview:self.tableView];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.dataArr objectAtIndex:section] count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    MainModel *model = self.dataArr[indexPath.section][indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"%@%@",model.brandName,model.brandNameSecond];
    return cell;
}
//返回表格索引
-(NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView
{
    NSMutableArray *arr = [NSMutableArray arrayWithObjects:UITableViewIndexSearch, nil];
    [arr addObjectsFromArray:self.titles];
    return arr;
}
//设置 右侧索引标题 对应的分区索引
-(NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index
{
    return index-1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if ([self.dataArr[section] count] == 0) {
        return nil;
    }
    return self.titles[section];
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if ([self.dataArr[section] count] == 0) {
        return nil;
    }else{
        UIView *view = [[UIView alloc] init];
        view.backgroundColor = RGBA(0.1, 0.2, 0, 0.7);
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
        label.backgroundColor = [UIColor clearColor];
        label.text = self.titles[section];
        [label sizeToFit];
        label.textColor = [UIColor whiteColor];
        [view addSubview:label];
        
        return view;
    }
}

//-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return ScreenWidth*150/320;
//}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainModel *model = self.dataArr[indexPath.section][indexPath.row];
    UIBarButtonItem *backBtn = [[UIBarButtonItem alloc] init];
    [backBtn setTitle:model.brandName];
    self.navigationItem.backBarButtonItem = backBtn;
    
    NSArray *titles = @[@"人气",@"最新",@"价格^",@"大图"];
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSArray *names = @[@"PopularViewController",@"NewViewController",@"PriceViewController",@"BigPicViewController"];
    ContainerViewController *container = [[ContainerViewController alloc] init];
    for (int i=0; i<titles.count; i++) {
        Class cls = NSClassFromString(names[i]);
        RootViewController *root = [[cls alloc] init];
        root.title = titles[i];
        root.brandId = [model.brandId stringValue];
        [viewControllers addObject:root];
    }
    container.viewControllers = viewControllers;
    container.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:container animated:YES];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

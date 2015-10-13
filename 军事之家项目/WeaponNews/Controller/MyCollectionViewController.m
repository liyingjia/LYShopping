//
//  MyCollectionViewController.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/12.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "WebViewController.h"
#import "CoreData+MagicalRecord.h"
#import "UIImageView+WebCache.h"
#import "Entity.h"
#import "MainModel.h"
#import "HotCell.h"


@interface MyCollectionViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *deleteArr;
@property (nonatomic,strong)NSMutableArray *modelArr;
@property (nonatomic,strong)MainModel *model;
@property (nonatomic,strong)NSString *action;
@end

@implementation MyCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"我的收藏";
    [self createView];
    
    NSArray *arr = [Entity MR_findAll];
    [self.dataArr addObjectsFromArray:arr];
    [self.tableView reloadData];
    
}

-(void)createView
{
    self.dataArr = [[NSMutableArray alloc] init];
    self.deleteArr = [[NSMutableArray alloc] init];
    self.modelArr = [[NSMutableArray alloc] init];
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.dataSource = self;
    self.tableView.delegate =self;
    [self.tableView registerNib:[UINib nibWithNibName:@"HotCell" bundle:nil] forCellReuseIdentifier:@"HotCell"];
}

-(void)removeData
{
    if ([self.deleteArr count]) {
        [self.dataArr removeObjectsInArray:self.deleteArr];
        [self.tableView reloadData];
    }
}



-(void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
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
    HotCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HotCell" forIndexPath:indexPath];
    Entity *CollectModel = self.dataArr[indexPath.row];
    self.model = [[MainModel alloc] init];
    self.model.title = CollectModel.title;
    self.model.titlex = CollectModel.titlex;
    self.model.des = CollectModel.des;
    self.model.icon = CollectModel.icon;
    self.model.adddate = CollectModel.adddate;
    self.model.timestamp = CollectModel.timestamp;
    self.model.id = CollectModel.id;
    self.model.action = CollectModel.action;
    [self.modelArr addObject:self.model];
    [cell showDataToCell:self.model];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    MainModel *model = self.modelArr[indexPath.row];
    WebViewController *web = [[WebViewController alloc] initWithModel:model action:model.action];
    if ([model.action isEqualToString:@"piclist"]) {
        NSArray *images = [model.icon componentsSeparatedByString:@","];
        [web showDateWithImages:images];
    }
    
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:web];
    [self.view.window.rootViewController presentViewController:nav animated:YES completion:nil];
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80.f;
}

-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleDelete;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Entity *collectModel = self.dataArr[indexPath.row];
    //从数据源中删除
    [self.dataArr removeObject:collectModel];
    //刷新tableView
    [self.tableView reloadData];
    //从数据库中删除
    [[NSManagedObjectContext MR_defaultContext] deleteObject:collectModel];
    //同步到本地
    [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

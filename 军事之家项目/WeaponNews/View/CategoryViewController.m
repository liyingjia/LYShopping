//
//  CategoryViewController.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/4.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "CategoryViewController.h"
#import "ContainerViewController.h"
#import "RootViewController.h"


@interface CategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    UIView *_blackView;
    NSArray *_imageArr;
    NSArray *_titleArr;
}
@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor clearColor];
    self.navigationController.navigationBar.translucent = NO;
    self.navigationItem.title = @"分类";
    [self createView];
}

-(void)createView
{
    _imageArr=@[@"menu_rdzz_sel.png",@"menu_zgsd_sel.png",@"menu_zzfy_sel.png",@"menu_jmtd_sel.png",@"menu_jmhd_sel.png",@"menu_zzqk_sel.png"];
    _titleArr=@[@"热点追踪",@"中国视点",@"战争风云",@"军迷天地",@"军迷互动",@"掌中乾坤"];
    
//    _blackView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, ScreenWidth, ScreenHeight-64)];
//    _blackView.backgroundColor = RGBA(0, 0, 0, 0.5f);
//    [self.view addSubview:_blackView];
    
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.backgroundColor = RGB(230, 230, 230);
    _tableView.dataSource = self;
    _tableView.delegate = self;
    
    [self.view addSubview:_tableView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titleArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60.f;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    cell.contentView.backgroundColor = RGB(230, 230, 230);
    cell.imageView.image = [[UIImage imageNamed:_imageArr[indexPath.row]] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    cell.textLabel.text = _titleArr[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *arrSa = @[@[@"hqjwlist",@"rdzzlist"],@[@"wjjslist",@"zgzclist",@"zxsjlist"],@[@"binlin",@"binqi",@"fengyun"],@[@"tuba",@"youji",@"dushu"],@[@"weihuati"],@[@"qiankun"]];
    NSArray *titles = @[@[@"环球军闻",@"热点追踪"],@[@"我军建设",@"中国制造",@"走向世界"],@[@"兵林史话",@"兵器百科",@"战场风云"],@[@"图吧",@"军迷游记",@"读书"],@[@"微话题"],@[@"掌中乾坤"]];
    NSArray *images = @[@"title_rdzz",@"title_zgsd",@"title_zzfy",@"title_jmtd",@"title_jmhd",@"title_zzqk"];
    NSArray *viewControllers = @[@"HotPursueViewController",@"ChinaViewController",@"WarStormViewController",@"MilitaryFunWorldViewController",@"MilitaryFanIntViewController",@"PalmWordViewController"];
    ContainerViewController *container = [[ContainerViewController alloc] init];
    container.imageName = images[indexPath.row];
    NSMutableArray *views = [[NSMutableArray alloc] init];
    for (int i=0; i<[titles[indexPath.row] count]; i++) {
        Class cls = NSClassFromString(viewControllers[indexPath.row]);
        RootViewController *root = [[cls alloc] init];
        root.title = titles[indexPath.row][i];
        if (indexPath.row == 3) {
            if (i==0 || i==1) {
                root.action = @"piclist";
            }else{
                root.action = @"cover";
            }
        }else{
            root.action = @"list";
        }
        root.sa = arrSa[indexPath.row][i];
        [views addObject:root];
    }
    container.viewControllers = views;
        [self.view.window.rootViewController presentViewController:container animated:YES completion:nil];
//    [self.navigationController presentViewController:container animated:YES completion:nil];
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

//
//  BrandDetailViewController.m
//  LYShopping
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BrandDetailViewController.h"
#import "AFNetworking.h"
#import "BrandAdView.h"
#import "BrandDetailModel.h"
#import "FirstCell.h"
#import "SecondCell.h"
#import "ThirdCell.h"
#import "FourCell.h"
#import "FootView.h"
#import "FiveCell.h"
#import "LoginViewController.h"
#import "UMSocial.h"



@interface BrandDetailViewController ()<UITableViewDataSource,UITableViewDelegate,UMSocialUIDelegate>

@property (nonatomic,strong)NSMutableArray *dataArr;
@property (nonatomic,strong)NSMutableArray *sizeArr;
@property (nonatomic,strong)NSMutableArray *colorArr;
@property (nonatomic,strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic,copy)NSString *brandname;
@property (nonatomic,copy)NSString *remind;
@property (nonatomic,copy)NSString *colorText;
@property (nonatomic,strong)FootView *footView;
@property (nonatomic,strong)UIImageView *imageView;

@end

@implementation BrandDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BOOL isFav = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@",self.productid]];
    if (isFav) {
        [self.favButton setImage:[UIImage imageNamed: @"icon_love_down"] forState:UIControlStateNormal];
    }else{
        [self.favButton setImage:[UIImage imageNamed: @"icon_love_up"] forState:UIControlStateNormal];
    }
    
    [self initData];
    [self createHttpRequest];
    [self createView];
}

-(void)initData
{
    self.dataArr = [[NSMutableArray alloc] init];
    self.sizeArr = [[NSMutableArray alloc] init];
    self.colorArr = [[NSMutableArray alloc] init];
    if (self.pisSpecial) {
        self.shopButton.alpha = 0;
    }
}

#pragma mark - 创建HttpReqequest
-(void)createHttpRequest
{
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [self downloadDataWithUrl:kCategoryDetail1];
}
#pragma mark - 下载数据
-(void)downloadDataWithUrl:(NSString *)url
{
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleExpand];
    [MMProgressHUD showWithTitle:@"下载数据" status:@"loading..."];
    __weak typeof(self)weakSelf = self;
    NSDictionary *dict = @{@"productid":self.productid,@"noStock":@"1",@"v":@"2.0"};
    [self.manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *arr = dict[@"result"][@"ProductBaseInfo"];
            for (NSDictionary *item in arr) {
                BrandDetailModel *model = [[BrandDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                 weakSelf.brandname = model.brandname;
//                 weakSelf.remind = model.remind;
                [weakSelf.dataArr addObject:model];
                [weakSelf.dataArr addObject:model];
            }
            weakSelf.titleLabel.text = weakSelf.brandname;
            //获取颜色
            NSArray *colors = dict[@"result"][@"ProductsColor"];
            for (NSDictionary *item in colors) {
                BrandDetailModel *model = [[BrandDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [weakSelf.colorArr addObject:model];
            }
            //获取尺寸
            NSArray *sizes = dict[@"result"][@"ProductSize"];
            for (NSDictionary *item in sizes) {
                BrandDetailModel *model = [[BrandDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [weakSelf.sizeArr addObject:model];
            }
            [weakSelf.dataArr addObject:weakSelf.sizeArr];
            [weakSelf.dataArr addObject:@""];
            [weakSelf.dataArr addObject:@""];
            [weakSelf.tableVIew reloadData];
            [MMProgressHUD dismissWithSuccess:@"OK" title:@"下载数据"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)createView
{
    BrandAdView *view = [[BrandAdView alloc] initWithId:self.productid];
    view.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight/2);
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 20, 50, 50)];
    self.imageView.image = [UIImage imageNamed: @"productinfo_issea"];
    if (!self.pisSpecial) {
        self.imageView.alpha = 0;
    }
//    self.imageView.alpha = 0;
    [view addSubview:self.imageView];
    self.tableVIew.dataSource = self;
    self.tableVIew.delegate = self;
    self.tableVIew.tableHeaderView = view;
    self.tableVIew.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    self.tableVIew.separatorColor = [UIColor blueColor];
    
    [self.tableVIew registerNib:[UINib nibWithNibName:@"FirstCell" bundle:nil] forCellReuseIdentifier:@"FirstCell"];
    [self.tableVIew registerNib:[UINib nibWithNibName:@"SecondCell" bundle:nil] forCellReuseIdentifier:@"SecondCell"];
    [self.tableVIew registerNib:[UINib nibWithNibName:@"ThirdCell" bundle:nil] forCellReuseIdentifier:@"ThirdCell"];
    [self.tableVIew registerNib:[UINib nibWithNibName:@"FourCell" bundle:nil] forCellReuseIdentifier:@"FourCell"];
    [self.tableVIew registerNib:[UINib nibWithNibName:@"FiveCell" bundle:nil] forCellReuseIdentifier:@"FiveCell"];
    
}

#pragma mark - UITableVIewDelegate协议
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
    
    if (indexPath.row == 0) {
        BrandDetailModel *model = self.dataArr[indexPath.row];
        cell = [tableView dequeueReusableCellWithIdentifier:@"FirstCell" forIndexPath:indexPath];
        [(FirstCell*)cell showDataWithModel:model block:^{
            LoginViewController *login = [[LoginViewController alloc] init];
            [self presentViewController:login animated:YES completion:nil];
        }];
    }else if (indexPath.row == 1){
        BrandDetailModel *model = self.dataArr[indexPath.row];
        static NSString *identifier = @"cell";
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [cell.textLabel sizeToFit];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        if (model.countryName.length != 0) {
            cell.textLabel.text = model.countryName;
        }else if(model.remind.length != 0){
            cell.textLabel.text = model.remind;
        }else{
            cell.textLabel.text = @"暂无内容,稍后更新!";
        }
    }else if (indexPath.row == 2){
        cell = [tableView dequeueReusableCellWithIdentifier:@"SecondCell" forIndexPath:indexPath];
        [(SecondCell *)cell showDataWithArray:self.sizeArr color:self.colorArr];
    }else if (indexPath.row == 3){
        if (self.pisSpecial) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"ThirdCell" forIndexPath:indexPath];
            [(ThirdCell *)cell showData];
        }else{
            cell = [tableView dequeueReusableCellWithIdentifier:@"FourCell" forIndexPath:indexPath];
            [(FourCell *)cell showData];
        }
    }else if (indexPath.row == 4){
        cell = [tableView dequeueReusableCellWithIdentifier:@"FiveCell" forIndexPath:indexPath];
        [(FiveCell *)cell downloadDataWithUrl:kCategoryDetail3 pid:self.productid block:^(NSString *productId) {
            BrandDetailViewController *brandView = [[BrandDetailViewController alloc] init];
            brandView.productid = productId;
            [self presentViewController:brandView animated:YES completion:nil];
        }];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 100;
    }else if(indexPath.row == 2){
        if (self.colorArr.count<=3&&self.sizeArr.count<=3) {
            return 130;
        }else if (self.colorArr.count<=3&&self.sizeArr.count<=6){
            return 160;
        }else if (self.colorArr.count<=3&&self.sizeArr.count<=9){
            return 190;
        }else if(self.colorArr.count<=12){
            return 270;
        }
    }else if (indexPath.row == 3){
        return 80;
    }else if (indexPath.row == 4){
        return 170;
    }
    return 44;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UILabel *label = [Factory createLabelWithTitle:[NSString stringWithFormat:@"------------%@------------",self.brandname] frame:CGRectMake(0, 0, ScreenWidth, 20)];
    label.font = [UIFont systemFontOfSize:16.f];
    label.backgroundColor = [UIColor yellowColor];
    label.textAlignment = NSTextAlignmentCenter;
    return label;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - 点击收藏按钮
- (IBAction)favBtnClick:(UIButton *)sender {
    BOOL isLogin = [[NSUserDefaults standardUserDefaults] boolForKey:kIsLogin];
    if (!isLogin) {
        [self createAlert:@"0"];
    }else{
        BOOL isFav = [[NSUserDefaults standardUserDefaults] boolForKey:[NSString stringWithFormat:@"%@",self.productid]];
        
        if (!isFav) {
            [sender setImage:[UIImage imageNamed: @"icon_love_down"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:[NSString stringWithFormat:@"%@",self.productid]];
            [self addCollection];
        }else{
            [sender setImage:[UIImage imageNamed: @"icon_love_up"] forState:UIControlStateNormal];
            [[NSUserDefaults standardUserDefaults] setBool:NO forKey:[NSString stringWithFormat:@"%@",self.productid]];
            [self deleCollection];
        }
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
#pragma mark - 分享
- (IBAction)rightBtn:(UIButton *)sender {
    //隐藏未安装的客户端平台
    [UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ,UMShareToQzone,UMShareToWechatSession,UMShareToWechatTimeline]];
    [UMSocialSnsService presentSnsIconSheetView:self appKey:@"561506d3e0f55aaa0d001ba8" shareText:@"喜欢就分享一下吧😊" shareImage:[UIImage imageNamed:@"icon"] shareToSnsNames:[NSArray arrayWithObjects:UMShareToSina,UMShareToTencent,UMShareToRenren,UMShareToEmail, nil] delegate:self];
}

- (IBAction)backBtn:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//回调的方法
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    if (response.responseCode == UMSResponseCodeSuccess) {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}

- (IBAction)buyBtn:(UIButton *)sender {
    /*
    Order *order  = [[Order alloc]init];
    order.partner = PartnerID;
    order.seller  =  SellerID;
    //交易号
    order.tradeNO = @"1505";
    //产品名称
    order.productName = @"iphone6";
    //产品描述
    order.productDescription = @"iphone 6降价处理";
    //商品价格（单位：元）
    order.amount = @"0.01";
    //当交易成功后，或给该url发送post通知
    // 回调地址，如果不填写此项，则无法通知服务器更改订单状态
    order.notifyURL = @"http://www.baidu.com";
    //交易服务器，固定
    order.service   = @"mobile.securitypay.pay";
    //交易类型，商品交易
    order.paymentType= @"1";
    
    order.inputCharset = @"utf-8";
    //超时时间，m分，h时 d天，超时交易自动关闭
    order.itBPay = @"30m";
    
    //要在URL Scheme中设置同样的字符串
    // 支付宝回调App设置
    // 除了在代码中设置该属性，还需在info.plist中添加URL Scheme，要一致
    // 设置了才能通知你的APP，进行下一步的支付处理，比如说显示订单详情，待发货
    NSString *appScheme = @"alipayDemo";
    
    //将商品信息拼接成字符串
    NSString *orderSpec = [order description];
    
    //使用私钥进行数据签名
    id<DataSigner> signer = CreateRSADataSigner(PartnerPrivKey);
    NSString *signedString = [signer signString:orderSpec];
    
    NSString *orderString = nil;
    if (signedString != nil) {
        orderString = [NSString stringWithFormat:@"%@&sign=\"%@\"&sign_type=\"%@\"",orderSpec, signedString, @"RSA"];
        //启动支付宝的客户端
        [[AlipaySDK defaultService] payOrder:orderString fromScheme:appScheme callback:^(NSDictionary *resultDic) {
            NSLog(@"reslut = %@",resultDic);
        }];
    }
     */
}

- (IBAction)shopBtn:(UIButton *)sender {
    
}

- (IBAction)bagBtn:(UIButton *)sender {
    
}


#pragma mark - 增加收藏
-(void)addCollection
{
    //memberid=565137&productid=%@&access_token=426a52b6-958e-4d6c-831f-f0f274ba39db&isbuy=0
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:kMemberid];
    NSString *access = [[NSUserDefaults standardUserDefaults] objectForKey:kAccess_token];
    NSDictionary *dict = @{@"memberid":memberid,@"productid":self.productid,@"access_token":access,@"isbuy":@"0"};
    [self.manager POST:kAddCollect parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        BOOL fav = [dict[@"result"] boolValue];
        if (fav == 1) {
            [self createAlert:@"1"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"连接失败");
    }];
}

#pragma mark - 取消收藏
-(void)deleCollection
{
    //memberid=565137&access_token=426a52b6-958e-4d6c-831f-f0f274ba39db&productid=%@
    NSString *memberid = [[NSUserDefaults standardUserDefaults] objectForKey:kMemberid];
    NSString *access = [[NSUserDefaults standardUserDefaults] objectForKey:kAccess_token];
    
    NSDictionary *dict = @{@"memberid":memberid,@"access_token":access,@"productid":self.productid};
    [self.manager POST:kDeleCollect parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        BOOL fav = [dict[@"result"] boolValue];
        if (fav) {
            [self createAlert:@"2"];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"连接失败");
    }];
}


-(void)createAlert:(NSString *)string
{
    if ([string isEqualToString:@"0"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"还没有登录哦，先去登录吧!" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定",nil];
        [alert show];
    }
    
    if ([string isEqualToString:@"1"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"收藏成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    
    if ([string isEqualToString:@"2"]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"取消成功" delegate:self cancelButtonTitle:nil otherButtonTitles:nil];
        [alert show];
        [alert dismissWithClickedButtonIndex:0 animated:YES];
    }
    
}


@end

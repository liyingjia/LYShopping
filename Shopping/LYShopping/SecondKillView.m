//
//  SecondKillView.m
//  LYShopping
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "SecondKillView.h"
#import "AFNetworking.h"
#import "UIImageView+WebCache.h"
#import "MainModel.h"
#import "KillView.h"

@implementation SecondKillView
{
    AFHTTPRequestOperationManager *_manager;
    NSMutableArray *_dataArr;
    MainModel *_model;
    KillView *_killView;
}

-(void)createHttpRequest
{
    _dataArr = [[NSMutableArray alloc] init];
    _model = [[MainModel alloc] init];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
}

-(void)downloadDataWithUrl:(NSString *)url Block:(SkipToView)block
{
    self.myBlock = block;
    [self createHttpRequest];
    __weak typeof(self)weakSelf = self;
    [_manager POST:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
       _model.title = dict[@"result"][@"quickBuyUrl"][@"title"];
        _model.url = dict[@"result"][@"quickBuyUrl"][@"url"];
        weakSelf.titleLabel.text = _model.title;
        NSArray *group = dict[@"result"][@"groups"];
        for (NSDictionary *item in group) {
            NSArray *products = [self objectOrNilForKey:@"products" fromDictionary:item];
            if (products.count != 0) {
                //_model.startTime
                [_model setValuesForKeysWithDictionary:item];
            }
        }
//        _killView = [[[NSBundle mainBundle] loadNibNamed:@"KillView" owner:nil options:nil] lastObject];
        NSInteger width = (_scrollView.width-5*6)/4;
        NSInteger height = _scrollView.height;
        
        for (NSInteger i = 0; i < _model.products.count; i++) {
            KillView *view = [[[NSBundle mainBundle] loadNibNamed:@"KillView" owner:nil options:nil] lastObject];
            view.frame = CGRectMake(5+(width+5)*i, 0, width, height);
            NSDictionary *item = _model.products[i];
            [_model setValuesForKeysWithDictionary:item];

            [view showDataWithModel:_model Block:^(NSString *url) {
                self.tipUrl = url;
                if (self.myBlock) {
                    self.myBlock(self.tipUrl);
                }
            }];
            [_scrollView addSubview:view];
        }
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.bounces = NO;
        _scrollView.contentSize = CGSizeMake((width+3)*_model.products.count, height);
        
        [weakSelf createView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(void)iconClick:(UIButton *)btn
{
    
}

-(void)createView
{
    
    
}

#pragma mark - 判断解析类型是否为NSNULL
-(id)objectOrNilForKey:(id)aKey fromDictionary:(NSDictionary *)dict
{
    id object = [dict objectForKey:aKey];
    return [object isEqual:[NSNull null]] ? nil : object;
}


@end





















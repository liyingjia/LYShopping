//
//  FootView.m
//  LYShopping
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "FootView.h"
#import "AFNetworking.h"
#import "BrandDetailModel.h"
#import "FiveView.h"

@implementation FootView
{
    AFHTTPRequestOperationManager *_manager;
    NSMutableArray *_dataArr;
    FiveView *_fiveView;
    
}

-(void)createHttpRequest
{
    _dataArr = [[NSMutableArray alloc] init];
    _manager = [AFHTTPRequestOperationManager manager];
    _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)downloadDataWithUrl:(NSString *)url pid:(NSString *)proid block:(skipToView)block
{
    self.myBlock = block;
    [self createHttpRequest];
    __weak typeof(self)weakSeaf = self;
    NSDictionary *dict = @{@"productid":proid};
    [_manager POST:url parameters:dict success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *products = dict[@"roundproducts"];
            for (NSDictionary *item in products) {
                BrandDetailModel *model = [[BrandDetailModel alloc] init];
                [model setValuesForKeysWithDictionary:item];
                [_dataArr addObject:model];
            }
            NSInteger width = (_scrollView.width-5*6)/4;
            NSInteger height = _scrollView.height;
            
            for (NSInteger i = 0; i < _dataArr.count; i++) {
                FiveView *view = [[[NSBundle mainBundle] loadNibNamed:@"FiveView" owner:nil options:nil] lastObject];
                view.frame = CGRectMake(5+(width+5)*i, 0, width, height);
                BrandDetailModel *model = _dataArr[i];
                [view showDataWithModel:model Block:^(NSString *productid) {
                    if (weakSeaf.myBlock) {
                        weakSeaf.myBlock(productid);
                    }
                }];
                [_scrollView addSubview:view];
            }
            _scrollView.showsHorizontalScrollIndicator = NO;
            _scrollView.showsVerticalScrollIndicator = NO;
            _scrollView.bounces = NO;
            _scrollView.contentSize = CGSizeMake((width+5)*_dataArr.count, height);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


@end

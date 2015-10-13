//
//  MainModel.h
//  LYShop
//
//  Created by qianfeng on 15/9/22.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BaseModel.h"

@interface MainModel : BaseModel

@property(nonatomic,copy)NSString *picUrl;
@property(nonatomic,copy)NSString *url;

@property(nonatomic,copy)NSString *title;
@property(nonatomic,copy)NSArray *products;
@property(nonatomic,copy)NSNumber *startTime;
@property(nonatomic,copy)NSNumber *endTime;
@property(nonatomic,copy)NSNumber *price;
@property(nonatomic,copy)NSNumber *marketPrice;
@property(nonatomic,copy)NSString *brandname;
@property(nonatomic,copy)NSNumber *premiumPrice;
@property(nonatomic,copy)NSString *msmall;

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *img;

@property(nonatomic,copy)NSString *adShow;
@property(nonatomic,copy)NSString *saleText;
@property(nonatomic,copy)NSString *appImgUrl;
@property(nonatomic,copy)NSNumber *addTime;
@property(nonatomic,copy)NSNumber *upTime;

//品牌
@property(nonatomic,copy)NSString *appImg;
@property(nonatomic,copy)NSString *brandName;
@property(nonatomic,copy)NSString *brandNameSecond;
@property(nonatomic,copy)NSNumber *brandId;



@end


















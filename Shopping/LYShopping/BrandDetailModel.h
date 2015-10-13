//
//  BrandDetailModel.h
//  LYShopping
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BaseModel.h"

@interface BrandDetailModel : BaseModel


@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *brandname;
@property(nonatomic,copy)NSString *remind;
@property(nonatomic,copy)NSNumber *price;
@property(nonatomic,copy)NSNumber *marketPrice;
@property(nonatomic,copy)NSString *countryName;

@property(nonatomic,copy)NSString *colorText;
@property(nonatomic,copy)NSString *specvalue;
@property(nonatomic,copy)NSString *referencesize;

@property(nonatomic,copy)NSString *productId;
@property(nonatomic,copy)NSString *msmall;
@property(nonatomic,copy)NSString *productSpecId;
@property(nonatomic,copy)NSNumber *stock;
@property(nonatomic,copy)NSString *productname;
@property(nonatomic,copy)NSString *m_small;

@end

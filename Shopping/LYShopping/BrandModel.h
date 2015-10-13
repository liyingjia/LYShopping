//
//  BrandModel.h
//  LYShopping
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BaseModel.h"

@interface BrandModel : BaseModel
@property(nonatomic,copy)NSString *productName;
@property(nonatomic,copy)NSString *brandname;
@property(nonatomic,copy)NSNumber *price;
@property(nonatomic,copy)NSString *msmall;
@property(nonatomic)BOOL pisSpecial;
@property(nonatomic,copy)NSNumber *stock;
@property(nonatomic,copy)NSString *productId;
@end

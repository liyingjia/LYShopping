//
//  CategoryModel.h
//  LYShopping
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "BaseModel.h"

@interface CategoryModel : BaseModel

@property(nonatomic,copy)NSString *brandImg;
@property(nonatomic,copy)NSNumber *brandId;
@property(nonatomic,copy)NSString *brandName;


@property(nonatomic,copy)NSString *gatherName;
@property(nonatomic,copy)NSNumber *categoryId;
@property(nonatomic,copy)NSString *categoryName;
@property(nonatomic,copy)NSString *imgUrl;
@property(nonatomic,strong)NSMutableArray *array;


//搜索
@property(nonatomic,copy)NSString *keyWords;
@end

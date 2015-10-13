//
//  BrandAdView.h
//  LYShopping
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BrandAdView : UIView<UIScrollViewDelegate>

@property(nonatomic,copy)NSString *productId;

-(id)initWithId:(NSString *)productId;

-(void)downloadDataWithUrl:(NSString *)url;

-(void)createHttpRequest;

@end

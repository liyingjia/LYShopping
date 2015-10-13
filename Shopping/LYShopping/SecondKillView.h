//
//  SecondKillView.h
//  LYShopping
//
//  Created by qianfeng on 15/9/23.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

typedef void(^SkipToView)(NSString *url);

@interface SecondKillView : UIView<UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property(nonatomic,copy)NSString *tipUrl;
@property(nonatomic,copy)SkipToView myBlock;

-(void)downloadDataWithUrl:(NSString *)url Block:(SkipToView)block;

-(void)createHttpRequest;

@end

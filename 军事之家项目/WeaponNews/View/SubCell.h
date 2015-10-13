//
//  SubCell.h
//  WeaponNews
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainModel.h"

typedef void(^SkipToNextView)(MainModel *model);

@interface SubCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightTopImage;
@property (weak, nonatomic) IBOutlet UIImageView *leftBottomImage;
@property (weak, nonatomic) IBOutlet UIImageView *rightBottomImage;
@property (weak, nonatomic) IBOutlet UILabel *leftTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightTopLabel;
@property (weak, nonatomic) IBOutlet UILabel *leftBottomLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightBottomLabel;

@property(nonatomic,strong)MainModel *leftTopModel;
@property(nonatomic,strong)MainModel *leftBottomModel;
@property(nonatomic,strong)MainModel *rightTopModel;
@property(nonatomic,strong)MainModel *rightBottomModel;
@property(nonatomic,copy)SkipToNextView myBlock;

- (IBAction)leftTopClieck:(UIButton *)sender;
- (IBAction)rightTopClieck:(UIButton *)sender;
- (IBAction)leftBottomClieck:(UIButton *)sender;
- (IBAction)rightBottomClieck:(UIButton *)sender;

-(void)showLeftTopDataWithModel:(MainModel *)model jumpBlock:(SkipToNextView)block;
-(void)showRightTopDataWithModel:(MainModel *)model jumpBlock:(SkipToNextView)block;
-(void)showLeftBottompDataWithModel:(MainModel *)model jumpBlock:(SkipToNextView)block;
-(void)showRightBottomDataWithModel:(MainModel *)model jumpBlock:(SkipToNextView)block;

@end

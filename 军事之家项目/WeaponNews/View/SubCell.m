//
//  SubCell.m
//  WeaponNews
//
//  Created by qianfeng on 15/9/3.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "SubCell.h"
#import "WebViewController.h"
#import "UIImageView+WebCache.h"

@implementation SubCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)showLeftTopDataWithModel:(MainModel *)model jumpBlock:(SkipToNextView)block
{
    //接收 block 和 model
    _myBlock = block;
    self.leftTopModel = model;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed:@"listitem_jmtd_default_s"]];
//    self.leftImageView.layer.masksToBounds = YES;
//    self.leftImageView.layer.cornerRadius = 5.f;
    self.leftTopLabel.text = model.title;
}

-(void)showRightTopDataWithModel:(MainModel *)model jumpBlock:(SkipToNextView)block
{
    _myBlock = block;
     self.rightTopModel = model;
    [self.rightTopImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed:@"listitem_jmtd_default_s"]];
//    self.rightTopImage.layer.masksToBounds = YES;
//    self.rightTopImage.layer.cornerRadius = 5.f;
    self.rightTopLabel.text = model.title;
}

-(void)showLeftBottompDataWithModel:(MainModel *)model jumpBlock:(SkipToNextView)block
{
    _myBlock = block;
    self.leftBottomModel = model;
    [self.leftBottomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed:@"listitem_jmtd_default_s"]];
//    self.leftBottomImage.layer.masksToBounds = YES;
//    self.leftBottomImage.layer.cornerRadius = 5.f;
    self.leftBottomLabel.text = model.title;
}

-(void)showRightBottomDataWithModel:(MainModel *)model jumpBlock:(SkipToNextView)block
{
    //接收 block 和 model
    _myBlock = block;
    self.rightBottomModel = model;
    [self.rightBottomImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",kBaseUrl,model.icon]] placeholderImage:[UIImage imageNamed:@"listitem_jmtd_default_s"]];
//    self.rightBottomImage.layer.masksToBounds = YES;
//    self.rightBottomImage.layer.cornerRadius = 5.f;
    self.rightBottomLabel.text = model.title;
}

//点击按钮，回调Block 实现页面跳转
- (IBAction)leftTopClieck:(UIButton *)sender {
    if (self.myBlock) {
        _myBlock(self.leftTopModel);
    }
}

- (IBAction)rightTopClieck:(UIButton *)sender {
    if (_myBlock) {
        _myBlock(self.rightTopModel);
    }
}

- (IBAction)leftBottomClieck:(UIButton *)sender {
    if (_myBlock) {
        _myBlock(self.leftBottomModel);
    }
}

- (IBAction)rightBottomClieck:(UIButton *)sender {
    if (_myBlock) {
        _myBlock(self.rightBottomModel);
    }
}
@end

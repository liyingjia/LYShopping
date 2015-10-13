//
//  SecondCell.m
//  LYShopping
//
//  Created by qianfeng on 15/9/30.
//  Copyright (c) 2015年 李营. All rights reserved.
//

#import "SecondCell.h"
#import "BrandDetailModel.h"



@implementation SecondCell

- (void)awakeFromNib {
    // Initialization code
}

-(void)showDataWithArray:(NSArray *)array color:(NSArray *)colors
{
    CGFloat colorWidth = (ScreenWidth-4*10)/3;
    CGFloat colorHeight = 20;
    
    if (colors.count == 0) {
        UIButton *button = [Factory createButtonWithTitle:@"无" frame:CGRectMake(20, 35+13,(colorWidth-20),colorHeight) target:self selector:@selector(colorButtonClick:)];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor redColor].CGColor;
        [self.contentView addSubview:button];
    }else{
        for (NSInteger i=0; i<colors.count; i++) {
            BrandDetailModel *model = colors[i];
            UIButton *button = [Factory createButtonWithTitle:model.colorText frame:CGRectMake(20+i%3*(colorWidth+10), 35+i/3*(colorHeight+13), (colorWidth-20), colorHeight+5) target:self selector:@selector(colorButtonClick:)];
            button.titleLabel.font = [UIFont systemFontOfSize:14.f];
            button.tag = 201 + i;
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor blackColor].CGColor;
            [self.contentView addSubview:button];
        }
    }
   
    self.sizeLabel.frame = CGRectMake(0, 35+(colors.count/3+1)*(colorHeight+13), 100, 20);
    CGFloat width = (ScreenWidth-4*10)/3;
    CGFloat height = 20;

    for (NSInteger i=0; i<array.count; i++) {
        BrandDetailModel *model = array[i];
        UIButton *button = [Factory createButtonWithTitle:model.specvalue frame:CGRectMake(20+i%3*(width+10), self.sizeLabel.bottom+5+i/3*(height+13), (width-20), height+5) target:self selector:@selector(buttonClick:)];
        button.titleLabel.font = [UIFont systemFontOfSize:14.f];
        button.tag = 101 + i;
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        if (colors.count == 0) {
            button.backgroundColor = [UIColor grayColor];
        }
        [self.contentView addSubview:button];
    }
}

//点击颜色按钮
-(void)colorButtonClick:(UIButton *)button
{
    
}

//点击尺寸按钮
-(void)buttonClick:(UIButton *)button
{
    if (self.color.length != 0) {
        button.layer.borderColor = [UIColor redColor].CGColor;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

//
//  MenuTableViewCell.m
//  PopMenuTableView
//
//  Created by 孔繁武 on 16/8/2.
//  Copyright © 2016年 KongPro. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell {
    UIView *_lineView;
    UILabel *_titleLable;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI{
    UIView *lineView = [[UIView alloc] init];
    lineView.backgroundColor = [UIColor lightGrayColor];
    _lineView = lineView;
    [self addSubview:lineView];
    self.backgroundColor = [UIColor clearColor];
    self.textLabel.font = [UIFont systemFontOfSize:14];
    self.textLabel.textColor = [UIColor whiteColor];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    
    
    UILabel *t_lb = [[UILabel alloc] init];
    _titleLable = t_lb;
    [self addSubview:_titleLable];
    _titleLable.backgroundColor = [UIColor clearColor];
    _titleLable.font = [UIFont systemFontOfSize:15];
    _titleLable.textAlignment = NSTextAlignmentCenter;
    _titleLable.textColor = [UIColor whiteColor];

}

- (void)layoutSubviews{
    [super layoutSubviews];
    _lineView.frame = CGRectMake(4, self.bounds.size.height - 1, self.bounds.size.width - 8, 0.5);
    _titleLable.frame = CGRectMake(4, 2, self.bounds.size.width - 8, self.bounds.size.height-4);
}

- (void)setMenuModel:(MenuModel *)menuModel{
    _menuModel = menuModel;
    _titleLable.text = menuModel.itemName;
   
//    self.imageView.image = [UIImage imageNamed:menuModel.imageName];
//    self.textLabel.text = menuModel.itemName;
}

@end

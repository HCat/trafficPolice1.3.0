//
//  ActionTopCell.m
//  移动采集
//
//  Created by hcat on 2018/9/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "ActionTopCell.h"

@interface ActionTopCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_actionName;
@property (weak, nonatomic) IBOutlet UILabel *lb_actionContent;

@end

@implementation ActionTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setAction:(ActionInfoModel *)action{
    
    _action = action;
    
    self.lb_actionName.text = [ShareFun takeStringNoNull:_action.actionName];
    self.lb_actionContent.text = [ShareFun takeStringNoNull:_action.actionContent];
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

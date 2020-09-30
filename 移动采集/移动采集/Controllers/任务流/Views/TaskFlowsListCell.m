//
//  TaskFlowsListCell.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/4.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsListCell.h"

@interface TaskFlowsListCell ()

@property (weak, nonatomic) IBOutlet UILabel  *lb_title;     //主题
@property (weak, nonatomic) IBOutlet UILabel  *lb_content;   //内容
@property (weak, nonatomic) IBOutlet UIButton *btn_status;   //状态
@property (weak, nonatomic) IBOutlet UILabel  *lb_time;      //时间
@property (weak, nonatomic) IBOutlet UILabel  *lb_dynamic;   //动态

@end


@implementation TaskFlowsListCell

- (void)awakeFromNib {
    [super awakeFromNib];

    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(TaskFlowsListModel *  _Nullable x) {
        
        @strongify(self);
        
        if ([x.type isEqualToNumber:@1]) {
            self.lb_title.text = [NSString stringWithFormat:@"转发:%@",[ShareFun takeStringNoNull:x.userPolice]];
        }else if ([x.type isEqualToNumber:@0]){
            self.lb_title.text = @"类型:你是我的眼";
        }else if ([x.type isEqualToNumber:@2]){
            self.lb_title.text = @"类型:企业复工助力";
        }else if ([x.type isEqualToNumber:@3]){
            self.lb_title.text = @"类型:新冠疫情车辆通行证";
        }
        
        self.lb_time.text = [ShareFun timeWithTimeInterval:x.createTime];
        self.lb_content.text = [ShareFun takeStringNoNull:x.content];
        self.lb_dynamic.text = [NSString stringWithFormat:@"%d条动态",[x.replyCount intValue]];
        
        if ([x.status isEqualToNumber:@0]) {
            
            [self.btn_status setTitle:@"待处理" forState:UIControlStateNormal];
            [self.btn_status setTitleColor:UIColorFromRGB(0x3396FC) forState:UIControlStateNormal];
            self.btn_status.layer.borderWidth = 1.0f;
            self.btn_status.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
            
        }else{
            
            [self.btn_status setTitle:@"已处理" forState:UIControlStateNormal];
            [self.btn_status setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            self.btn_status.layer.borderWidth = 1.0f;
            self.btn_status.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
            
        }
        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
 

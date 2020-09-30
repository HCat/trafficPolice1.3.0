//
//  TaskFlowsDetailContentCell.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/5.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsDetailContentCell.h"

@interface TaskFlowsDetailContentCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet UILabel *lb_user;

@property (weak, nonatomic) IBOutlet UILabel *lb_type;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_view_top;

@end


@implementation TaskFlowsDetailContentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    
    [RACObserve(self, result) subscribeNext:^(TaskFlowsDetailReponse * _Nullable x) {
        
        @strongify(self);
        
        //任务类型    0你是我的眼 1警务任务 2疫情复工 3.车辆通行证
        if ([x.taskDetail.type isEqualToNumber:@0]) {
            self.lb_type.text = @"类型：你是我的眼";
            self.lb_user.hidden = NO;
            self.layout_view_top.constant = 48.f;
            [self.contentView layoutIfNeeded];
        }else if ([x.taskDetail.type isEqualToNumber:@1]){
            self.lb_type.text = @"类型：警务任务";
            self.layout_view_top.constant = 15.f;
            [self.contentView layoutIfNeeded];
            self.lb_user.hidden = YES;
        }
        
        if (x.taskDetail.complaintName || x.taskDetail.complaintPhone) {
            self.lb_user.text = [NSString stringWithFormat:@"%@ %@",x.taskDetail.complaintName,x.taskDetail.complaintPhone];
        }
        
        self.lb_time.text = [ShareFun timeWithTimeInterval:x.taskDetail.createTime];
        
        self.lb_content.text = [ShareFun takeStringNoNull:x.taskDetail.content];
    
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

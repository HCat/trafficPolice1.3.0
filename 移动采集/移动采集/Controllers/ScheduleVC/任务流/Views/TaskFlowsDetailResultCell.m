//
//  TaskFlowsDetailResultCell.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/5.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsDetailResultCell.h"

@interface TaskFlowsDetailResultCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@end


@implementation TaskFlowsDetailResultCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    @weakify(self);
    
    [RACObserve(self, replyModel) subscribeNext:^(TaskFlowsReplyModel * _Nullable x) {
          
        @strongify(self);
        
        self.lb_time.text = [ShareFun timeWithTimeInterval:x.createTime];
        self.lb_content.text = [ShareFun takeStringNoNull:x.replyContent];
          
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

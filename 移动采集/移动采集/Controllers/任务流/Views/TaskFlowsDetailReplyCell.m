//
//  TaskFlowsDetailReplyCell.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/5.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsDetailReplyCell.h"

@interface TaskFlowsDetailReplyCell ()


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_top;

@property (weak, nonatomic) IBOutlet UILabel *lb_count;
@property (weak, nonatomic) IBOutlet UIView *v_line;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_count;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_content;
@property (weak, nonatomic) IBOutlet UIView *v_topimage;

@end

@implementation TaskFlowsDetailReplyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    
    [RACObserve(self, result) subscribeNext:^(TaskFlowsDetailReponse * _Nullable x) {
           
        @strongify(self);
           
        if (x.taskDetail.replyCount) {
            self.lb_count.text = [NSString stringWithFormat:@"%d条动态",[x.taskDetail.replyCount intValue]];
        }
        
     }];
    
    [RACObserve(self, replyModel) subscribeNext:^(TaskFlowsReplyModel * _Nullable x) {
          
        @strongify(self);
         
        self.lb_name.text = [NSString stringWithFormat:@"转发:%@",x.receiveUserName];
        self.lb_time.text = [ShareFun timeWithTimeInterval:x.createTime];
        self.lb_content.text = [ShareFun takeStringNoNull:x.replyContent];
          
    }];
    
    [RACObserve(self, first) subscribeNext:^(NSNumber * _Nullable x) {
          
        @strongify(self);
        
        if ([x boolValue]) {
            
            self.layout_top.constant = 67.f;
            self.lb_count.hidden = NO;
            self.imageV_count.hidden = NO;
            self.v_line.hidden = NO;
            self.v_topimage.hidden = NO;
            
        }else{
            
            self.layout_top.constant = 0.f;
            self.lb_count.hidden = YES;
            self.imageV_count.hidden = YES;
            self.v_line.hidden = YES;
            self.v_topimage.hidden = YES;
            
        }
          
    }];
       
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

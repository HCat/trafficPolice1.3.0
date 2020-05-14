//
//  TaskFlowsTrafficPermitCell.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/11.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsTrafficPermitCell.h"
#import <UIImageView+WebCache.h>

@interface TaskFlowsTrafficPermitCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_user;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_start;

@property (weak, nonatomic) IBOutlet UILabel *lb_end;

@property (weak, nonatomic) IBOutlet UIImageView *imageV_first;
@property (weak, nonatomic) IBOutlet UILabel *lb_first;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_second;
@property (weak, nonatomic) IBOutlet UILabel *lb_second;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_bottom;

@end



@implementation TaskFlowsTrafficPermitCell

- (void)awakeFromNib {
    [super awakeFromNib];
    @weakify(self);
    
    [RACObserve(self, result) subscribeNext:^(TaskFlowsDetailReponse * _Nullable x) {
        
        @strongify(self);
        
        if (x.taskDetail.carNo || x.taskDetail.complaintPhone) {
            self.lb_user.text = [NSString stringWithFormat:@"车牌号：%@ 手机号：%@",x.taskDetail.carNo,x.taskDetail.complaintPhone];
        }
        
        self.lb_time.text = [ShareFun timeWithTimeInterval:x.taskDetail.createTime];
        
        self.lb_start.text = [ShareFun takeStringNoNull:x.taskDetail.startPoint];

        self.lb_end.text = [ShareFun takeStringNoNull:x.taskDetail.endPoint];
        
        
        for (int i = 0; i < x.pictureList.count; i++) {
            NSString * imageUrl = x.pictureList[i];
            if (i == 0) {
                [self.imageV_first sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
            }else{
                 [self.imageV_second sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
            }
           
        }
        
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

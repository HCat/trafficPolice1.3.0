//
//  JointVideoCell.m
//  移动采集
//
//  Created by hcat on 2017/11/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "JointVideoCell.h"
#import "JointEnforceVC.h"
#import "JointVideoVC.h"

@interface JointVideoCell()

@property (nonatomic,strong) UIView *t_view;


@end

@implementation JointVideoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

#pragma mark - set && get

- (void)setVideoModel:(JointLawVideoModel *)videoModel{

    _videoModel = videoModel;
    
    if (_videoModel) {
        
        
        
        
        
    
    }

}

#pragma mark - 添加视频按钮事件

- (IBAction)handleBtnVideaAddClicked:(id)sender {
    
    JointEnforceVC *t_vc = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    JointVideoVC *t_videoAddVC = [[JointVideoVC alloc] init];
    t_videoAddVC.oldVideoId = _videoModel.videoId;
    t_videoAddVC.block = ^(JointLawVideoModel *video) {
    
         [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOADJOINTLAWVIDEO object:video];
    };
    [t_vc.navigationController  pushViewController:t_videoAddVC animated:YES];
    
    
}



#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    LxPrintf(@"JointVideoCell dealloc");
    
}

@end

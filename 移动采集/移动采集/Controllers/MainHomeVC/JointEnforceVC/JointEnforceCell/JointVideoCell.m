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
#import "VideoDetailVC.h"
#import "LRPlayVC.h"

#import <UIButton+WebCache.h>

@interface JointVideoCell()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_bottom;
@property (weak, nonatomic) IBOutlet UIView *v_video;
@property (weak, nonatomic) IBOutlet UIButton *btn_videoPlay;


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
        self.layout_bottom.constant = 178.5f;
        _v_video.hidden = NO;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
        UIImage *image = [UIImage imageWithContentsOfFile:_videoModel.videoImg];
        [_btn_videoPlay setImage:image forState:UIControlStateNormal];
    
    }else{
        self.layout_bottom.constant = 30.f;
        _v_video.hidden = YES;
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];
        
    }

}

#pragma mark - 添加视频按钮事件

- (IBAction)handleBtnVideaAddClicked:(id)sender {
    
    WS(weakSelf);
    
    JointEnforceVC *t_vc = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    JointVideoVC *t_videoAddVC = [[JointVideoVC alloc] init];
    t_videoAddVC.oldVideoId = _videoModel.videoId;
    t_videoAddVC.block = ^(JointLawVideoModel *video) {
        SW(strongSelf, weakSelf);
        strongSelf.block(video);
        
    };
    [t_vc.navigationController  pushViewController:t_videoAddVC animated:YES];
    
    
}

#pragma mark - 点击播放按钮事件

- (IBAction)handleBtnPlayVideoClicked:(id)sender {
    
    JointEnforceVC *vc_target = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    
    LRPlayVC *t_vc = [[LRPlayVC alloc] init];
    t_vc.videoUrl = self.videoModel.videoPath;
    t_vc.isNeedDeleteBtn = NO;
    [vc_target.navigationController pushViewController:t_vc animated:YES];
    
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

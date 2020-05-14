//
//  TaskFlowsDetailBackWorkCell.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/5.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsDetailBackWorkCell.h"
#import "NSArray+MASConstraint.h"
#import "KSPhotoBrowser.h"
#import <UIButton+WebCache.h>
#import "ZQPlayer.h"


@interface TaskFlowsDetailBackWorkCell()

@property (weak, nonatomic) IBOutlet UIButton *btn_voice;
@property (weak, nonatomic) IBOutlet UILabel *lb_voice;

@property (weak, nonatomic) IBOutlet UILabel *lb_content;

@property (weak, nonatomic) IBOutlet UILabel *lb_user;

@property (weak, nonatomic) IBOutlet UILabel *lb_type;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_bottom;

/** 音频播放器 */
@property (nonatomic, strong) ZQPlayer * audioPlayer;

@property (weak, nonatomic) IBOutlet UIView *v_photos;
@property (strong, nonatomic) NSMutableArray *arr_buttons;

@end

@implementation TaskFlowsDetailBackWorkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    self.arr_buttons = @[].mutableCopy;
    
    [RACObserve(self, result) subscribeNext:^(TaskFlowsDetailReponse * _Nullable x) {
        
        @strongify(self);
        
        if (x.taskDetail.complaintName || x.taskDetail.complaintPhone) {
            self.lb_user.text = [NSString stringWithFormat:@"%@ %@",x.taskDetail.complaintName,x.taskDetail.complaintPhone];
        }
        
        self.lb_time.text = [ShareFun timeWithTimeInterval:x.taskDetail.createTime];
        
        self.lb_content.text = [ShareFun takeStringNoNull:x.taskDetail.content];
        
        if (x.voiceSource && x.voiceSource.length > 0) {
            self.btn_voice.hidden = NO;
            self.lb_voice.hidden = NO;
            self.layout_bottom.constant = 105.f;
            [self.contentView layoutIfNeeded];
        }else{
            self.btn_voice.hidden = YES;
            self.lb_voice.hidden = YES;
            self.layout_bottom.constant = 17.f;
            [self.contentView layoutIfNeeded];
        }
        
        if (self.arr_buttons && self.arr_buttons.count == 0) {
            for (int i = 0; i < x.pictureList.count; i++) {
                NSString * imageUrl = x.pictureList[i];
                UIButton * t_button = [[UIButton alloc] init];
                [t_button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
                
                t_button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                t_button.tag = 1000+i;
                [[t_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                    @strongify(self);
                    UIButton * button = (UIButton *)x;
                    NSMutableArray *t_arr = [NSMutableArray array];
                    
                    for (int i = 0; i < self.arr_buttons.count; i++) {
                        UIButton * btn = self.arr_buttons[i];
                        NSString * imageUrl = self.result.pictureList[i];
                        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:imageUrl]];
                        [t_arr addObject:item];
                    }
                    
                    [self.result.taskDetail showPhotoBrowser:t_arr inView:self withTag:(button.tag - 1000)];
                    
                }];
                [self.v_photos addSubview:t_button];
                [self.arr_buttons addObject:t_button];
            }
            if (self.v_photos.subviews.count > 0) {
                CGFloat height = (SCREEN_WIDTH - 15 * 4)/3;
                [self.v_photos.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:height
                                                                   fixedLineSpacing:5 fixedInteritemSpacing:5
                                                                          warpCount:3
                                                                         topSpacing:10
                                                                      bottomSpacing:10 leadSpacing:10 tailSpacing:10];
            }
        }
        
    }];
    
    [[self.btn_voice rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        if (self.result.voiceSource && self.result.voiceSource.length > 0) {
      
            if (self.audioPlayer == nil) {
                self.audioPlayer = [[ZQPlayer alloc] initWithUrl:self.result.voiceSource];
                [self.audioPlayer setDelegate:(id<ZQPlayerDelegate>)self];
            }
            
            if (self.audioPlayer.isPlaying) {
                [self.audioPlayer stop];
            }
            [self.audioPlayer play];
            
        }
    
    }];
    
}

- (void)ZQPlayerStateChange:(ZQPlayer *)player state:(ZQPlayerState)state{
    
    if (state == ZQPlayerStateStop) {
        [self.btn_voice setTitle:@"点击播放" forState:UIControlStateNormal];
    }else if (state == ZQPlayerStatePlaying) {
        [self.btn_voice setTitle:@"正在播放" forState:UIControlStateNormal];
    }else if (state == ZQPlayerStateFailed) {
        [self.btn_voice setTitle:@"播放失败" forState:UIControlStateNormal];
    }

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
  if (self.audioPlayer.isPlaying) {
      [self.audioPlayer stop];
  }
  self.audioPlayer = nil;
    
}


@end

//
//  VideoListCell.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "VideoListCell.h"
#import <UIImageView+WebCache.h>
#import "ShareFun.h"

@interface VideoListCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageV_preview;

@property (weak, nonatomic) IBOutlet UILabel *lb_length;
@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;



@end

@implementation VideoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(VideoColectListModel *)model{

    _model = model;
    
    if (_model) {
        
        [self.imageV_preview sd_setImageWithURL:[NSURL URLWithString:_model.previewUrl]];
        self.lb_address.text = _model.address;
        self.lb_time.text = [ShareFun timeWithTimeInterval:_model.collectTime];
        self.lb_length.text = [self timeFormatted:_model.videoLength];
        
    }
    
}

- (NSString *)timeFormatted:(NSNumber *)second
{
    int totalSeconds = [second intValue];
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    
    
    return [NSString stringWithFormat:@"%02d:%02d", minutes, seconds];
}

@end

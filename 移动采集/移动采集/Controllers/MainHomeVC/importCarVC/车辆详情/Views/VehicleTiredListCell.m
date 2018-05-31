//
//  VehicleTiredListCell.m
//  移动采集
//
//  Created by hcat on 2018/5/24.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleTiredListCell.h"
#import <UIImageView+WebCache.h>
#import "ShareFun.h"

@interface VehicleTiredListCell()




@property (weak, nonatomic) IBOutlet UILabel *lb_time;


@end



@implementation VehicleTiredListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setModel:(VehicleTiredImageModel *)model{
    
    _model = model;
    
    if (_model) {
        
        NSString *url = [_model.url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [_imageV_preview sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
        _lb_time.text =[ShareFun timeWithTimeInterval:_model.createDate dateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }

}


@end

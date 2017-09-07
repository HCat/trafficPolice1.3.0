//
//  VehicleRemarkCell.m
//  移动采集
//
//  Created by hcat-89 on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleRemarkCell.h"

@interface VehicleRemarkCell ()

@property (nonatomic,weak) IBOutlet UILabel * lb_createTime;         //驾驶员姓名
@property (nonatomic,weak) IBOutlet UILabel * lb_name;                //驾驶员性别 1：男 2：女
@property (nonatomic,weak) IBOutlet UILabel * lb_content;         //驾驶证号码

@end

@implementation VehicleRemarkCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}


- (void)setRemark:(VehicleRemarkModel *)remark{

    _remark = remark;
    
    if (_remark) {
        _lb_createTime.text = [ShareFun timeWithTimeInterval:_remark.createTime dateFormat:@"yyyy年MM月dd日"];
        _lb_name.text = _remark.name;
        _lb_content.text = _remark.content;
    }

}

#pragma mark -dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{

    LxPrintf(@"VehicleRemarkCell dealloc");

}

@end

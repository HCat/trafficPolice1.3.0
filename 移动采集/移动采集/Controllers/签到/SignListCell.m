//
//  SignListCell.m
//  移动采集
//
//  Created by hcat on 2017/9/4.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "SignListCell.h"

@interface SignListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgv_beforeLine;

@property (weak, nonatomic) IBOutlet UIImageView *imgV_afterLine;

@property (weak, nonatomic) IBOutlet UILabel *lb_smallTip;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;

@end


@implementation SignListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _lb_smallTip.layer.cornerRadius = 9.f;
    _lb_smallTip.layer.masksToBounds = YES;
    
}


#pragma mark - set&&get

- (void)setSignModel:(SignModel *)signModel{

    _signModel = signModel;
    
    if (_signModel) {
        
        if ([_signModel.workstate isEqualToNumber:@1]) {
            //已签到
            _lb_smallTip.text = @"上";
            _imgv_beforeLine.hidden = YES;
            _imgV_afterLine.hidden = NO;
            _lb_time.text = [ShareFun timeWithTimeInterval:_signModel.createTime dateFormat:@"MM-dd HH:mm:ss"];
            _lb_address.text = _signModel.address;
            
        }else{
            //已签退
            _lb_smallTip.text = @"下";
            _imgv_beforeLine.hidden = NO;
            _imgV_afterLine.hidden = YES;
            _lb_time.text = [ShareFun timeWithTimeInterval:_signModel.createTime dateFormat:@"MM-dd HH:mm:ss"];
            _lb_address.text = _signModel.address;
        
        }
    
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{

    LxPrintf(@"SignListCell dealloc");
    
}

@end

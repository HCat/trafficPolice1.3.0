//
//  AttendanceSignInCell.m
//  移动采集
//
//  Created by hcat on 2019/4/4.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "AttendanceSignInCell.h"

@interface AttendanceSignInCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_smallTip;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;


@end




@implementation AttendanceSignInCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lb_smallTip.layer.cornerRadius = 3.f;
    _lb_smallTip.layer.borderWidth = 1.f;
    _lb_smallTip.layer.borderColor = UIColorFromRGB(0x3396FC).CGColor;
    _lb_smallTip.layer.masksToBounds = YES;
    
    @weakify(self);
    [RACObserve(self, viewModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([self.viewModel.workstate isEqualToNumber:@1]) {
            self.lb_smallTip.text = @"上班";
        }else{
            self.lb_smallTip.text = @"下班";
        }
        
        self.lb_time.text = [ShareFun timeWithTimeInterval:self.viewModel.createTime dateFormat:@"yyyy年MM月dd日 HH:mm:ss"];
        self.lb_address.text = self.viewModel.address;
        
    }];
    
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

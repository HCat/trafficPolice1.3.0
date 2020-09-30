//
//  VehicleMemberNoShowCell.m
//  移动采集
//
//  Created by hcat-89 on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleMemberNoShowCell.h"
#import <PureLayout.h>
#import "CALayer+Additions.h"

@interface VehicleMemberNoShowCell ()

@property (nonatomic,weak) IBOutlet UILabel * lb_name;               //运输主体名称
@property (nonatomic,weak) IBOutlet UILabel * lb_memtype;            //运输主体性质:1土方车 2水泥砼车 3砂石子车

@property (weak, nonatomic) IBOutlet UIView *v_backgound;

@end


@implementation VehicleMemberNoShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setMemberInfo:(MemberInfoModel *)memberInfo{
    
    _memberInfo = memberInfo;
    
    if (_memberInfo) {
        
        _lb_name.text = [ShareFun takeStringNoNull:_memberInfo.name];   //运输主体名称
        //车辆类型:1土方车 2水泥砼车 3砂石子车
        if ([_memberInfo.memtype isEqualToNumber:@1]) {
            _lb_memtype.text = @"土方车";
        }else if ([_memberInfo.memtype isEqualToNumber:@2]){
            _lb_memtype.text = @"水泥砼车";
        }else{
            _lb_memtype.text = @"砂石子车";
        }
        
    }
    
}


#pragma mark - 按钮事件

- (IBAction)handleBtnShowMoreClicked:(id)sender {
    
    if (self.block) {
        self.block();
    }
    
    
}

#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    
    LxPrintf(@"VehicleMemberNoShowCell dealloc");

}

@end

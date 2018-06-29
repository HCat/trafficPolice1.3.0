//
//  AddressBookCell.m
//  移动采集
//
//  Created by hcat on 2017/10/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AddressBookCell.h"
#import "AlertView.h"
#import "DutyAPI.h"

#define random(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.f]


@interface AddressBookCell()

@property (weak, nonatomic) IBOutlet UILabel *lb_tip;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UIButton *btn_phone;




@end

@implementation AddressBookCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(AddressBookModel *)model{

    _model = model;
    
    if (_model) {
        
        if (_model.canDial) {
            _btn_phone.enabled = YES;
        }else{
            _btn_phone.enabled = NO;
        }
        
        _lb_name.text = _model.realName;
        _lb_tip.text = [_model.realName substringWithRange:NSMakeRange(_model.realName.length - 1, 1)];
        _lb_tip.layer.cornerRadius = 18.f;
        _lb_tip.layer.masksToBounds = YES;
        _lb_tip.backgroundColor = DefaultColor;
        
    }

}

#pragma mark - buttonAction

- (IBAction)handleBtnPhoneClicked:(id)sender {
    
    DutyPeopleModel *t_model = [[DutyPeopleModel alloc] init];
    t_model.realName = _model.realName;
    t_model.telNum = _model.telNum;
    t_model.name = _model.name;
    [AlertView showWindowWithMakePhoneViewWith:t_model];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

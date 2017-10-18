//
//  AddressBookCell.m
//  移动采集
//
//  Created by hcat on 2017/10/18.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AddressBookCell.h"

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
        _lb_tip.text = [_model.realName substringWithRange:NSMakeRange(0, 1)];
        NSArray *t_arr = [[NSArray alloc] initWithObjects:@0xfa6166,@0x29a6e6,@0xfbae50,@0x747dee,nil];
        
        int r = arc4random() % [t_arr count];
        
        NSNumber *t_num = t_arr[r];
        
        _lb_tip.backgroundColor = UIColorFromRGB([t_num intValue]);
        
    }

}

#pragma mark - buttonAction

- (IBAction)handleBtnPhoneClicked:(id)sender {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"telprompt://%@",_model.telNum];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

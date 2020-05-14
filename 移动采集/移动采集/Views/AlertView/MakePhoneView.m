//
//  MakePhoneView.m
//  移动采集
//
//  Created by hcat on 2018/6/28.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "MakePhoneView.h"

@interface MakePhoneView()

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@end


@implementation MakePhoneView

+ (MakePhoneView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"MakePhoneView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}


- (void)setPeople:(DutyPeopleModel *)people{
    _people = people;
    
    if (_people) {
        _lb_name.text = _people.realName;
    }

}

- (IBAction)handleBtnTakePhoneClicked:(id)sender {
    
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",_people.telNum];
    //            NSLog(@"str======%@",str);
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
    
}


@end

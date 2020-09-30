//
//  PoliceDetailDisAnnotationView.m
//  移动采集
//
//  Created by hcat on 2018/11/19.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceDetailDisAnnotationView.h"

@interface PoliceDetailDisAnnotationView ()

@property (weak, nonatomic) IBOutlet UILabel *lb_policeGroup;
@property (weak, nonatomic) IBOutlet UILabel *lb_policeInstitution;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (nonatomic, strong) UIWindow *keyWindow;

@end


@implementation PoliceDetailDisAnnotationView

+ (PoliceDetailDisAnnotationView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PoliceDetailDisAnnotationView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    [RACObserve(self, policeModel) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.lb_name.text = [ShareFun takeStringNoNull:self.policeModel.userName];
        self.lb_policeGroup.text =[ShareFun takeStringNoNull:[self.policeModel.groupNames componentsJoinedByString:@","]];
        self.lb_policeInstitution.text = [ShareFun takeStringNoNull:self.policeModel.departmentName];
        
    }];
    
}


- (IBAction)handleBtnPhoneCallClicked:(id)sender {
    NSMutableString * str=[[NSMutableString alloc] initWithFormat:@"tel://%@",self.policeModel.telNum];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    
}

- (IBAction)handleBtnHideClicked:(id)sender {
    
    [self hide];
}


- (void)show{
    
    self.keyWindow = [[UIWindow alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    _keyWindow.backgroundColor = [UIColor clearColor];
    _keyWindow.windowLevel = UIWindowLevelAlert;
    
    self.frame = _keyWindow.bounds;
    
    [_keyWindow addSubview:self];
    [_keyWindow makeKeyAndVisible];
    
}

- (void)hide{
    
    [self removeFromSuperview];
    if (self.keyWindow) {
        [self.keyWindow resignKeyWindow];
        [[UIApplication sharedApplication].delegate.window makeKeyWindow];
    }
    
}

- (void)dealloc{
    
    LxPrintf(@"PoliceDetailDisAnnotationView dealloc");
    
}


@end

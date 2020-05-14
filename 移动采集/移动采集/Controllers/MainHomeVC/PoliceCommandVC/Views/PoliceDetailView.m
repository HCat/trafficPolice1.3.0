//
//  PoliceDetailView.m
//  移动采集
//
//  Created by hcat-89 on 2017/9/15.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "PoliceDetailView.h"

@interface PoliceDetailView()

@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_group;


@end



@implementation PoliceDetailView

+ (PoliceDetailView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PoliceDetailView" owner:self options:nil];
    
    PoliceDetailView * t_view = [nibView objectAtIndex:0];
    return t_view;
}

- (void)dismiss{
    [self removeFromSuperview];
    
}

- (void)setPoliceName:(NSString *)policeName{

    _policeName = policeName;
    
    _lb_name.text = _policeName;
}

- (void)setPoliceGroup:(NSString *)policeGroup{
    _policeGroup = policeGroup;
    _lb_group.text = (_policeGroup ==nil && _policeGroup.length == 0) ? @" ":_policeGroup;

}

- (IBAction)handleBtnCancleClicked:(id)sender {
    [self dismiss];
    
}

#pragma mark - dealloc

- (void)dealloc{
    
    LxPrintf(@"PoliceDetailView dealloc");
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

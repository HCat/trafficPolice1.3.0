//
//  PoliceCarDetailView.m
//  移动采集
//
//  Created by hcat on 2018/4/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "PoliceCarDetailView.h"

@interface PoliceCarDetailView()

@property (weak, nonatomic) IBOutlet UILabel *lb_carName;

@end


@implementation PoliceCarDetailView

+ (PoliceCarDetailView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"PoliceCarDetailView" owner:self options:nil];
    
    PoliceCarDetailView * t_view = [nibView objectAtIndex:0];
    return t_view;
}

- (void)dismiss{
    [self removeFromSuperview];
    
}

- (void)setPoliceCarName:(NSString *)policeCarName{
    
    _policeCarName = policeCarName;
    
    _lb_carName.text = _policeCarName;
}



- (IBAction)handleBtnCancleClicked:(id)sender {
    [self dismiss];
    
}

#pragma mark - dealloc

- (void)dealloc{
    
    LxPrintf(@"PoliceCarDetailView dealloc");
    
}
@end

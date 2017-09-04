//
//  SignInCell.m
//  移动采集
//
//  Created by hcat on 2017/9/4.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "SignInCell.h"
#import "NSTimer+UnRetain.h"
#import "UserModel.h"

@interface SignInCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_smalltip; //
@property (weak, nonatomic) IBOutlet UILabel *lb_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_tip;
@property (weak, nonatomic) IBOutlet UILabel *lb_time;
@property (weak, nonatomic) IBOutlet UIImageView *img_line;
@property (nonatomic,strong) NSTimer *timer;

@end


@implementation SignInCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    _lb_smalltip.layer.cornerRadius = 9.f;
    _lb_smalltip.layer.masksToBounds = YES;
    
   
    
    
}

- (void)setWorkstate:(BOOL)workstate{

    _workstate = workstate;
    
    if (_workstate == YES) {
        _lb_smalltip.text = @"下";
        _lb_title.text = @"签退";
        _lb_tip.text = @"下班打卡";
        _img_line.hidden = NO;
        
    }else{
        _lb_smalltip.text = @"上";
        _lb_title.text = @"签到";
        _lb_tip.text = @"上班打卡";
        _img_line.hidden = YES;
        
    }



}



- (void)setCurrentDate:(NSDate *)currentDate{
    
    WS(weakSelf);
    _currentDate = currentDate;
    
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
    
    if (_timer == nil) {
        self.timer = [NSTimer lr_scheduledTimerWithTimeInterval:1.0 repeats:YES block:^(NSTimer *timer) {
            [weakSelf updateTime];
        }];
        
        [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
    }


}


-(void)updateTime{
    
    _currentDate = [NSDate dateWithTimeInterval:1 sinceDate:_currentDate];
    NSDateFormatter *dataFormatter = [[NSDateFormatter alloc]init];
    
    [dataFormatter setDateFormat:@"HH:mm:ss"];
    
    NSString *dateString = [dataFormatter stringFromDate:_currentDate];
    
    _lb_time.text = dateString;
    
}


- (IBAction)handleBtnSignInClicked:(id)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(handleBtnSignInOrOut)]) {
        [self.delegate handleBtnSignInOrOut];
    }
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{

    LxPrintf(@"SignInCell dealloc");

}


@end

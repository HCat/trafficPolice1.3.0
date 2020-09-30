//
//  IllegalCollectListCell.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalCollectListCell.h"

@interface IllegalCollectListCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_roadName;

@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_statues;

@end



@implementation IllegalCollectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setModel:(IllegalParkListModel *)model{
    
    _model = model;
    
    if (_model) {
        
        
        _lb_carNumber.text = [ShareFun takeStringNoNull:_model.carNo];
        
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        formatter.timeZone = [NSTimeZone timeZoneWithName:@"shanghai"];
        [formatter setDateStyle:NSDateFormatterMediumStyle];
        [formatter setTimeStyle:NSDateFormatterShortStyle];
        [formatter setDateFormat:@"yyyy/MM/dd HH:mm:ss"];
        
        // 毫秒值转化为秒
        NSDate* date = [NSDate dateWithTimeIntervalSince1970:[_model.collectTime doubleValue]/ 1000.0];
        NSString* dateString = [formatter stringFromDate:date];
        
        _lb_time.text = [NSString stringWithFormat:@"时间：%@",dateString];
        _lb_roadName.text = [NSString stringWithFormat:@"路名：%@",_model.roadName];
        if (_model.sendStatus == 1) {
            
            _lb_statues.text = @"已通知";
            [_lb_statues setTextColor:UIColorFromRGB(0x9A9A9A)];
            _lb_statues.layer.borderWidth = 1.f;
            _lb_statues.layer.borderColor = UIColorFromRGB(0x9A9A9A).CGColor;
            
        }else{
        
            _lb_statues.text = @"未通知";
            [_lb_statues setTextColor:UIColorFromRGB(0x3496FC)];
            _lb_statues.layer.borderWidth = 1.f;
            _lb_statues.layer.borderColor = UIColorFromRGB(0x3496FC).CGColor;
            
        }
        
        
    }
    
}

- (void)setModel_exposure:(ExposureCollectListModel *)model_exposure{
    
    _model_exposure = model_exposure;
    
    if (_model_exposure) {
        
        _lb_roadName.text = [NSString stringWithFormat:@"路名：%@",_model_exposure.roadName];
        if ([_model_exposure.remarkNoCar intValue] == 0) {
            _lb_carNumber.text = @"无牌";
        }else{
            _lb_carNumber.text = [ShareFun takeStringNoNull:_model_exposure.carNo];
        }
        
        _lb_time.text = [NSString stringWithFormat:@"时间：%@",[ShareFun timeWithTimeInterval:_model_exposure.collectTime]];
        
        
        
        _lb_statues.hidden = YES;

    }
    
}



@end

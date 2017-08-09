//
//  AccidentPartyCell.h
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentAPI.h"
@class AccidentPartyCell;

typedef void(^AccidentPartyCellBlock)();

@interface AccidentPartyCell : UITableViewCell

@property(nonatomic,strong) AccidentModel *accident;
@property (nonatomic,strong) AccidentVoModel *accidentVo;  //是否扣留对象 是否扣留车辆、驾驶证、行驶证、身份证放此对象中
@property (nonatomic,copy) AccidentPartyCellBlock block;
@property (nonatomic,assign)AccidentType accidentType; //类型


- (float)heightWithAccident;

@end

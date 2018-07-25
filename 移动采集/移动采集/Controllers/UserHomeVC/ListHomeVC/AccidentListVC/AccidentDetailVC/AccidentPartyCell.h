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

@property(nonatomic,strong) NSArray <AccidentPeopleModel *> * list;
@property (nonatomic,copy) AccidentPartyCellBlock block;
@property (nonatomic,assign)AccidentType accidentType; //类型


- (float)heightWithAccident;

@end

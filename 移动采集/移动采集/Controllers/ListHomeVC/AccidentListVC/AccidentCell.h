//
//  AccidentCell.h
//  trafficPolice
//
//  Created by hcat on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentListModel.h"

@interface AccidentCell : UITableViewCell


@property (nonatomic,assign) AccidentType accidentType;
@property (nonatomic,strong) AccidentListModel *model;

@end

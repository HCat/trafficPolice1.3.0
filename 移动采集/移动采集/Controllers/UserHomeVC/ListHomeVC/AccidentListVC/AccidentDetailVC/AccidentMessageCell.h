//
//  AccidentMessageCell.h
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentAPI.h"


@interface AccidentMessageCell : UITableViewCell

@property(nonatomic,strong) AccidentModel *accident;


- (float)heightWithAccident;

@end

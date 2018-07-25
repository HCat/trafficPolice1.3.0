//
//  AccidentInfoCell.h
//  移动采集
//
//  Created by hcat on 2018/7/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentUpFactory.h"
#import "AccidentAPI.h"

@interface AccidentInfoCell : UITableViewCell

@property (nonatomic,assign) AccidentType accidentType;     //事故纠纷类型
@property (nonatomic,strong) AccidentUpFactory *partyFactory;    //当事人信息的管理类

- (CGFloat)heightOfCell;

@end

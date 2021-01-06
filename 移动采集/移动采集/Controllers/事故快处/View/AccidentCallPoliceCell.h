//
//  AccidentCallPoliceCell.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccidentUpFactory.h"
#import "AccidentAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccidentCallPoliceCell : UITableViewCell

@property (nonatomic,assign) AccidentType accidentType;     //事故纠纷类型
@property (nonatomic,strong) AccidentUpFactory *partyFactory;    //当事人信息的管理类

@end

NS_ASSUME_NONNULL_END

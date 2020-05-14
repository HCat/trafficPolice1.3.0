//
//  VehicleMemberNoShowCell.h
//  移动采集
//
//  Created by hcat-89 on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberInfoModel.h"

typedef void(^VehicleMemberShowBlock)();

@interface VehicleMemberNoShowCell : UITableViewCell

@property (nonatomic,strong) MemberInfoModel * memberInfo;
@property (nonatomic,copy) VehicleMemberShowBlock block;

@end

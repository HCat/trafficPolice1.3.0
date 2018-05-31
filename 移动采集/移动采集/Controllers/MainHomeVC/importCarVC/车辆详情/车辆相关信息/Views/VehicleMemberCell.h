//
//  VehicleMemberCell.h
//  移动采集
//
//  Created by hcat-89 on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MemberInfoModel.h"
#import "VehicleAPI.h"

typedef void(^VehicleMemberNoShowBlock)(void);

@interface VehicleMemberCell : UITableViewCell

@property (nonatomic,strong) MemberInfoModel * memberInfo;
@property (nonatomic,copy) NSString *memberArea;
@property (nonatomic,strong) NSArray <VehicleImageModel *> * imagelists;


@property (nonatomic,copy) VehicleMemberNoShowBlock block;

@end

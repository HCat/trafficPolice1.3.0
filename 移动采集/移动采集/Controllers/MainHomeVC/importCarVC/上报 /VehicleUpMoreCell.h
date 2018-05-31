//
//  VehicleUpMoreCell.h
//  移动采集
//
//  Created by hcat on 2018/5/18.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "VehicleAPI.h"

typedef void(^handleBtnUpClickedBlock)(void);

@interface VehicleUpMoreCell : UITableViewCell

@property (nonatomic,strong) VehicleCarlUpParam * param;
@property (nonatomic, copy) NSString * remark;
@property(nonatomic,strong) NSMutableArray <NSString *> * tags;
@property(nonatomic,strong) NSMutableArray <NSNumber *> * tagIndexs;
@property(nonatomic,assign) BOOL isCanCommit;
@property(nonatomic,copy) handleBtnUpClickedBlock upBlock;

@end

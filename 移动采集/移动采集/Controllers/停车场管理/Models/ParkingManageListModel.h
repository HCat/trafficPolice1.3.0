//
//  ParkingManageListModel.h
//  移动采集
//
//  Created by hcat on 2019/9/19.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParkingManageListModel : NSObject

@property(nonatomic,strong) NSNumber * parkingId;     //编号
@property(nonatomic,copy) NSString * yardName;     //车场名称
@property(nonatomic,strong) NSNumber * status;     //出入库状态    0入库1出库
@property(nonatomic,copy) NSString * detainDateStr;     //入库时间
@property(nonatomic,copy) NSString * mandatoryNo;     //强制单号
@property(nonatomic,copy) NSString * carNo;     //车牌号


@end

NS_ASSUME_NONNULL_END

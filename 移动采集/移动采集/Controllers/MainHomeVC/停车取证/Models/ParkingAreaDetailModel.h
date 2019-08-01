//
//  ParkingAreaDetailModel.h
//  移动采集
//
//  Created by hcat on 2019/7/28.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ParkingAreaDetailModel : NSObject

@property (nonatomic,copy) NSString * starttime;  //入场时间
@property (nonatomic,copy) NSString * endtime;  //当前时间
@property (nonatomic,copy) NSString * needpay;  //应付金额
@property (nonatomic,copy) NSString * payamount;  //已支付金额
@property (nonatomic,copy) NSString * parkingtimeStr;  //停留时间
@property (nonatomic,copy) NSString * arrneedpay;  //欠费金额



@end

NS_ASSUME_NONNULL_END

//
//  DeliveryIllegalModel.h
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryIllegalModel : NSObject

@property (nonatomic,copy) NSString * reportId;            //记录编号
@property (nonatomic,strong) NSNumber * deduction;         //扣分
@property (nonatomic,copy) NSString * illegalName;         //违法名称

@end

NS_ASSUME_NONNULL_END

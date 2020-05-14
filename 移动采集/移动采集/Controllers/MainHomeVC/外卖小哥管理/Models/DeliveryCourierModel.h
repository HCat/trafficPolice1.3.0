//
//  DeliveryCourierModel.h
//  移动采集
//
//  Created by hcat on 2019/5/8.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryCourierModel : NSObject

@property (nonatomic,copy) NSString * deliveryId;
@property (nonatomic,copy) NSString * creator;
@property (nonatomic,strong) NSNumber * createTime;
@property (nonatomic,copy) NSString * updator;
@property (nonatomic,strong) NSNumber * updateTime;
@property (nonatomic,copy) NSString * courierNo;
@property (nonatomic,copy) NSString * name;
@property (nonatomic,copy) NSString * telephone;
@property (nonatomic,copy) NSString * licenseNo;
@property (nonatomic,strong) NSNumber * score;
@property (nonatomic,strong) NSNumber * scoreCount;
@property (nonatomic,copy) NSString * orgNo;
@property (nonatomic,copy) NSString * remark;

@end

NS_ASSUME_NONNULL_END

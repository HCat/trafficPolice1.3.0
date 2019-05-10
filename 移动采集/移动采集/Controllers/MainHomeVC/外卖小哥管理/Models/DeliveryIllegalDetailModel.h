//
//  DeliveryIllegalDetailModel.h
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DeliveryIllegalImageModel : NSObject

@property(nonatomic,copy) NSString * imgUrl;

@end

@interface DeliveryIllegalCollectModel : NSObject

@property(nonatomic,copy)    NSString * collectTime;       //上报时间
@property(nonatomic,copy)    NSString * address;           //所在位置
@property(nonatomic,copy)    NSString * illegalType;       //违法类型
@property(nonatomic,copy)    NSString * roadName;          //道路名称
@property(nonatomic,strong)  NSNumber * roadId;            //道路ID
@property(nonatomic,copy)    NSString * addressRemark;            //备注

@end


@interface DeliveryIllegalDetailModel : NSObject

@property(nonatomic,strong)  DeliveryIllegalCollectModel * illegalCollect;       //上报时间
@property(nonatomic,strong)  NSArray <DeliveryIllegalImageModel *> * picList; //快递员绑定企业列表

@end

NS_ASSUME_NONNULL_END

//
//  DailyPatroInfoModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/1/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DailyPatroInfoModel : NSObject

@property(copy, nonatomic) NSString * wayName;  //线路名称
@property(strong, nonatomic) NSNumber * distance;  //距离
@property(strong, nonatomic) NSNumber * points;  //途径点数
@property(strong, nonatomic) NSNumber * expTime;  //花费时间

@end

NS_ASSUME_NONNULL_END

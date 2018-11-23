//
//  PoliceLocationModel.h
//  移动采集
//
//  Created by hcat on 2018/11/14.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoliceLocationModel : NSObject

@property (nonatomic, strong) NSNumber * latitude;
@property (nonatomic, strong) NSNumber * longitude;
@property (nonatomic, assign) BOOL isSelected;          //是否被选中

@end

NS_ASSUME_NONNULL_END

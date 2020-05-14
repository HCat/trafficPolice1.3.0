//
//  vehicleRemarkModel.h
//  移动采集
//
//  Created by hcat on 2017/9/5.
//  Copyright © 2017年 Hcat. All rights reserved.
//

//**************   车辆备注记录 *****************//

#import <Foundation/Foundation.h>

@interface VehicleRemarkModel : NSObject

@property (nonatomic,strong) NSNumber * createTime;    //记录时间
@property (nonatomic,copy)   NSString * name;          //记录人名称
@property (nonatomic,copy)   NSString * content;       //内容

@end

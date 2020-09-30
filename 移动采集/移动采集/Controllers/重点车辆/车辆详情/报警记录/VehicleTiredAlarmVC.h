//
//  VehicleTiredAlarmVC.h
//  移动采集
//
//  Created by hcat on 2018/5/24.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface VehicleTiredAlarmVC : HideTabSuperVC

@property(nonatomic,copy) NSString * plateNo;    //车牌    车牌号
@property(nonatomic,copy) NSString * startTime;  //图片开始时间    字符串‘2018-05-03 14:59:06’
@property(nonatomic,copy) NSString * endTime;    //图片结束时间    字符串‘2018-05-03 15:59:06’



@end

//
//  VehicleDetailVC.h
//  移动采集
//
//  Created by hcat on 2017/9/7.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"

typedef NS_ENUM(NSInteger, VehicleRequestType) {
    VehicleRequestTypeQRCode,      //二维码
    VehicleRequestTypeCarNumber,   //车牌号码
};



@interface VehicleDetailVC : HideTabSuperVC

@property (nonatomic,assign) VehicleRequestType type;
@property (nonatomic,copy) NSString *NummberId;   //查询号，可以是车牌号也可以是二维码

@end

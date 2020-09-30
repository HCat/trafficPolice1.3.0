//
//  VehicleCarMoreVC.h
//  移动采集
//
//  Created by hcat on 2018/5/14.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "VehicleRequestType.h"
#import "VehicleAPI.h"


typedef NS_ENUM(NSInteger,LineType){
    LineTypeOnLine,
    LineTypeUnLine,
    LineTypeUnBind
};

@interface VehicleCarMoreVC : HideTabSuperVC

@property (nonatomic,assign) VehicleRequestType type;
@property (nonatomic,copy) NSString *numberId;  //车牌号码,或者二维码
@property (nonatomic,strong) VehicleDetailReponse *reponse;   //车辆基本信息

@property (nonatomic,assign) LineType lineType;


+ (void)loadVehicleRequest:(VehicleRequestType)type withNumber:(NSString *)numberId withBlock:(void(^)(VehicleDetailReponse * vehicleDetailReponse))block;
@end

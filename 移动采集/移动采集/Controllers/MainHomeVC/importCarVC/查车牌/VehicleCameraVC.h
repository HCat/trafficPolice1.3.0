//
//  VehicleCameraVC.h
//  移动采集
//
//  Created by hcat on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "BaseViewController.h"
#import "CommonAPI.h"

@class VehicleCameraVC;

typedef void (^fininshCaptureBlock)(VehicleCameraVC
*camera);

@interface VehicleCameraVC : BaseViewController

//请求服务端口得到的数据
@property (nonatomic,strong) CommonIdentifyResponse *commonIdentifyResponse;

//拍照完之后调用的block
@property (nonatomic,copy) fininshCaptureBlock fininshCaptureBlock;

@property (nonatomic,assign) BOOL isHandSearch;

@end

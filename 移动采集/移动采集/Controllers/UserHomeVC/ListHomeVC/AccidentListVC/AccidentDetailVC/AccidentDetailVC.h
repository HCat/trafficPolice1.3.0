//
//  AccidentDetailVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "RemarkModel.h"

@interface AccidentDetailVC : HideTabSuperVC

@property (nonatomic,strong) NSNumber     * accidentId;
@property (nonatomic,assign) AccidentType   accidentType;       //事故类型或者快处类型
@property (nonatomic,strong) RemarkModel  * remarkModel;        //备注
@property (nonatomic,assign) NSInteger      remarkCount;        //备注数量
@property (nonatomic,strong,readonly) AccidentDetailsModel * model;

@property (nonatomic,strong) AccidentDetailsModel *cacheModel;

@end

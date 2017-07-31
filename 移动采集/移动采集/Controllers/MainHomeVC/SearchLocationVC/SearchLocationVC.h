//
//  SearchLocationVC.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/27.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "BaseViewController.h"
#import "HideTabSuperVC.h"

#import "AccidentAPI.h"
#import "FastAccidentAPI.h"

#import "CommonAPI.h"

typedef NS_ENUM(NSInteger,SearchLocationType){
    SearchLocationTypeAccident,
    SearchLocationTypeIllegal
};


typedef void(^SearchLocationBlock)(AccidentGetCodesModel *model);
typedef void(^SearchCommonGetRoadBlock)(CommonGetRoadModel *model);

@interface SearchLocationVC : HideTabSuperVC

@property (nonatomic,copy) SearchLocationBlock searchLocationBlock;
@property (nonatomic,copy) SearchCommonGetRoadBlock getRoadBlock;
@property (nonatomic,copy) NSArray *arr_content;
@property (nonatomic,copy) NSArray *arr_temp; //用于临时存储总数据
@property (nonatomic,assign) SearchLocationType searchType;

@end

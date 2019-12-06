//
//  MainHomeViewModel.m
//  移动采集
//
//  Created by hcat on 2019/5/7.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "MainHomeViewModel.h"


@implementation MainHomeViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        @weakify(self);
        //这里获取事故通用值
        [[ShareValue sharedDefault] accidentCodes];
        //这里获取道路通用值通用值
        [[ShareValue sharedDefault] roadModels];
        
        self.arr_illegal = @[].mutableCopy;
        self.arr_accident = @[].mutableCopy;
        self.arr_policeMatter = @[].mutableCopy;
        
        self.command_requestNotice = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
                CommonPoliceAnounceManger *manger = [[CommonPoliceAnounceManger alloc] init];
    
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        RACTuple * tuple = RACTuplePack(manger.swicth,manger.content);
                        [subscriber sendNext:tuple];
                    }else{
                        [subscriber sendNext:@"加载失败"];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return signal;
            
        }];
        
        self.command_requestMenu = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                CommonGetMenuManger *manger = [[CommonGetMenuManger alloc] init];
                [manger configLoadingTitle:@"加载"];
                
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [self.arr_illegal addObjectsFromArray:manger.commonReponse.illList];
                        [self.arr_accident addObjectsFromArray:manger.commonReponse.accidentList];
                        [self.arr_policeMatter addObjectsFromArray:manger.commonReponse.policeList];
                        [self processTheArrayData:self.arr_illegal];
                        [self processTheArrayData:self.arr_accident];
                        [self processTheArrayData:self.arr_policeMatter];
                        [subscriber sendNext:nil];
                    }else{
                        [subscriber sendNext:@"加载失败"];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return signal;
            
        }];
        
        
    }
    
    return self;
}


- (NSMutableArray *)arrayFromSection:(NSInteger)section{
    
    NSMutableArray * t_arr = @[].mutableCopy;
    
    if (section == 0) {
        if (self.arr_illegal && self.arr_illegal.count > 0) {
            
            for (CommonMenuModel * menuModel in self.arr_illegal) {
                if ([menuModel.isOrg isEqualToNumber:@1]) {
                    [t_arr addObject:menuModel];
                }
    
            }
            return  t_arr;
        }else if (self.arr_accident && self.arr_accident.count > 0){
            for (CommonMenuModel * menuModel in self.arr_accident) {
                if ([menuModel.isOrg isEqualToNumber:@1]) {
                    [t_arr addObject:menuModel];
                }
                
            }
            return  t_arr;
        }else if (self.arr_policeMatter && self.arr_policeMatter.count > 0){
            for (CommonMenuModel * menuModel in self.arr_policeMatter) {
                if ([menuModel.isOrg isEqualToNumber:@1]) {
                    [t_arr addObject:menuModel];
                }
                
            }
            return  t_arr;
        }
        
    }else if (section == 1){
        if (self.arr_accident && self.arr_accident.count > 0){
            for (CommonMenuModel * menuModel in self.arr_accident) {
                if ([menuModel.isOrg isEqualToNumber:@1]) {
                    [t_arr addObject:menuModel];
                }
                
            }
            return  t_arr;
        }else if (self.arr_policeMatter && self.arr_policeMatter.count > 0){
            for (CommonMenuModel * menuModel in self.arr_policeMatter) {
                if ([menuModel.isOrg isEqualToNumber:@1]) {
                    [t_arr addObject:menuModel];
                }
                
            }
            return  t_arr;
        }
        
    }else if (section == 2){
        if (self.arr_policeMatter && self.arr_policeMatter.count > 0){
            for (CommonMenuModel * menuModel in self.arr_policeMatter) {
                if ([menuModel.isOrg isEqualToNumber:@1]) {
                    [t_arr addObject:menuModel];
                }
                
            }
            return  t_arr;
        }
    }
    
    return nil;
    
}


- (void)processTheArrayData:(NSMutableArray * )t_arr{
    

    if (t_arr && t_arr.count > 0) {
    
        for (CommonMenuModel * menuModel in t_arr) {
            
            if ([menuModel.code isEqualToString:@"ILLEGAL_PARKING"]) {
                menuModel.funTitle = @"违停录入";
                menuModel.funImage = @"menu_illegal";
            }else if ([menuModel.code isEqualToString:@"ILLEGAL_REVERSE_PARKING"]) {
                menuModel.funTitle = @"不按朝向";
                menuModel.funImage = @"menu_reversePark";
            }else if ([menuModel.code isEqualToString:@"ILLEGAL_INHIBIT_LINE"]) {
                menuModel.funTitle = @"违反禁止线";
                menuModel.funImage = @"menu_violationLine";
            }else if ([menuModel.code isEqualToString:@"ILLEGAL_LOCK_PARKING"]) {
                menuModel.funTitle = @"违停锁车";
                menuModel.funImage = @"menu_lockCar";
            }else if ([menuModel.code isEqualToString:@"CAR_INFO_ADD"]) {
                menuModel.funTitle = @"车辆录入";
                menuModel.funImage = @"menu_carInfoAdd";
            }else if ([menuModel.code isEqualToString:@"MOTOR_INFO_ADD"]) {
                menuModel.funTitle = @"摩托车违章";
                menuModel.funImage = @"menu_motorbike";
            }else if ([menuModel.code isEqualToString:@"ILLEGAL_THROUGH"]) {
                menuModel.funTitle = @"违反禁令";
                menuModel.funImage = @"menu_through";
            }else if ([menuModel.code isEqualToString:@"VIDEO_COLLECT"]) {
                menuModel.funTitle = @"视频录入";
                menuModel.funImage = @"menu_videoCollect";
            }else if ([menuModel.code isEqualToString:@"JOINT_LAW_ENFORCEMENT"]) {
                menuModel.funTitle = @"联合执法";
                menuModel.funImage = @"menu_jointEnforcement";
            }else if ([menuModel.code isEqualToString:@"NORMAL_ACCIDENT_ADD"]) {
                menuModel.funTitle = @"事故录入";
                menuModel.funImage = @"menu_accident";
            }else if ([menuModel.code isEqualToString:@"FAST_ACCIDENT_ADD"]) {
                menuModel.funTitle = @"快处录入";
                menuModel.funImage = @"menu_fastAccident";
            }else if ([menuModel.code isEqualToString:@"IMPORTANT_CAR"]) {
                menuModel.funTitle = @"工程车辆";
                menuModel.funImage = @"menu_keyPointCar";
            }else if ([menuModel.code isEqualToString:@"POLICE_COMMAND"]) {
                menuModel.funTitle = @"警力分布";
                menuModel.funImage = @"menu_serviceCommand";
            }else if ([menuModel.code isEqualToString:@"POLICE_MANAGE"]) {
                menuModel.funTitle = @"勤务管理";
                menuModel.funImage = @"menu_attendance";
            }else if ([menuModel.code isEqualToString:@"DATA_SHARE"]) {
                menuModel.funTitle = @"资料共享";
                menuModel.funImage = @"menu_dataShare";
            }else if ([menuModel.code isEqualToString:@"ACTION_MANAGE"]) {
                menuModel.funTitle = @"行动管理";
                menuModel.funImage = @"menu_action";
            }else if ([menuModel.code isEqualToString:@"SPECAIL_CAR_MANAGE"]) {
                menuModel.funTitle = @"特殊车辆";
                menuModel.funImage = @"menu_specialCar";
            }else if ([menuModel.code isEqualToString:@"CAR_YARD_COLLECT"]) {
                menuModel.funTitle = @"车场管理";
                menuModel.funImage = @"menu_carYardCollect";
            }else if ([menuModel.code isEqualToString:@"DELVIERY_MANAGE"]) {
                menuModel.funTitle = @"外卖监管";
                menuModel.funImage = @"menu_delivery";
            }else if ([menuModel.code isEqualToString:@"PARKING_COLLECT"]) {
                menuModel.funTitle = @"停车取证";
                menuModel.funImage = @"menu_carEvidence";
            }else if ([menuModel.code isEqualToString:@"ILLEGAL_EXPOSURE"]) {
                menuModel.funTitle = @"违法曝光";
                menuModel.funImage = @"menu_illegalExposure";
            }
            

        }
        
        
    }
    
}


@end

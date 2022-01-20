//
//  MainAddMoreListViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/14.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainAddMoreListViewModel.h"

@implementation MainAddMoreListViewModel

- (void)lr_initialize{
    
    self.arr_content = @[].mutableCopy;
    
}


- (RACCommand * )command_list{
    
    
    if (!_command_list) {
        
        @weakify(self);
        _command_list = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                

                MainGetMenuInfoManger * manger = [[MainGetMenuInfoManger alloc] init];
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        [self.arr_content removeAllObjects];
                        
                        if (manger.mainResponse && manger.mainResponse.count > 0) {
                            
                                
                                for (MenuInfoModel * menuModel in manger.mainResponse) {
                                    
                                    if ([menuModel.menuCode isEqualToString:@"ILLEGAL_PARKING"]) {
                                        //menuModel.funTitle = @"违停录入";
                                        menuModel.menuIcon = @"menu_illegal";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_REVERSE_PARKING"]) {
                                        //menuModel.funTitle = @"不按朝向";
                                        menuModel.menuIcon = @"menu_reversePark";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_INHIBIT_LINE"]) {
                                        //menuModel.funTitle = @"违反禁止线";
                                        menuModel.menuIcon = @"menu_violationLine";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_LOCK_PARKING"]) {
                                        //menuModel.funTitle = @"违停锁车";
                                        menuModel.menuIcon = @"menu_lockCar";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"CAR_INFO_ADD"]) {
                                        //menuModel.funTitle = @"车辆录入";
                                        menuModel.menuIcon = @"menu_carInfoAdd";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"MOTOR_INFO_ADD"]) {
                                        //menuModel.funTitle = @"摩托车违章";
                                        menuModel.menuIcon = @"menu_motorbike";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_THROUGH"]) {
                                        //menuModel.funTitle = @"违反禁令";
                                        menuModel.menuIcon = @"menu_through";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"VIDEO_COLLECT"]) {
                                        //menuModel.funTitle = @"视频录入";
                                        menuModel.menuIcon = @"menu_videoCollect";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"JOINT_LAW_ENFORCEMENT"]) {
                                        //menuModel.funTitle = @"联合执法";
                                        menuModel.menuIcon = @"menu_jointEnforcement";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"NORMAL_ACCIDENT_ADD"]) {
                                        //menuModel.funTitle = @"事故录入";
                                        menuModel.menuIcon = @"menu_accident";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"FAST_ACCIDENT_ADD"]) {
                                        //menuModel.funTitle = @"快处录入";
                                        menuModel.menuIcon = @"menu_fastAccident";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"IMPORTANT_CAR"]) {
                                        //menuModel.funTitle = @"工程车辆";
                                        menuModel.menuIcon = @"menu_keyPointCar";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"POLICE_COMMAND"]) {
                                        //menuModel.funTitle = @"警力分布";
                                        menuModel.menuIcon = @"menu_serviceCommand";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"POLICE_MANAGE"]) {
                                       //menuModel.funTitle = @"勤务管理";
                                        menuModel.menuIcon = @"menu_attendance";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"DATA_SHARE"]) {
                                        //menuModel.funTitle = @"资料共享";
                                        menuModel.menuIcon = @"menu_dataShare";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"ACTION_MANAGE"]) {
                                        //menuModel.funTitle = @"行动管理";
                                        menuModel.menuIcon = @"menu_action";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"SPECAIL_CAR_MANAGE"]) {
                                        //menuModel.funTitle = @"特殊车辆";
                                        menuModel.menuIcon = @"menu_specialCar";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"CAR_YARD_COLLECT"]) {
                                        //menuModel.funTitle = @"车场管理";
                                        menuModel.menuIcon = @"menu_carYardCollect";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"DELVIERY_MANAGE"]) {
                                        //menuModel.funTitle = @"外卖监管";
                                        menuModel.menuIcon = @"menu_delivery";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"PARKING_COLLECT"]) {
                                        //menuModel.funTitle = @"停车取证";
                                        menuModel.menuIcon = @"menu_carEvidence";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_EXPOSURE"]) {
                                        //menuModel.funTitle = @"违法曝光";
                                        menuModel.menuIcon = @"menu_illegalExposure";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"PATROL_MANAGE"]) {
                                        //menuModel.funTitle = @"日常巡逻";
                                        menuModel.menuIcon = @"menu_patrolManage";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_PARK_COLLECT"]) {
                                        //menuModel.funTitle = @"违停采集";
                                        menuModel.menuIcon = @"menu_illegal";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"ELE_POLICE_MANAGE"]) {
                                        //menuModel.funTitle = @"电子警察";
                                        menuModel.menuIcon = @"menu_electronic";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"BOOKING_RECEIVE"]) {
                                        //menuModel.funTitle = @"综合屏管理";
                                        menuModel.menuIcon = @"menu_screen";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"NOTICE_MANAGE"]) {
                                        //menuModel.funTitle = @"公告";
                                        menuModel.menuIcon = @"menu_notice";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"TASK_MANAGE"]) {
                                        //menuModel.funTitle = @"任务";
                                        menuModel.menuIcon = @"menu_task";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"ACTION_MANGE"]) {
                                        //menuModel.funTitle = @"行动";
                                        menuModel.menuIcon = @"menu_userAction";
                                        [self.arr_content addObject:menuModel];
                                    }else if ([menuModel.menuCode isEqualToString:@"THROUGH_MANAGE"]) {
                                        //menuModel.funTitle = @"闯禁令管理";
                                        menuModel.menuIcon = @"menu_throughManage";
                                        [self.arr_content addObject:menuModel];
                                        
                                    }else if ([menuModel.menuCode isEqualToString:@"LOGISTICS_MANAGE"]) {
                                        //menuModel.funTitle = @"快递监管管理";
                                        menuModel.menuIcon = @"menu_courier";
                                        [self.arr_content addObject:menuModel];
                                        
                                    }else if ([menuModel.menuCode isEqualToString:@"ACCIDENT_REPORTS"]) {
                                        //menuModel.funTitle = @"数据分析";
                                        menuModel.menuIcon = @"menu_dataAnalysis";
                                        [self.arr_content addObject:menuModel];
                                        
                                    }else if ([menuModel.menuCode isEqualToString:@"STREETPARK_MANAGE"]) {
                                        //menuModel.funTitle = @"街道违法";
                                        menuModel.menuIcon = @"menu_street";
                                        [self.arr_content addObject:menuModel];
                                        
                                    }
                                
                                }
                        
                            }
                        
                        [subscriber sendNext:@"加载成功"];
                    }else{
                        [subscriber sendNext:@"加载失败"];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"加载失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return [t_signal takeUntil:self.cancelCommand.executionSignals];
        }];
        
        
        
    }
    
    return _command_list;
    
    
    
    
    
}


- (RACCommand * )command_save{
    
    
    if (!_command_save) {
        
        @weakify(self);
        _command_save = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                

                MainGetMenuInfoSaveManger * manger = [[MainGetMenuInfoSaveManger alloc] init];
                
                NSMutableArray * t_arr = @[].mutableCopy;
                
                for (MenuInfoModel * model in self.arr_content) {
                    
                    if ([model.current isEqualToString:@"1"]) {
                        continue;
                    }
                    
                    if ([model.isOrg isEqualToNumber:@1]) {
                        if ([model.isUser isEqualToNumber:@1]) {
                            if ([model.isActive isEqualToNumber:@1]) {
                                [t_arr addObject:model.menuCode];
                            }
                        }
                    }
                    
                }
                
                if (t_arr.count > 0) {
                    manger.menuListArr = [t_arr componentsJoinedByString:@","];
                }else{
                    manger.menuListArr = @"";
                }
                [manger configLoadingTitle:@"保存"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:@"保存成功"];
                    }else{
                        [subscriber sendNext:@"保存失败"];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"保存失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return [t_signal takeUntil:self.cancelCommand.executionSignals];
        }];
        
        
        
    }
    
    return _command_save;
    
    
    
    
    
}


@end

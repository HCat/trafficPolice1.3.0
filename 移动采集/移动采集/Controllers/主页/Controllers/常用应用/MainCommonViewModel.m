//
//  MainCommonViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/12.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainCommonViewModel.h"

@implementation MainCommonViewModel

- (void)lr_initialize{
    
    self.arr_items = @[].mutableCopy;
    
}

- (RACCommand *)command_common{
    
    if (_command_common == nil) {
        
        @weakify(self);
        _command_common = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                

                MainPoliceMenuListManger * manger = [[MainPoliceMenuListManger alloc] init];
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        [self.arr_items removeAllObjects];
                        //[self.arr_items addObjectsFromArray:manger.mainResponse];
                        
                        if (manger.mainResponse && manger.mainResponse.count > 0) {
                        
                            
                            for (PoliceMenuListModel * menuModel in manger.mainResponse) {
                                
                                if ([menuModel.menuCode isEqualToString:@"ILLEGAL_PARKING"]) {
                                    //menuModel.funTitle = @"违停录入";
                                    menuModel.menuIcon = @"menu_illegal";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_REVERSE_PARKING"]) {
                                    //menuModel.funTitle = @"不按朝向";
                                    menuModel.menuIcon = @"menu_reversePark";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_INHIBIT_LINE"]) {
                                    //menuModel.funTitle = @"违反禁止线";
                                    menuModel.menuIcon = @"menu_violationLine";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_LOCK_PARKING"]) {
                                    //menuModel.funTitle = @"违停锁车";
                                    menuModel.menuIcon = @"menu_lockCar";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"CAR_INFO_ADD"]) {
                                    //menuModel.funTitle = @"车辆录入";
                                    menuModel.menuIcon = @"menu_carInfoAdd";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"MOTOR_INFO_ADD"]) {
                                    //menuModel.funTitle = @"摩托车违章";
                                    menuModel.menuIcon = @"menu_motorbike";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_THROUGH"]) {
                                    //menuModel.funTitle = @"违反禁令";
                                    menuModel.menuIcon = @"menu_through";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"VIDEO_COLLECT"]) {
                                    //menuModel.funTitle = @"视频录入";
                                    menuModel.menuIcon = @"menu_videoCollect";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"JOINT_LAW_ENFORCEMENT"]) {
                                    //menuModel.funTitle = @"联合执法";
                                    menuModel.menuIcon = @"menu_jointEnforcement";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"NORMAL_ACCIDENT_ADD"]) {
                                    //menuModel.funTitle = @"事故录入";
                                    menuModel.menuIcon = @"menu_accident";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"FAST_ACCIDENT_ADD"]) {
                                    //menuModel.funTitle = @"快处录入";
                                    menuModel.menuIcon = @"menu_fastAccident";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"IMPORTANT_CAR"]) {
                                    //menuModel.funTitle = @"工程车辆";
                                    menuModel.menuIcon = @"menu_keyPointCar";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"POLICE_COMMAND"]) {
                                    //menuModel.funTitle = @"警力分布";
                                    menuModel.menuIcon = @"menu_serviceCommand";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"POLICE_MANAGE"]) {
                                   //menuModel.funTitle = @"勤务管理";
                                    menuModel.menuIcon = @"menu_attendance";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"DATA_SHARE"]) {
                                    //menuModel.funTitle = @"资料共享";
                                    menuModel.menuIcon = @"menu_dataShare";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"ACTION_MANAGE"]) {
                                    //menuModel.funTitle = @"行动管理";
                                    menuModel.menuIcon = @"menu_action";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"SPECAIL_CAR_MANAGE"]) {
                                    //menuModel.funTitle = @"特殊车辆";
                                    menuModel.menuIcon = @"menu_specialCar";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"CAR_YARD_COLLECT"]) {
                                    //menuModel.funTitle = @"车场管理";
                                    menuModel.menuIcon = @"menu_carYardCollect";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"DELVIERY_MANAGE"]) {
                                    //menuModel.funTitle = @"外卖监管";
                                    menuModel.menuIcon = @"menu_delivery";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"PARKING_COLLECT"]) {
                                    //menuModel.funTitle = @"停车取证";
                                    menuModel.menuIcon = @"menu_carEvidence";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_EXPOSURE"]) {
                                    //menuModel.funTitle = @"违法曝光";
                                    menuModel.menuIcon = @"menu_illegalExposure";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"PATROL_MANAGE"]) {
                                    //menuModel.funTitle = @"日常巡逻";
                                    menuModel.menuIcon = @"menu_patrolManage";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"ILLEGAL_PARK_COLLECT"]) {
                                    //menuModel.funTitle = @"违停采集";
                                    menuModel.menuIcon = @"menu_illegal";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"ELE_POLICE_MANAGE"]) {
                                    //menuModel.funTitle = @"电子警察";
                                    menuModel.menuIcon = @"menu_electronic";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"BOOKING_RECEIVE"]) {
                                    //menuModel.funTitle = @"综合屏管理";
                                    menuModel.menuIcon = @"menu_screen";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"NOTICE_MANAGE"]) {
                                    //menuModel.funTitle = @"公告";
                                    menuModel.menuIcon = @"menu_notice";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"TASK_MANAGE"]) {
                                    //menuModel.funTitle = @"任务";
                                    menuModel.menuIcon = @"menu_task";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"ACTION_MANGE"]) {
                                    //menuModel.funTitle = @"行动";
                                    menuModel.menuIcon = @"menu_userAction";
                                    [self.arr_items addObject:menuModel];
                                }else if ([menuModel.menuCode isEqualToString:@"THROUGH_MANAGE"]) {
                                    //menuModel.funTitle = @"闯禁令管理";
                                    menuModel.menuIcon = @"menu_throughManage";
                                    [self.arr_items addObject:menuModel];
                                    
                                }else if ([menuModel.menuCode isEqualToString:@"LOGISTICS_MANAGE"]) {
                                    //menuModel.funTitle = @"快递监管管理";
                                    menuModel.menuIcon = @"menu_courier";
                                    [self.arr_items addObject:menuModel];
                                    
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
    
    
    
    return _command_common;
    
}


@end

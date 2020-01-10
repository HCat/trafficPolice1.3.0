//
//  DailyPatrolDetailViewModel.m
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DailyPatrolDetailViewModel.h"

@implementation DailyPatrolDetailViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        self.arr_point = @[].mutableCopy;
    }
    
    return self;
    
}

- (RACCommand *)command_detail{

    if (_command_detail == nil) {
        
        @weakify(self);
        self.command_detail = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                DailyPatrolDetailManger * manger = [[DailyPatrolDetailManger alloc] init];
                manger.partrolId = self.partrolId;
                manger.shiftId = self.shiftId;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        self.reponseModel = manger.reponseModel;
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
            
            return t_signal;
        }];
        
    }
    
    return _command_detail;
    
}

- (RACCommand *)command_sign{

    if (_command_sign == nil) {
        @weakify(self);
        self.command_sign = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                DailyPatrolSendSignParam * param = [[DailyPatrolSendSignParam alloc] init];
                DailyPatrolSendSignManger * manger = [[DailyPatrolSendSignManger alloc] init];
                param.shiftId = self.shiftId;
                param.patrolId = self.partrolId;
                param.latitude = self.latitude;
                param.longitude = self.longitude;
                param.point = self.point;
                manger.param = param;
                [manger configLoadingTitle:@"签到"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:@"签到成功"];
                    }else{
                        [subscriber sendNext:@"签到失败"];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"签到失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
    }
    
    return _command_sign;
    
}


@end

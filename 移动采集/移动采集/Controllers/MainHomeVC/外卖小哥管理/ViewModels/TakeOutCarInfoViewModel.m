//
//  TakeOutCarInfoViewModel.m
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutCarInfoViewModel.h"

@implementation TakeOutCarInfoViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        @weakify(self);
        
        self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                TakeOutGetVehicleInfoManger * manger = [[TakeOutGetVehicleInfoManger alloc] init];
                manger.vehicleId = self.vehicleId;
                [manger configLoadingTitle:@"加载"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        self.model = manger.takeOutReponse;
                        [subscriber sendNext:manger.takeOutReponse];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
    }
    
    return self;
    
}

@end

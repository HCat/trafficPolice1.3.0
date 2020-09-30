//
//  ExpressRegulationDetailViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/30.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ExpressRegulationDetailViewModel.h"

@implementation ExpressRegulationDetailViewModel


- (RACCommand * )detail_command{
    
    if (_detail_command == nil) {
        @weakify(self);
        _detail_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                
                
                ExpressRegulationDetailManger * manger = [[ExpressRegulationDetailManger alloc] init];
                manger.vehicleId = self.vehicleId;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                    
                        [subscriber sendNext:manger.takeOutReponse];
                        
                        
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
    
    return _detail_command;
    
    
}


@end

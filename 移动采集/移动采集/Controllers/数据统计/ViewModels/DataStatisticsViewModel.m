//
//  DataStatisticsViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/11.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DataStatisticsViewModel.h"

@implementation DataStatisticsViewModel


- (RACCommand *)command_list{
    
    if (_command_list == nil) {
        
        @weakify(self);
        _command_list = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                DataStatisticsManger *manger = [[DataStatisticsManger alloc] init];
                
                manger.accidentState = self.accidentState;
                [manger configLoadingTitle:@"请求"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        [subscriber sendNext:manger.dataStatisticsReponse];
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



@end

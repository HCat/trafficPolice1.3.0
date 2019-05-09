//
//  TakeOutInfoViewModel.m
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutInfoViewModel.h"

@implementation TakeOutInfoViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        @weakify(self);
    
        self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
                TakeOutGetCourierInfoManger * manger = [[TakeOutGetCourierInfoManger alloc] init];
                manger.deliveryId = self.deliveryId;
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

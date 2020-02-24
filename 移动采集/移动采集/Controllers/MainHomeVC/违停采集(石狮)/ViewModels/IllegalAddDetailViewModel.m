//
//  IllegalAddDetailViewModel.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/20.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalAddDetailViewModel.h"
#import "IllegalAPI.h"

@implementation IllegalAddDetailViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
    }
    
    return self;
}

- (RACCommand * )command_detail{
    
    if (_command_detail == nil) {
        @weakify(self);
        _command_detail = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                IllegalAddDetailManger *manger = [[IllegalAddDetailManger alloc] init];
                manger.illegalParkId = self.illegalId;
                [manger configLoadingTitle:@"加载"];

                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        self.model = manger.illegalDetailModel;
                        if ([self.model.illegalCollect.state isEqualToNumber:@8]) {
                            self.model.illegalCollect.stateName = @"异常处理中";
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
            
            return t_signal;
        }];
        
        
        
    }
    
    return _command_detail;
    
}


@end

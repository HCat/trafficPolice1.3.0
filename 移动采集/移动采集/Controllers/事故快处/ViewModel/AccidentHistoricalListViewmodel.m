//
//  AccidentHistoricalListViewmodel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/13.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "AccidentHistoricalListViewmodel.h"

@implementation AccidentHistoricalListViewmodel

- (instancetype)init{
    
    if (self = [super init]) {
        self.arr_content = @[].mutableCopy;
        self.param = [[AccidentMoreListPagingParam alloc] init];
        self.param.length = 200;
        
    }
    
    return self;
}


- (RACCommand *)command_list{
    
    if (_command_list == nil) {
        
        @weakify(self);
        _command_list = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                AccidentMoreListPagingManger *manger = [[AccidentMoreListPagingManger alloc] init];
                manger.param = self.param;
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                   
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if (self.param.start == 0) {
                            [self.arr_content removeAllObjects];
                        }
                         [self.arr_content addObjectsFromArray:manger.accidentMoreReponse.list];
                        
                        [subscriber sendNext:@"请求最后一条成功"];
                        
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

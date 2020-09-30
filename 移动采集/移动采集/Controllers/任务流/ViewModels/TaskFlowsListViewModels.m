//
//  TaskFlowsListViewModels.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/3.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsListViewModels.h"

@implementation TaskFlowsListViewModels

- (instancetype)init{
    
    if (self = [super init]) {
    
        self.arr_content = @[].mutableCopy;
    
    }
    return self;
    
}

- (RACCommand *)command_loadList{

    if (_command_loadList == nil) {
        
        @weakify(self);
        _command_loadList = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                if ([self.type isEqualToNumber:@1]) {
                    TaskFlowsAdviceTaskListParam *param = [[TaskFlowsAdviceTaskListParam alloc] init];
                    param.start = [self.start integerValue];
                    param.length = 10;
                    TaskFlowsAdviceTaskListManger * manger = [[TaskFlowsAdviceTaskListManger alloc] init];
                    manger.param = param;
                    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        @strongify(self);
                        if (manger.responseModel.code == CODE_SUCCESS) {
                            
                            if ([self.start isEqualToNumber:@0]) {
                                [self.arr_content removeAllObjects];
                            }
                            [self.arr_content addObjectsFromArray:manger.result.list];
                            
                            if (self.arr_content.count == manger.result.total) {
                                [subscriber sendNext:@"请求最后一条成功"];
                            }else{
                                [subscriber sendNext:@"加载成功"];
                                self.start = @([self.start integerValue] + 1);
                            }
                            
                        }else{
                            [subscriber sendNext:@"加载失败"];
                        }
                        
                        [subscriber sendCompleted];
                        
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [subscriber sendNext:@"加载失败"];
                        [subscriber sendCompleted];
                    }];
                    
                }else{
                    
                    TaskFlowsSelfTaskListParam *param = [[TaskFlowsSelfTaskListParam alloc] init];
                    param.start = [self.start integerValue];
                    param.length = 10;
                    TaskFlowsSelfTaskListManger * manger = [[TaskFlowsSelfTaskListManger alloc] init];
                    manger.param = param;
                    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        @strongify(self);
                        if (manger.responseModel.code == CODE_SUCCESS) {
                            
                            if ([self.start isEqualToNumber:@0]) {
                                [self.arr_content removeAllObjects];
                            }
                            [self.arr_content addObjectsFromArray:manger.result.list];
                            
                            if (self.arr_content.count == manger.result.total) {
                                [subscriber sendNext:@"请求最后一条成功"];
                            }else{
                                [subscriber sendNext:@"加载成功"];
                                self.start = @([self.start integerValue] + 1);
                            }
                            
                        }else{
                            [subscriber sendNext:@"加载失败"];
                        }
                        
                        [subscriber sendCompleted];
                        
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [subscriber sendNext:@"加载失败"];
                        [subscriber sendCompleted];
                    }];
                    
                }
                
                return nil;
            }];
            
            return t_signal;
        }];
    }
    
    return _command_loadList;
          
}


@end

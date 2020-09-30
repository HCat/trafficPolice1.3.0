//
//  IllegalCollectListViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/22.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalCollectListViewModel.h"

@implementation IllegalCollectListViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        self.arr_content = @[].mutableCopy;
        
        
    }
    
    return self;
}


- (RACCommand *)command_list{
    
    if (_command_list == nil) {
        
        @weakify(self);
        _command_list = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                if (self.illegalType == IllegalTypePark) {
                    
                    IllegalParkListPagingParam *param = [[IllegalParkListPagingParam alloc] init];
                    param.start = self.index;
                    param.length = 10;
                    param.type = @(self.subType);
                    if (self.str_search.length > 0) {
                        param.search = self.str_search;
                    }
                    
                    IllegalParkListPagingManger *manger = [[IllegalParkListPagingManger alloc] init];
                    manger.param = param;
                    manger.isNoShowFail = YES;
                    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        @strongify(self);
                       
                        if (manger.responseModel.code == CODE_SUCCESS) {
                            
                            if (self.index == 0) {
                                [self.arr_content removeAllObjects];
                            }
                            [self.arr_content addObjectsFromArray:manger.illegalParkListPagingReponse.list];
                            
                            if (self.arr_content.count == manger.illegalParkListPagingReponse.total) {
                                [subscriber sendNext:@"请求最后一条成功"];
                            }else{
                                self.index += param.length;
                                [subscriber sendNext:@"加载成功"];
                            }
                            
                        }else{
                            [subscriber sendNext:@"加载失败"];
                        }
                        [subscriber sendCompleted];
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [subscriber sendNext:@"加载失败"];
                        [subscriber sendCompleted];
                    }];
                    
                }else if (self.illegalType == IllegalTypeThrough){
                    
                    IllegalThroughListPagingParam *param = [[IllegalThroughListPagingParam alloc] init];
                    param.start = self.index;
                    param.length = 10;
                    if (self.str_search.length > 0) {
                        param.search = self.str_search;
                    }
                
                    IllegalThroughListPagingManger *manger = [[IllegalThroughListPagingManger alloc] init];
                    manger.param = param;
                    manger.isNoShowFail = YES;
                    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        @strongify(self);
                       
                        if (manger.responseModel.code == CODE_SUCCESS) {
                            
                            if (self.index == 0) {
                                [self.arr_content removeAllObjects];
                            }
                            [self.arr_content addObjectsFromArray:manger.illegalThroughListPagingReponse.list];
                            
                            if (self.arr_content.count == manger.illegalThroughListPagingReponse.total) {
                                [subscriber sendNext:@"请求最后一条成功"];
                            }else{
                                self.index += param.length;
                                [subscriber sendNext:@"加载成功"];
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
            
            return [t_signal takeUntil:self.cancelCommand.executionSignals];
        }];
    }
    
    
    
    return _command_list;
    
}




@end

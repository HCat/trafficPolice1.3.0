//
//  VideoAddListViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "VideoAddListViewModel.h"

@implementation VideoAddListViewModel

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
                
                VideoColectListPagingParam *param = [[VideoColectListPagingParam alloc] init];
                param.start = self.index;
                param.length = 10;
                if (self.str_search.length > 0) {
                    param.search = self.str_search;
                }
                
                VideoColectListPagingManger *manger = [[VideoColectListPagingManger alloc] init];
                manger.param = param;
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                   
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if (self.index == 0) {
                            [self.arr_content removeAllObjects];
                        }
                        [self.arr_content addObjectsFromArray:manger.videoColectListPagingReponse.list];
                        
                        if (self.arr_content.count == manger.videoColectListPagingReponse.total) {
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
                
                return nil;
            }];
            
            return [t_signal takeUntil:self.cancelCommand.executionSignals];
        }];
    }
    
    
    
    return _command_list;
    
}




@end

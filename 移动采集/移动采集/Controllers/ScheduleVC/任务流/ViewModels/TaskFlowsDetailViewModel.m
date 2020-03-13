//
//  TaskFlowsDetailViewModel.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/5.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsDetailViewModel.h"

@implementation TaskFlowsDetailViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.arr_replys = @[].mutableCopy;
    }
    
    return self;
    
}

- (RACCommand *)command_loadDetail{

    if (_command_loadDetail == nil) {
        
        @weakify(self);
        _command_loadDetail = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
                TaskFlowsDetailManger * manger = [[TaskFlowsDetailManger alloc] init];
                manger.taskFlowsId = self.taskFlowsId;
                [manger configLoadingTitle:@"加载"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        self.result = manger.result;
                        
                        if (self.arr_replys.count > 0 ) {
                            [self.arr_replys removeAllObjects];
                        }
                        
                        if (self.my_taskReply) {
                            self.my_taskReply = nil;
                        }
                        
                        if (self.result.taskReplyList && self.result.taskReplyList.count > 0) {
                            
                            for (int i = 0; i < self.result.taskReplyList.count; i++) {
                                TaskFlowsReplyModel * t_model = self.result.taskReplyList[i];
                                if ([t_model.replyType isEqualToNumber:@0]) {
                                    [self.arr_replys addObject:t_model];
                                }else{
                                    self.my_taskReply = t_model;
                                }
                                
                            }
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
    
    return _command_loadDetail;
          
}

@end

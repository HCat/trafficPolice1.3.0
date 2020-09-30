//
//  TaskFlowsAddViewModel.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/9.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsAddViewModel.h"

@implementation TaskFlowsAddViewModel


- (instancetype)init{
    
    if (self = [super init]) {
        
        self.sendNotice = @0;
        @weakify(self);
        [[RACSignal combineLatest:@[RACObserve(self, userId), RACObserve(self, content)] reduce:^id (NSString * userId,NSString * content){
            return @(userId.length > 0 && content.length > 0);
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.isCanCommit = [x boolValue];

        }];
        
    }
    
    return self;

}


- (RACCommand *)command_commint{

    if (_command_commint == nil) {
        
        @weakify(self);
        _command_commint = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                TaskFlowSaveTaskParam * param = [[TaskFlowSaveTaskParam alloc] init];
                param.userId = self.userId;
                param.content = self.content;
                param.sendNotice = self.sendNotice;
                
                TaskFlowSaveTaskManger * manger = [[TaskFlowSaveTaskManger alloc] init];
                manger.param = param;
                [manger configLoadingTitle:@"创建"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:@"创建成功"];
                        
                    }else{
                        [subscriber sendNext:@"创建失败"];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"创建失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
    }
    
    return _command_commint;
          
}

@end

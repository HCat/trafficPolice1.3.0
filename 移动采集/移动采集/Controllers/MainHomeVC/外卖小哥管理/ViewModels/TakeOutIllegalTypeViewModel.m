//
//  TakeOutIllegalTypeViewModel.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutIllegalTypeViewModel.h"

@implementation TakeOutIllegalTypeViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        @weakify(self);
        
        self.arr_content = @[].mutableCopy;
        
        self.command_type = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                TakeOutIllegalTypeManger * manger = [[TakeOutIllegalTypeManger alloc] init];
                [manger configLoadingTitle:@"加载"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (self.arr_content && self.arr_content.count > 0) {
                        [self.arr_content removeAllObjects];
                    }
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        [self.arr_content addObjectsFromArray:manger.list];
                        
                        [subscriber sendNext:nil];
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
    
    return self;
    
}

@end

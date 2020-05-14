//
//  TakeOutSearchViewModel.m
//  移动采集
//
//  Created by hcat on 2019/5/8.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutSearchViewModel.h"


@implementation TakeOutSearchViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        @weakify(self);
        
        self.arr_content = @[].mutableCopy;
        self.type = @1;
        
        self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                TakeOutGetCourierListParam * param = [[TakeOutGetCourierListParam alloc] init];
                param.start = self.index;
                param.length = @20;
                param.key = self.key;
                param.type = self.type;
                
                TakeOutGetCourierListManger * manger = [[TakeOutGetCourierListManger alloc] init];
                manger.param = param;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if ([self.index isEqualToNumber:@0]) {
                            [self.arr_content removeAllObjects];
                        }
                        
                        [self.arr_content addObjectsFromArray:manger.takeOutReponse.list];
                        
                        if (self.arr_content.count == manger.takeOutReponse.total) {
                            [subscriber sendNext:@"请求最后一条成功"];
                        }else{
                            [subscriber sendNext:@"加载成功"];
                            self.index = @([self.index integerValue] + [param.length integerValue]);
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
            
            return t_signal;
        }];
        
    }
    
    return self;
    
}


@end

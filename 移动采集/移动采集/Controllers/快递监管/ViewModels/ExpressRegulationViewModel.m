//
//  ExpressRegulationViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ExpressRegulationViewModel.h"

@implementation ExpressRegulationViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        @weakify(self);
        
        self.arr_content = @[].mutableCopy;
        self.searchType = @3;
        
        self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                if (self.searchName == nil || self.searchName.length == 0) {
                    [subscriber sendNext:@"加载失败"];
                    [subscriber sendCompleted];
                }
                
                ExpressRegulationListParam * param = [[ExpressRegulationListParam alloc] init];
                param.start = self.start;
                param.length = @20;
                param.searchName = self.searchName;
                param.searchType = self.searchType;
                
                ExpressRegulationListManger * manger = [[ExpressRegulationListManger alloc] init];
                manger.param = param;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if ([self.start isEqualToNumber:@0]) {
                            [self.arr_content removeAllObjects];
                        }
                        
                        [self.arr_content addObjectsFromArray:manger.takeOutReponse.list];
                        
                        if (self.arr_content.count == manger.takeOutReponse.total) {
                            [subscriber sendNext:@"请求最后一条成功"];
                        }else{
                            [subscriber sendNext:@"加载成功"];
                            self.start = @([self.start integerValue] + [param.length integerValue]);
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

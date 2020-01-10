//
//  DailyPatrolListViewModel.m
//  移动采集
//
//  Created by hcat-89 on 2020/1/8.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DailyPatrolListViewModel.h"
#import "DailyPatrolAPI.h"

@implementation DailyPatrolListViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        self.arr_data = @[].mutableCopy;
    }
    
    return self;
}

- (RACCommand *)loadCommand{
    
    if (_loadCommand == nil) {
    
        @weakify(self);
        _loadCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
                
                DailyPatrolListManger * manger = [[DailyPatrolListManger alloc] init];
                manger.isNeedShowHud = NO;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        [self.arr_data removeAllObjects];
                        
                        [self.arr_data addObjectsFromArray:manger.list];
                        
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
    
    return _loadCommand;

}


@end

//
//  ParkingAreaViewModel.m
//  移动采集
//
//  Created by hcat on 2019/7/26.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingAreaViewModel.h"

@implementation ParkingAreaViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.arr_content = @[].mutableCopy;
        self.arr_group = [NSMutableArray array];
        [self.arr_group addObject:@"全部"];
    }
    
    return self;
    
}


- (RACCommand *)requestCommand{
    
    if (_requestCommand == nil) {
        
        @weakify(self);
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                
                ParkingOccPercentListParam *param = [[ParkingOccPercentListParam alloc] init];
                param.start = self.index;
                param.length = @10;
                param.parklotid = self.parklotid;
                
                ParkingOccPercentListManger * manger = [[ParkingOccPercentListManger alloc] init];
                manger.param = param;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if ([self.index isEqualToNumber:@0]) {
                            [self.arr_content removeAllObjects];
                        }
                        
                        [self.arr_content addObjectsFromArray:manger.parkingReponse.list];
                        
                        if (self.arr_content.count == manger.parkingReponse.total) {
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
    
    return _requestCommand;
    
}

- (RACCommand *)groupCommand{
    
    if (_groupCommand == nil) {
        
        @weakify(self);
        _groupCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ParkingAreaManger * manger = [[ParkingAreaManger alloc] init];
                
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                         [self.arr_group addObjectsFromArray:manger.list];
                         [subscriber sendNext:@"加载成功"];
                    }else{
                        [self groupCommand];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [self groupCommand];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
        
    }
    
    return _groupCommand;
    
}




@end

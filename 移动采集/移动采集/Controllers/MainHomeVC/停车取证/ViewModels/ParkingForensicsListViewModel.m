//
//  ParkingForensicsListViewModel.m
//  移动采集
//
//  Created by hcat on 2019/7/25.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingForensicsListViewModel.h"
#import "UserModel.h"

@implementation ParkingForensicsListViewModel

- (instancetype)init{
    
    if (self = [super init]) {
    
        self.arr_content = @[].mutableCopy;
        self.arr_group = [NSMutableArray array];
        
        @weakify(self);
        self.command_isRegister = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            @strongify(self);
            
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ParkingIsRegisteManger * manger = [[ParkingIsRegisteManger alloc] init];
                
                manger.phone = [UserModel getUserModel].phone;

                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendNext:manger.isRegiste];
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


- (RACCommand *)requestCommand{
    
    if (_requestCommand == nil) {
    
        @weakify(self);
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                
                ParkingForensicsListParam *param = [[ParkingForensicsListParam alloc] init];
                param.pageNum = self.index;
                //param.pageSize = @10;
                if (self.longitude || self.latitude) {
                    param.longitude = self.longitude;
                    param.latitude = self.latitude;
                    
                }
                if (self.parklotid) {
                    param.fkParklotId = self.parklotid;
                }
                
                
                ParkingForensicsListManger * manger = [[ParkingForensicsListManger alloc] init];
                manger.param = param;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_LAJI_SUCCESS) {
                        
                        if ([self.index isEqualToNumber:@1]) {
                            [self.arr_content removeAllObjects];
                        }
                        
                        [self.arr_content addObjectsFromArray:manger.parkingReponse.list];
                        
                        if (self.arr_content.count == manger.parkingReponse.total) {
                            [subscriber sendNext:@"请求最后一条成功"];
                        }else{
                            [subscriber sendNext:@"加载成功"];
                            self.index = @([self.index integerValue] + 1);
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
                    if (manger.responseModel.code == CODE_LAJI_SUCCESS) {
                        
                         [self.arr_group addObjectsFromArray:manger.list];
                        if (self.arr_group && self.arr_group.count > 0) {
                            ParkingAreaModel * model = [[ParkingAreaModel alloc] init];
                            model.parklotname = @"全部";
                            [self.arr_group insertObject:model atIndex:0];
                        }
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

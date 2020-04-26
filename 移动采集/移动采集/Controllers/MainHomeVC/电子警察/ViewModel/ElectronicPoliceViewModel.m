//
//  ElectronicPoliceViewModel.m
//  移动采集
//
//  Created by hcat-89 on 2020/4/23.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ElectronicPoliceViewModel.h"

@implementation ElectronicPoliceViewModel

- (instancetype)init{
    
    if (self = [super init]) {

        self.arr_group = [NSMutableArray array];
        self.arr_detail = @[].mutableCopy;
        self.arr_point = @[].mutableCopy;
        self.isSate = NO;
    }
        
    
    return self;
    
}



- (RACCommand *)command_group{
    
    if (_command_group == nil) {
        
        @weakify(self);
        _command_group = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ElectronicPoliceTypeManger * manger = [[ElectronicPoliceTypeManger alloc] init];
                
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                         [self.arr_group addObjectsFromArray:manger.list];
                        if (self.arr_group && self.arr_group.count > 0) {
                            ElectronicTypeModel * model = [[ElectronicTypeModel alloc] init];
                            model.typeName = @"全部设备";
                            [self.arr_group insertObject:model atIndex:0];
                        }
                         [subscriber sendNext:@"加载成功"];
                    }else{
                        [self command_group];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [self command_group];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
        
    }
    
    return _command_group;
    
}

- (RACCommand *)command_detail{
    
    if (_command_detail == nil) {
        
        @weakify(self);
        _command_detail = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ElectronicPoliceListManger * manger = [[ElectronicPoliceListManger alloc] init];
                manger.cameraType = input;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if (self.arr_detail.count > 0) {
                            [self.arr_detail removeAllObjects];
                        }
                    
                        [self.arr_detail addObjectsFromArray:manger.list];
                        
                        [subscriber sendNext:@"加载成功"];
                    }else{
                        [self command_detail];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [self command_detail];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
        
    }
    
    return _command_detail;
    
}


@end

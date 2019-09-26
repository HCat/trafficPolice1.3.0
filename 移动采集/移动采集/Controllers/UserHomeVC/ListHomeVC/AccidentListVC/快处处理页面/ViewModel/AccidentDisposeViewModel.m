//
//  AccidentDisposeViewModel.m
//  移动采集
//
//  Created by hcat on 2019/8/30.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "AccidentDisposeViewModel.h"



@implementation AccidentDisposeViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        self.arr_count = @[].mutableCopy;
    }
    
    return self;
    
}


- (RACCommand *)command_people{
    
    if (_command_people == nil) {
        
        @weakify(self);
        _command_people = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                FastAccidentDetailManger * manger = [[FastAccidentDetailManger alloc] init];
                manger.accidentId = self.accidentId;
                [manger configLoadingTitle:@"加载"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if (self.arr_count.count > 0) {
                            [self.arr_count removeAllObjects];
                        }
                        
                        [self.arr_count addObjectsFromArray:manger.accidentFastPeopleModel];
                        
    
                        [subscriber sendNext:@"加载成功"];
                        
                        
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
    
    return _command_people;
    
}


- (RACCommand *)command_dealAccident{
    
    if (_command_dealAccident == nil) {
        
        @weakify(self);
        _command_dealAccident = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                FastAccidentDealAccidentManger * manger = [[FastAccidentDealAccidentManger alloc] init];
                FastAccidentDealAccidentParam * param = [[FastAccidentDealAccidentParam alloc] init];
                param.accidentId = self.accidentId;
                param.accidentInfoList = self.arr_count;
                manger.accidentJson = param.modelToJSONString;
                [manger configLoadingTitle:@"提交"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:@"提交成功"];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"提交失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
    }
    
    return _command_dealAccident;
    
}




@end

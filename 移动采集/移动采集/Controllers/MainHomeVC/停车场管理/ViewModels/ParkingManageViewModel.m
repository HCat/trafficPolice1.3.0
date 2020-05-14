//
//  ParkingManageViewModel.m
//  移动采集
//
//  Created by hcat on 2019/9/17.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingManageViewModel.h"

@implementation ParkingManageViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.type = @0;
        self.arr_data = @[].mutableCopy;
        
        
    }
    
    return self;
    
}

- (RACCommand * )searchCommand{
    
    if (_searchCommand == nil) {
        @weakify(self);
        
        _searchCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ParkingManageSearchListParam * param = [[ParkingManageSearchListParam alloc] init];
                param.start = self.index;
                param.length = @20;
                param.searchWord = self.keywords;
                param.type = self.type;
                
                ParkingManageSearchListManger * manger = [[ParkingManageSearchListManger alloc] init];
                manger.param = param;
                manger.isNeedShowHud = NO;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if ([self.index isEqualToNumber:@0]) {
                            [self.arr_data removeAllObjects];
                        }
                        
                        [self.arr_data addObjectsFromArray:manger.resultList];
                        
                        if (manger.resultList.count < [param.length intValue]) {
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
    
    return _searchCommand;

}



@end

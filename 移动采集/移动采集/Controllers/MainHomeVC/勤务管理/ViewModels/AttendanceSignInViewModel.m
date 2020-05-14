//
//  AttendanceSignInViewModel.m
//  移动采集
//
//  Created by hcat on 2019/4/4.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "AttendanceSignInViewModel.h"

@implementation AttendanceSignInViewModel


- (instancetype)init{
    
    if (self = [super init]) {
        
        self.arr_signIn = @[].mutableCopy;
       
        @weakify(self);
        
        self.command_signIn = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                PoliceSignListParam * param = [[PoliceSignListParam alloc] init];
                param.userId = self.policemodel.userId;
                param.workDateStr = self.policemodel.workDateStr;
                
                PoliceSignListManger * manger = [[PoliceSignListManger alloc] init];
                manger.param = param;
                [manger configLoadingTitle:@"请求"];
                
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if (self.arr_signIn && self.arr_signIn.count > 0) {
                            [self.arr_signIn removeAllObjects];
                        }
                        
                        [self.arr_signIn addObjectsFromArray:manger.signList];
                        self.count_signIn = @(self.arr_signIn.count);
                        
                        [subscriber sendNext:@"加载成功"];
                        
                    };
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
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

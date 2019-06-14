//
//  IllegalReportAbnormalViewModel.m
//  移动采集
//
//  Created by hcat on 2019/6/14.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "IllegalReportAbnormalViewModel.h"

@implementation IllegalReportAbnormalViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.param = [[IllegalReportAbnormalParam alloc] init];
        
        self.subject = [RACSubject subject];
        
        @weakify(self);
        
        self.command_up = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                
                IllegalReportAbnormalManger *manger = [[IllegalReportAbnormalManger alloc] init];
                
                if (self.userPhoto) {
                    self.param.files = [[NSArray alloc] initWithObjects:self.userPhoto, nil];
                }
                manger.param = self.param;
                [manger configLoadingTitle:@"提交"];

                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:@"提交成功"];
                    }
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendCompleted];
                }];
                
                return nil;
                
            }];
            
            return signal;
        }];
        
        
    }
    
    return self;
    
}


@end

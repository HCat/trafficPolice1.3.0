//
//  MainViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainViewModel.h"


@implementation MainViewModel


- (RACCommand *)command_userIcon{
    
    if (_command_userIcon == nil) {
        
        @weakify(self);
        _command_userIcon = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {

            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                MainLoginCheckManger * manger = [[MainLoginCheckManger alloc] init];
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        self.photoUrl = manger.photoUrl;
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
                           
            return [t_signal takeUntil:self.cancelCommand.executionSignals];

        }];
               
        
    }
    
    
    return _command_userIcon;
    
}


@end

//
//  MainAllViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/14.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "MainAllViewModel.h"

@implementation MainAllViewModel

- (void)lr_initialize{
    
    self.arr_menu = @[].mutableCopy;
    
}

- (RACCommand *)command_menu{
    
    if (_command_menu == nil) {
        
        @weakify(self);
        _command_menu = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                

                MainMenuTypeManger * manger = [[MainMenuTypeManger alloc] init];
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        [self.arr_menu removeAllObjects];
                        [self.arr_menu addObjectsFromArray:manger.mainResponse];
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
    
    
    
    return _command_menu;
    
}


@end

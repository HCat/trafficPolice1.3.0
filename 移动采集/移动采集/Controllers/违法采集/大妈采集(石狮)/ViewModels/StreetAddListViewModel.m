//
//  StreetAddListViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2021/4/6.
//  Copyright © 2021 Hcat. All rights reserved.
//

#import "StreetAddListViewModel.h"

@implementation StreetAddListViewModel

- (instancetype)init{
    
    if (self = [super init]) {
    
        self.arr_content = @[].mutableCopy;
    
    }
    return self;
    
}
    
- (RACCommand *)command_loadList{

    if (_command_loadList == nil) {
        
        @weakify(self);
        _command_loadList = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                
                StreetListPagingParam *param = [[StreetListPagingParam alloc] init];
                param.start = [self.start integerValue];
                if (self.search.length > 0) {
                     param.search = self.search;
                }
               
                param.length = 10;
                if (self.state) {
                    param.state = self.state;
                }
                
                StreetListPagingManger * manger = [[StreetListPagingManger alloc] init];
                manger.param = param;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if ([self.start isEqualToNumber:@0]) {
                            [self.arr_content removeAllObjects];
                        }
                        self.permission = manger.illegalReponse.permission;
                        [self.arr_content addObjectsFromArray:manger.illegalReponse.list];
                        
                        if (self.arr_content.count == manger.illegalReponse.total) {
                            [subscriber sendNext:@"请求最后一条成功"];
                        }else{
                            [subscriber sendNext:@"加载成功"];
                            self.start = @([self.start integerValue] + param.length);
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
    
    return _command_loadList;
          
}


@end

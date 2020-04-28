//
//  ElectronicImageViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/4/27.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ElectronicImageViewModel.h"

@implementation ElectronicImageViewModel


- (instancetype)init{
    
    if (self = [super init]) {
        self.arr_upImages = [NSMutableArray array];
    }
        
    
    return self;
    
}


- (RACCommand *)command_image{
    
    if (_command_image == nil) {
        
        @weakify(self);
        _command_image = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ElectronicPoliceImageManger * manger = [[ElectronicPoliceImageManger alloc] init];
                manger.cameraId = self.cameraId;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if (self.arr_upImages.count > 0) {
                            [self.arr_upImages removeAllObjects];
                        }
                    
                        [self.arr_upImages addObjectsFromArray:manger.list];
                        
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
            
            return t_signal;
        }];
        
        
    }
    
    return _command_image;
    
}

@end

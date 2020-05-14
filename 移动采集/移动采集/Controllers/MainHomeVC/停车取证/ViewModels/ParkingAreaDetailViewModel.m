//
//  ParkingAreaDetailViewModel.m
//  移动采集
//
//  Created by hcat on 2019/7/28.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingAreaDetailViewModel.h"

@implementation ParkingAreaDetailViewModel


- (RACCommand *)requestCommand{
    
    if (_requestCommand == nil) {
        
        @weakify(self);
        _requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
        
                ParkingAreaDetailManger * manger = [[ParkingAreaDetailManger alloc] init];
                manger.parkPlaceId = self.parkplaceId;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    @strongify(self);
                    if (manger.responseModel.code == CODE_LAJI_SUCCESS) {
                        
                        self.areaDetailModel = manger.parkingReponse;
                        [subscriber sendNext:nil];
                        
                    }
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
        
    }
    
    return _requestCommand;
    
}


@end

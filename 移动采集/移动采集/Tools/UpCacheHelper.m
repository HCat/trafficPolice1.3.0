//
//  UpCacheHelper.m
//  移动采集
//
//  Created by hcat on 2018/10/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "UpCacheHelper.h"
#import "IllegalParkAPI.h"
#import "IllegalDBModel.h"

@interface UpCacheHelper()
@property (nonatomic,assign) UpCacheType cacheType;
@property (nonatomic,strong) RACCommand * racCommand;
@property (nonatomic,strong) NSMutableArray * arr_data;

@end



@implementation UpCacheHelper

LRSingletonM(Default)

- (instancetype)init{
    
    if (self = [super init]) {
        self.rac_upCache_success = [RACSubject subject];
        self.rac_upCache_error = [RACSubject subject];
        [self initialBind];
    }
    
    return self;
    
}

- (void)initialBind{
    
    @weakify(self);
    
    self.racCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        @strongify(self);
        RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            if (self.cacheType == UpCacheTypePark || self.cacheType == UpCacheTypeReversePark || self.cacheType == UpCacheTypeLockPark || self.cacheType == UpCacheTypeCarInfoAdd) {
                
                IllegalParkSaveManger *manger = [[IllegalParkSaveManger alloc] init];
                manger.param = input;
                manger.isNoShowFail = YES;
                
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:@"发送成功"];
                        [subscriber sendCompleted];
                    
                    }else{
                        NSError *error = [[NSError alloc] initWithDomain:@"upCacheDomain"
                                                                    code:manger.responseModel.code
                                                                userInfo:nil];
                        [subscriber sendError:error];
                        
                    }
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                   
                    [subscriber sendError:request.error];
                }];
                
                
            }else if(self.cacheType == UpCacheTypeThrough){
                
                
            }else if(self.cacheType == UpCacheTypeAccident || self.cacheType == UpCacheTypeFastAccident){
                
                
            }
            
            return nil;

        }];
        

        return signal;
    }];
    
    
    
    
}




- (void)starWithType:(UpCacheType)cacheType WithData:(id)data{
    
    self.cacheType = cacheType;
    
    if (self.cacheType == UpCacheTypePark || self.cacheType == UpCacheTypeReversePark || self.cacheType == UpCacheTypeLockPark || self.cacheType == UpCacheTypeCarInfoAdd) {
        
        IllegalDBModel * model = (IllegalDBModel *)data;
        
        RACSignal * signal = [self.racCommand execute:[model mapIllegalParkSaveParam]];
        
        @weakify(self);
        [signal subscribeNext:^(NSString * _Nullable x) {
            @strongify(self);
            if ([x isEqualToString:@"发送成功"]) {
                [model deleteDB];
                [self.rac_upCache_success sendNext:model];
            }
        
        }error:^(NSError * _Nullable error) {
            
            if ([error.localizedDescription isEqualToString:@"upCacheDomain"]) {
                [model deleteDB];
                [self.rac_upCache_success sendNext:model];
            }else{
                [self.rac_upCache_error sendNext:model];
            }
        }];
        
    
    }else if(self.cacheType == UpCacheTypeThrough){
        
        
    }else if(self.cacheType == UpCacheTypeAccident || self.cacheType == UpCacheTypeFastAccident){
        
        
    }
    
    
    
    
}


- (void)stop{
    
    
    
}


@end

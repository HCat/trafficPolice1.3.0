//
//  UpCacheHelper.m
//  移动采集
//
//  Created by hcat on 2018/10/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "UpCacheHelper.h"
#import "IllegalParkAPI.h"
#import "IllegalThroughAPI.h"
#import "IllegalDBModel.h"

@interface UpCacheHelper()
@property (nonatomic,assign) UpCacheType cacheType;
@property (nonatomic,strong) RACCommand * racCommand;
@property (nonatomic,strong) RACSubject * rac_cancel;

@end



@implementation UpCacheHelper

LRSingletonM(Default)

- (instancetype)init{
    
    if (self = [super init]) {
        self.rac_upCache_success = [RACSubject subject];
        self.rac_upCache_error = [RACSubject subject];
        self.rac_progress = [RACSubject subject];
        self.rac_cancel = [RACSubject subject];
        [self initialBind];
    }
    
    return self;
    
}

- (void)initialBind{
    
    WS(weakSelf);
    
    self.racCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        SW(strongSelf, weakSelf);
        
        RACTupleUnpack(id input_param,NSNumber *index) = input;
    
        RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
            if (strongSelf.cacheType == UpCacheTypePark || strongSelf.cacheType == UpCacheTypeReversePark || strongSelf.cacheType == UpCacheTypeLockPark || strongSelf.cacheType == UpCacheTypeCarInfoAdd) {
                
                IllegalParkSaveManger *manger = [[IllegalParkSaveManger alloc] init];
                manger.param = input_param;
                if ([manger.param.type isEqualToNumber:@(ParkTypeCarInfoAdd)]) {
                    manger.param.state = nil;
                }
                manger.isUpCache = YES;
                
                [RACObserve(manger,progress) subscribeNext:^(id  _Nullable x) {
                    RACTuple *tuple = RACTuplePack(x,index);
                    [strongSelf.rac_progress sendNext:tuple];
                }];
                
                
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:@"发送成功"];
                        [subscriber sendCompleted];
                        
                    }else{
                        
                        NSError *error = [[NSError alloc] initWithDomain:@"upCacheDomain"
                                                                    code:10086
                                                                userInfo:nil];
                        [subscriber sendError:error];
                        
                    }
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendError:request.error];
                }];
                
                
                
            }else if(self.cacheType == UpCacheTypeThrough){
                
                IllegalThroughSaveManger *manger = [[IllegalThroughSaveManger alloc] init];
                manger.param = input_param;
                manger.param.type = nil;
    
                manger.isUpCache = YES;
                
                [RACObserve(manger,progress) subscribeNext:^(id  _Nullable x) {
                    RACTuple *tuple = RACTuplePack(x,index);
                    [strongSelf.rac_progress sendNext:tuple];
                }];
                
                
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:@"发送成功"];
                        [subscriber sendCompleted];
                        
                    }else{
                        
                        NSError *error = [[NSError alloc] initWithDomain:@"upCacheDomain"
                                                                    code:10086
                                                                userInfo:nil];
                        [subscriber sendError:error];
                        
                    }
                    
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendError:request.error];
                }];
                
            
            }else if(self.cacheType == UpCacheTypeAccident || self.cacheType == UpCacheTypeFastAccident){
                
                
            }
            
            return nil;
            
        }];
        
       
        return [signal takeUntil:self.rac_cancel];
    }];
    
}

- (void)starWithType:(UpCacheType)cacheType WithData:(id)data{
    
    self.cacheType = cacheType;
    
    if (self.cacheType == UpCacheTypePark || self.cacheType == UpCacheTypeReversePark || self.cacheType == UpCacheTypeLockPark || self.cacheType == UpCacheTypeCarInfoAdd || self.cacheType == UpCacheTypeThrough) {
        
        IllegalDBModel * model = (IllegalDBModel *)data;
        RACTuple *tuple = RACTuplePack([model mapIllegalParkSaveParam],@(model.rowid));
        RACSignal * signal = [self.racCommand execute:tuple];
        
        WS(weakSelf);
        [signal subscribeNext:^(NSString * _Nullable x) {
            SW(strongSelf, weakSelf);
            if ([x isEqualToString:@"发送成功"]) {
                [strongSelf.rac_upCache_success sendNext:model];
            }
        
        }error:^(NSError * _Nullable error) {
            SW(strongSelf, weakSelf);
            if (error.code == 10086) {
                [strongSelf.rac_upCache_success sendNext:model];
            }else{
                [strongSelf.rac_upCache_error sendNext:model];
            }
        }];
        
    
    }else if(self.cacheType == UpCacheTypeAccident || self.cacheType == UpCacheTypeFastAccident){
        
        
    }
    
}


- (void)stop{
    
   [self.rac_cancel sendNext:@1];
    
}


@end

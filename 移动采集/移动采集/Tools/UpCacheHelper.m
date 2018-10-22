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
#import "AccidentAPI.h"
#import "FastAccidentAPI.h"
#import "IllegalDBModel.h"
#import "AccidentDBModel.h"
#import "AutomaicUpCacheModel.h"

@interface UpCacheHelper()
@property (nonatomic,assign) UpCacheType cacheType;
@property (nonatomic,strong) RACCommand * racCommandOne;
@property (nonatomic,strong) RACCommand * racCommandAll;
@property (nonatomic,strong) RACSubject * rac_cancel;
@property (nonatomic,strong) RACSubject * rac_cancelAll;
@property (nonatomic,strong) NSMutableArray * arr_auto;
@property (nonatomic,assign) BOOL isUpingAll;

@end



@implementation UpCacheHelper

LRSingletonM(Default)

- (instancetype)init{
    
    if (self = [super init]) {
        self.rac_upCache_success = [RACSubject subject];
        self.rac_upCache_error = [RACSubject subject];
        self.rac_progress = [RACSubject subject];
        self.rac_cancel = [RACSubject subject];
        self.rac_cancelAll = [RACSubject subject];
        self.isUpingAll = NO;
        [self initialBind];
    }
    
    return self;
    
}

- (void)initialBind{
    [self racCommandOne];
    [self racCommandAll];
    
}

- (RACCommand *)racCommandOne{
    
    if (!_racCommandOne) {
        WS(weakSelf);
        _racCommandOne = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            SW(strongSelf, weakSelf);
            
            RACTupleUnpack(id input_param,NSNumber *index) = input;
            
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                if (strongSelf.cacheType == UpCacheTypePark || strongSelf.cacheType == UpCacheTypeReversePark || strongSelf.cacheType == UpCacheTypeLockPark || strongSelf.cacheType == UpCacheTypeCarInfoAdd) {
                    
                    IllegalDBModel * model = (IllegalDBModel *)input_param;
                    
                    IllegalParkSaveManger *manger = [[IllegalParkSaveManger alloc] init];
                    manger.param = [model mapIllegalParkSaveParam];
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
                    
                    IllegalDBModel * model = (IllegalDBModel *)input_param;
                    
                    if (model.illegalThroughId) {
                        
                        IllegalThroughSecSaveManger *manger = [[IllegalThroughSecSaveManger alloc] init];
                        manger.param = [model mapIllegalThroughSecSaveParam];
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
                        
                        
                    }else{
                        
                        IllegalThroughCarNoSecManger * manger = [[IllegalThroughCarNoSecManger alloc] init];
                        manger.carNo = model.carNo;
                        manger.roadId = model.roadId;
                        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                            
                            if (manger.responseModel.code == 0) {
                                
                                NSNumber * illegalThroughId = manger.responseModel.data[@"id"];
                                
                                IllegalThroughSecSaveParam * param = [[IllegalThroughSecSaveParam alloc] init];
                                param.illegalThroughId = illegalThroughId;
                                param.files = @[model.files[0]];
                                param.remarks =  @"二次采集照";
                                param.taketimes = [model.taketimes componentsSeparatedByString:@","][0];
                                
                                model.illegalThroughId = param.illegalThroughId;
                                model.secFiles = param.files;
                                model.secRemarks = param.remarks;
                                model.secTaketimes = param.taketimes;
                                [model save];
                                
                                NSDate* date = [NSDate dateWithTimeIntervalSince1970:[model.commitTime doubleValue]/1000];
                                NSDate* date2 = [NSDate dateWithTimeIntervalSinceNow:0];
                                NSTimeInterval seconds = [date2 timeIntervalSinceDate:date];
                                param.offtime = @([@(seconds) integerValue]);
                                
                                IllegalThroughSecSaveManger *manger_sec = [[IllegalThroughSecSaveManger alloc] init];
                                manger_sec.param = param;
                                manger_sec.isUpCache = YES;
                                [RACObserve(manger_sec,progress) subscribeNext:^(id  _Nullable x) {
                                    RACTuple *tuple = RACTuplePack(x,index);
                                    [strongSelf.rac_progress sendNext:tuple];
                                }];
                                
                                [manger_sec startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                                    
                                    if (manger_sec.responseModel.code == CODE_SUCCESS) {
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
                                
                            }else {
                                
                                IllegalThroughSaveManger *manger = [[IllegalThroughSaveManger alloc] init];
                                manger.param = [model mapIllegalParkSaveParam];
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
                                
                            }
                            
                        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                            [subscriber sendError:request.error];
                        }];
                        
                    }
                    
                }else if(self.cacheType == UpCacheTypeAccident){
                    
                    AccidentDBModel * model = (AccidentDBModel *)input_param;
                    
                    AccidentUpManger *manger = [[AccidentUpManger alloc] init];
                    manger.param = [model mapAccidentUpParam];
                    manger.isUpCache = YES;
                    
                    [RACObserve(manger,progress) subscribeNext:^(id  _Nullable x) {
                        RACTuple *tuple = RACTuplePack(x,index);
                        [strongSelf.rac_progress sendNext:tuple];
                    }];
                    
                    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                        if (manger.responseModel.code == CODE_SUCCESS) {
                            
                            if ([manger.param.roadId isEqualToNumber:@0]) {
                                
                                [ShareValue sharedDefault].accidentCodes = nil;
                                [[ShareValue sharedDefault] accidentCodes];
                                [ShareValue sharedDefault].roadModels    = nil;
                                [[ShareValue sharedDefault] roadModels];
                                
                            }
                            
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
                    
                    
                    
                }else if(self.cacheType == UpCacheTypeFastAccident){
                    
                    AccidentDBModel * model = (AccidentDBModel *)input_param;
                    
                    FastAccidentUpManger *manger = [[FastAccidentUpManger alloc] init];
                    manger.param = [model mapAccidentUpParam];
                    manger.isUpCache = YES;
                    
                    [RACObserve(manger,progress) subscribeNext:^(id  _Nullable x) {
                        RACTuple *tuple = RACTuplePack(x,index);
                        [strongSelf.rac_progress sendNext:tuple];
                    }];
                    
                    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                        if (manger.responseModel.code == CODE_SUCCESS) {
                            
                            if ([manger.param.roadId isEqualToNumber:@0]) {
                                
                                [ShareValue sharedDefault].accidentCodes = nil;
                                [[ShareValue sharedDefault] accidentCodes];
                                [ShareValue sharedDefault].roadModels    = nil;
                                [[ShareValue sharedDefault] roadModels];
                                
                            }
                            
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
                    
                }
                
                return nil;
                
            }];
            
            
            return [signal takeUntil:self.rac_cancel];
        }];
    }
    
    return _racCommandOne;
    
}


- (void)startWithType:(UpCacheType)cacheType WithData:(id)data{
    
    self.cacheType = cacheType;
    
    if (self.cacheType == UpCacheTypePark || self.cacheType == UpCacheTypeReversePark || self.cacheType == UpCacheTypeLockPark || self.cacheType == UpCacheTypeCarInfoAdd || self.cacheType == UpCacheTypeThrough) {
        
        IllegalDBModel * model = (IllegalDBModel *)data;
        RACTuple *tuple = RACTuplePack(model,@(model.rowid));
        RACSignal * signal = [self.racCommandOne execute:tuple];
        
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
        
        AccidentDBModel * model = (AccidentDBModel *)data;
        RACTuple *tuple = RACTuplePack(model,@(model.rowid));
        RACSignal * signal = [self.racCommandOne execute:tuple];
        
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
        
    }
    
}

- (void)stop{
   [self.rac_cancel sendNext:@1];
}

#pragma mark - 全部自动上传功能

- (RACCommand *)racCommandAll{
    
    if (!_racCommandAll) {
        WS(weakSelf);
        _racCommandAll = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            SW(strongSelf, weakSelf);
            
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                if (strongSelf.cacheType == UpCacheTypePark || strongSelf.cacheType == UpCacheTypeReversePark || strongSelf.cacheType == UpCacheTypeLockPark || strongSelf.cacheType == UpCacheTypeCarInfoAdd) {
                    
                    IllegalDBModel * model = (IllegalDBModel *)input;
                    
                    IllegalParkSaveManger *manger = [[IllegalParkSaveManger alloc] init];
                    manger.param = [model mapIllegalParkSaveParam];
                    if ([manger.param.type isEqualToNumber:@(ParkTypeCarInfoAdd)]) {
                        manger.param.state = nil;
                    }
                    manger.isUpCache = YES;
                    
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
                    
                    IllegalDBModel * model = (IllegalDBModel *)input;
                    
                    if (model.illegalThroughId) {
                        
                        IllegalThroughSecSaveManger *manger = [[IllegalThroughSecSaveManger alloc] init];
                        manger.param = [model mapIllegalThroughSecSaveParam];
                        manger.isUpCache = YES;
        
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
                        
                        
                    }else{
                        
                        IllegalThroughCarNoSecManger * manger = [[IllegalThroughCarNoSecManger alloc] init];
                        manger.carNo = model.carNo;
                        manger.roadId = model.roadId;
                        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                            
                            if (manger.responseModel.code == 0) {
                                
                                NSNumber * illegalThroughId = manger.responseModel.data[@"id"];
                                
                                IllegalThroughSecSaveParam * param = [[IllegalThroughSecSaveParam alloc] init];
                                param.illegalThroughId = illegalThroughId;
                                param.files = @[model.files[0]];
                                param.remarks =  @"二次采集照";
                                param.taketimes = [model.taketimes componentsSeparatedByString:@","][0];
                                
                                model.illegalThroughId = param.illegalThroughId;
                                model.secFiles = param.files;
                                model.secRemarks = param.remarks;
                                model.secTaketimes = param.taketimes;
                                [model save];
                                
                                NSDate* date = [NSDate dateWithTimeIntervalSince1970:[model.commitTime doubleValue]/1000];
                                NSDate* date2 = [NSDate dateWithTimeIntervalSinceNow:0];
                                NSTimeInterval seconds = [date2 timeIntervalSinceDate:date];
                                param.offtime = @([@(seconds) integerValue]);
                                
                                IllegalThroughSecSaveManger *manger_sec = [[IllegalThroughSecSaveManger alloc] init];
                                manger_sec.param = param;
                                manger_sec.isUpCache = YES;
                    
                                [manger_sec startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                                    
                                    if (manger_sec.responseModel.code == CODE_SUCCESS) {
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
                                
                            }else {
                                
                                IllegalThroughSaveManger *manger = [[IllegalThroughSaveManger alloc] init];
                                manger.param = [model mapIllegalParkSaveParam];
                                manger.param.type = nil;
                                manger.isUpCache = YES;
                                
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
                                
                            }
                            
                        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                            [subscriber sendError:request.error];
                        }];
                        
                    }
                    
                }else if(self.cacheType == UpCacheTypeAccident){
                    
                    AccidentDBModel * model = (AccidentDBModel *)input;
                    
                    AccidentUpManger *manger = [[AccidentUpManger alloc] init];
                    manger.param = [model mapAccidentUpParam];
                    manger.isUpCache = YES;
                    
                    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                        if (manger.responseModel.code == CODE_SUCCESS) {
                            
                            if ([manger.param.roadId isEqualToNumber:@0]) {
                                
                                [ShareValue sharedDefault].accidentCodes = nil;
                                [[ShareValue sharedDefault] accidentCodes];
                                [ShareValue sharedDefault].roadModels    = nil;
                                [[ShareValue sharedDefault] roadModels];
                                
                            }
                            
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
                    
                    
                    
                }else if(self.cacheType == UpCacheTypeFastAccident){
                    
                    AccidentDBModel * model = (AccidentDBModel *)input;
                    
                    FastAccidentUpManger *manger = [[FastAccidentUpManger alloc] init];
                    manger.param = [model mapAccidentUpParam];
                    manger.isUpCache = YES;
                    
                    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        
                        if (manger.responseModel.code == CODE_SUCCESS) {
                            
                            if ([manger.param.roadId isEqualToNumber:@0]) {
                                
                                [ShareValue sharedDefault].accidentCodes = nil;
                                [[ShareValue sharedDefault] accidentCodes];
                                [ShareValue sharedDefault].roadModels    = nil;
                                [[ShareValue sharedDefault] roadModels];
                                
                            }
                            
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
                    
                }
                
                return nil;
                
            }];
            
            
            return [signal takeUntil:self.rac_cancelAll];
        }];
    }
    
    return _racCommandAll;
    
}




- (void)startWithAll{
    
    self.isUpingAll = YES;
    self.arr_auto = @[].mutableCopy;

    if([AutomaicUpCacheModel sharedDefault].isAutoPark == YES){
        [_arr_auto addObjectsFromArray:[IllegalDBModel localArrayFormType:@(ParkTypePark)]];
    }
    
    if ([AutomaicUpCacheModel sharedDefault].isAutoReversePark == YES) {
        [_arr_auto addObjectsFromArray:[IllegalDBModel localArrayFormType:@(ParkTypeReversePark)]];
    }
    
    if ([AutomaicUpCacheModel sharedDefault].isAutoLockPark == YES) {
        [_arr_auto addObjectsFromArray:[IllegalDBModel localArrayFormType:@(ParkTypeLockPark)]];
    }
    
    if ([AutomaicUpCacheModel sharedDefault].isAutoCarInfoAdd == YES) {
        [_arr_auto addObjectsFromArray:[IllegalDBModel localArrayFormType:@(ParkTypeCarInfoAdd)]];
    }
    
    if ([AutomaicUpCacheModel sharedDefault].isAutoThrough == YES) {
        [_arr_auto addObjectsFromArray:[IllegalDBModel localArrayFormType:@(ParkTypeThrough)]];
    }
    
    if ([AutomaicUpCacheModel sharedDefault].isAutoAccident == YES) {
        [_arr_auto addObjectsFromArray:[AccidentDBModel localArrayFormType:@(AccidentTypeAccident)]];
    }
    
    if ([AutomaicUpCacheModel sharedDefault].isAutoFastAccident == YES) {
        [_arr_auto addObjectsFromArray:[AccidentDBModel localArrayFormType:@(AccidentTypeFastAccident)]];
    }
    
    [self startAllNext];

}

- (void)startAllNext{
    
    if (!self.isUpingAll) {
        return;
    }
    
    NSLog(@"******************startWithAll******************");
    
    if (_arr_auto.count > 0) {
        id model = _arr_auto[0];
        
        if ([model isKindOfClass:[IllegalDBModel class]]) {
            IllegalDBModel * model_t = (IllegalDBModel *)model;
            if ([model_t.type isEqualToNumber:@(ParkTypePark)]) {
                [self startAllWithType:UpCacheTypePark WithData:model_t];
            }else if ([model_t.type isEqualToNumber:@(ParkTypeReversePark)]) {
                [self startAllWithType:UpCacheTypeReversePark WithData:model_t];
            }else if ([model_t.type isEqualToNumber:@(ParkTypeLockPark)]) {
                [self startAllWithType:UpCacheTypeLockPark WithData:model_t];
            }else if ([model_t.type isEqualToNumber:@(ParkTypeCarInfoAdd)]) {
                [self startAllWithType:UpCacheTypeCarInfoAdd WithData:model_t];
            }else if ([model_t.type isEqualToNumber:@(ParkTypeThrough)]) {
                [self startAllWithType:UpCacheTypeThrough WithData:model_t];
            }
        
        }else if ([model isKindOfClass:[AccidentDBModel class]]){
            AccidentDBModel * model_t = (AccidentDBModel *)model;
            if ([model_t.type isEqualToNumber:@(AccidentTypeAccident)]) {
                [self startAllWithType:UpCacheTypeAccident WithData:model_t];
            }else if ([model_t.type isEqualToNumber:@(AccidentTypeFastAccident)]) {
                [self startAllWithType:UpCacheTypeFastAccident WithData:model_t];
            }
        
        }
    
    }
    
}


- (void)startAllWithType:(UpCacheType)cacheType WithData:(id)data{
    
    self.cacheType = cacheType;
    
    if (self.cacheType == UpCacheTypePark || self.cacheType == UpCacheTypeReversePark || self.cacheType == UpCacheTypeLockPark || self.cacheType == UpCacheTypeCarInfoAdd || self.cacheType == UpCacheTypeThrough) {
        
        IllegalDBModel * model = (IllegalDBModel *)data;
        RACSignal * signal = [self.racCommandAll execute:model];
        
        WS(weakSelf);
        [signal subscribeNext:^(NSString * _Nullable x) {
            SW(strongSelf, weakSelf);
            if ([x isEqualToString:@"发送成功"]) {
                [strongSelf.arr_auto removeObject:model];
                [model deleteDB];
                [[RACScheduler currentScheduler] afterDelay:3 schedule:^{
                    [strongSelf startAllNext];
                }];
            }
            
        }error:^(NSError * _Nullable error) {
            SW(strongSelf, weakSelf);
            if (error.code == 10086) {
                [strongSelf.arr_auto removeObject:model];
                [model deleteDB];
                [[RACScheduler currentScheduler] afterDelay:3 schedule:^{
                    [strongSelf startAllNext];
                }];
            }else{
                [[RACScheduler currentScheduler] afterDelay:kUpCacheFrequency schedule:^{
                    [strongSelf startAllNext];
                }];
            }
        }];
        
        
    }else if(self.cacheType == UpCacheTypeAccident || self.cacheType == UpCacheTypeFastAccident){
        
        AccidentDBModel * model = (AccidentDBModel *)data;
        RACSignal * signal = [self.racCommandAll execute:model];
        
        WS(weakSelf);
        [signal subscribeNext:^(NSString * _Nullable x) {
            SW(strongSelf, weakSelf);
            if ([x isEqualToString:@"发送成功"]) {
                [strongSelf.arr_auto removeObject:model];
                [model deleteDB];
                [[RACScheduler currentScheduler] afterDelay:3 schedule:^{
                    [strongSelf startAllNext];
                    
                }];
            }
            
        }error:^(NSError * _Nullable error) {
            SW(strongSelf, weakSelf);
            if (error.code == 10086) {
                [strongSelf.arr_auto removeObject:model];
                [model deleteDB];
                [[RACScheduler currentScheduler] afterDelay:3 schedule:^{
                    [strongSelf startAllNext];
                    
                }];
            }else{
                [[RACScheduler currentScheduler] afterDelay:kUpCacheFrequency schedule:^{
                    [strongSelf startAllNext];
                    
                }];
            }
           
        }];
        
    }
    
}

- (void)stopAll{
    self.isUpingAll = NO;
    [self.rac_cancelAll sendNext:@1];
    
}


@end

//
//  AccidentUpListViewModel.m
//  移动采集
//
//  Created by hcat on 2018/10/19.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentUpListViewModel.h"
#import "UpCacheHelper.h"
#import "AccidentDBModel.h"
#import "AutomaicUpCacheModel.h"


@implementation AccidentUpListCellViewModel

- (void)dealloc{
    NSLog(@"AccidentUpListCellViewModel dealloc");
    
}

@end

@interface AccidentUpListViewModel ()

@property (nonatomic, strong) AccidentGetCodesResponse * accidentCodes;  //事故通用值

@end


@implementation AccidentUpListViewModel


- (instancetype)init{
    
    if (self = [super init]) {
        self.rac_addCache = [RACSubject subject];
        self.rac_deleteCache = [RACSubject subject];
        WS(weakSelf);
        
        [[[UpCacheHelper sharedDefault] rac_progress] subscribeNext:^(id  _Nullable x) {
            SW(strongSelf, weakSelf);
            RACTupleUnpack(NSNumber * x_progress,NSNumber *index) = x;
            for (AccidentUpListCellViewModel * model in strongSelf.arr_viewModel) {
                if ([model.accidentId isEqualToNumber:index]) {
                    model.progress = [x_progress floatValue];
                    break;
                }
            }
        }];
        
        [[[UpCacheHelper sharedDefault] rac_upCache_success] subscribeNext:^(id  _Nullable x) {
            SW(strongSelf, weakSelf);
            
            [[RACScheduler currentScheduler] afterDelay:1 schedule:^{
                AccidentDBModel * model = (AccidentDBModel *)x;
                [model deleteDB];
                NSInteger index = -1;
                [strongSelf.arr_accident removeObject:model];
                
                for (AccidentUpListCellViewModel * model_t in strongSelf.arr_viewModel) {
                    if ([model_t.accidentId isEqualToNumber:@(model.rowid)]) {
                        index = [strongSelf.arr_viewModel indexOfObject:model_t];
                        [strongSelf.arr_viewModel removeObject:model_t];
                        break;
                    }
                }
                
                if (strongSelf.arr_accident.count > 0) {
                    [strongSelf startUpCache];
                }else{
                    strongSelf.isUping = NO;
                }
                
                [strongSelf.rac_deleteCache sendNext:@(index)];
                
                strongSelf.illegalCount = @(strongSelf.arr_accident.count);
                
            }];
            
            
        }];
        
        
        [[[UpCacheHelper sharedDefault] rac_upCache_error] subscribeNext:^(id  _Nullable x) {
            SW(strongSelf, weakSelf);
            if (strongSelf.arr_accident.count > 0 && strongSelf.isUping) {
                [[RACScheduler currentScheduler] afterDelay:kUpCacheFrequency schedule:^{
                    [strongSelf startUpCache];
                    
                }];
            }else{
                strongSelf.isUping = NO;
            }
            
        }];
        
        [self.rac_addCache subscribeNext:^(id  _Nullable x) {
            SW(strongSelf, weakSelf);
            if (strongSelf.isAutoUp) {
                strongSelf.isUping = YES;
            }
        }];
        
        
    }
    
    return self;
}

- (AccidentGetCodesResponse *)accidentCodes{
    
    _accidentCodes = [ShareValue sharedDefault].accidentCodes;
    
    return _accidentCodes;
    
}


- (void)setAccidentType:(AccidentType)accidentType{
    
    _accidentType = accidentType;
    WS(weakSelf);
    switch (_accidentType) {
        case AccidentTypeAccident:{
            [RACObserve([AutomaicUpCacheModel sharedDefault], isAutoAccident) subscribeNext:^(NSNumber * x) {
                SW(strongSelf,weakSelf);
                strongSelf.isUping = [x boolValue];
                strongSelf.isAutoUp = [x boolValue];
            }];
        }
            break;
        case AccidentTypeFastAccident:{
            [RACObserve([AutomaicUpCacheModel sharedDefault], isAutoFastAccident) subscribeNext:^(NSNumber * x) {
                SW(strongSelf,weakSelf);
                strongSelf.isUping = [x boolValue];
                strongSelf.isAutoUp = [x boolValue];
            }];
        }
            break;
        default:
            break;
    }
    
}



#pragma mark - 懒加载

- (NSMutableArray *)arr_viewModel{
    
    if (!_arr_viewModel) {
        _arr_viewModel = @[].mutableCopy;
    }
    
    return _arr_viewModel;
    
}

#pragma mark - 获取cell的ViewModel数组

- (void)setArr_accident:(NSMutableArray *)arr_accident{
    
    _arr_accident = arr_accident;
    
    WS(weakSelf);
    NSArray * t_arr = [[_arr_accident.rac_sequence map:^id(AccidentDBModel * value) {
        SW(strongSelf, weakSelf);
        AccidentUpListCellViewModel * cellModel = [[AccidentUpListCellViewModel alloc] init];
        
        NSString * cause = [strongSelf.accidentCodes searchNameWithModelId:[value.causesType integerValue] WithArray:strongSelf.accidentCodes.cause];
        
        cellModel.accidentId = @(value.rowid);
        cellModel.carNumber = cause;
        cellModel.address = value.address;
        cellModel.time = value.commitTime;
        
        return cellModel;
        
        
    }] array];
    
    if (self.arr_viewModel.count > 0) {
        [self.arr_viewModel removeAllObjects];
    }
    
    [self.arr_viewModel addObjectsFromArray:t_arr];
    
}


- (void)setIsUping:(BOOL)isUping{
    
    _isUping = isUping;
    
    [self stopUpCache];
    
    if (_isUping) {
        [self startUpCache];
    }
    
}


- (void)startUpCache{
    
    if (_arr_accident.count > 0) {
        
        switch (_accidentType) {
            case AccidentTypeAccident:
                [[UpCacheHelper sharedDefault] starWithType:UpCacheTypeAccident WithData:_arr_accident[0]];
                break;
            case AccidentTypeFastAccident:
                [[UpCacheHelper sharedDefault] starWithType:UpCacheTypeFastAccident WithData:_arr_accident[0]];
                break;
            default:
                break;
        }
        
    }
    
}


- (void)stopUpCache{
    [[UpCacheHelper sharedDefault] stop];
}

- (void)dealloc{
    
    [[UpCacheHelper sharedDefault] stop];
    [[[UpCacheHelper sharedDefault] rac_progress] sendCompleted];
    [[[UpCacheHelper sharedDefault] rac_upCache_success] sendCompleted];
    [[[UpCacheHelper sharedDefault] rac_upCache_error] sendCompleted];
    
    NSLog(@"IllegalParkUpListViewModel dealloc");
    
}

@end

//
//  IllegalParkUpListViewModel.m
//  移动采集
//
//  Created by hcat on 2018/9/30.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkUpListViewModel.h"
#import "UpCacheHelper.h"
#import "AutomaicUpCacheModel.h"

@implementation IllegalUpListCellViewModel

- (void)dealloc{
    NSLog(@"IllegalUpListCellViewModel dealloc");
    
}

@end

@implementation IllegalParkUpListViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        self.rac_addCache = [RACSubject subject];
        self.rac_deleteCache = [RACSubject subject];
        WS(weakSelf);
        
        [[[UpCacheHelper sharedDefault] rac_progress] subscribeNext:^(id  _Nullable x) {
            SW(strongSelf, weakSelf);
            RACTupleUnpack(NSNumber * x_progress,NSNumber *index) = x;
            for (IllegalUpListCellViewModel * model in strongSelf.arr_viewModel) {
                if ([model.illegalId isEqualToNumber:index]) {
                    model.progress = [x_progress floatValue];
                    break;
                }
            }
        }];
        
        [[[UpCacheHelper sharedDefault] rac_upCache_success] subscribeNext:^(id  _Nullable x) {
            SW(strongSelf, weakSelf);
            
            [[RACScheduler currentScheduler] afterDelay:1 schedule:^{
                IllegalDBModel * model = (IllegalDBModel *)x;
                [model deleteDB];
                NSInteger index = -1;
                [strongSelf.arr_illegal removeObject:model];
                
                for (IllegalUpListCellViewModel * model_t in strongSelf.arr_viewModel) {
                    if ([model_t.illegalId isEqualToNumber:@(model.rowid)]) {
                        index = [strongSelf.arr_viewModel indexOfObject:model_t];
                        [strongSelf.arr_viewModel removeObject:model_t];
                        break;
                    }
                }
                
                if (strongSelf.arr_illegal.count > 0) {
                    [strongSelf startUpCache];
                }else{
                    strongSelf.isUping = NO;
                }
                
                [strongSelf.rac_deleteCache sendNext:@(index)];
                
                strongSelf.illegalCount = @(strongSelf.arr_illegal.count);
                
            }];
            
            
        }];
        
        
        [[[UpCacheHelper sharedDefault] rac_upCache_error] subscribeNext:^(id  _Nullable x) {
            SW(strongSelf, weakSelf);
            if (strongSelf.arr_illegal.count > 0 && strongSelf.isUping) {
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

- (void)setSubType:(ParkType)subType{
    
    _subType = subType;
    WS(weakSelf);
    switch (_subType) {
        case ParkTypePark:{
            [RACObserve([AutomaicUpCacheModel sharedDefault], isAutoPark) subscribeNext:^(NSNumber * x) {
                SW(strongSelf,weakSelf);
                strongSelf.isUping = [x boolValue];
                strongSelf.isAutoUp = [x boolValue];
            }];
        }
            break;
        case ParkTypeReversePark:{
            [RACObserve([AutomaicUpCacheModel sharedDefault], isAutoReversePark) subscribeNext:^(NSNumber * x) {
                SW(strongSelf,weakSelf);
                strongSelf.isUping = [x boolValue];
                strongSelf.isAutoUp = [x boolValue];
            }];
        }
            break;
        case ParkTypeLockPark:{
            [RACObserve([AutomaicUpCacheModel sharedDefault], isAutoLockPark) subscribeNext:^(NSNumber * x) {
                SW(strongSelf,weakSelf);
                strongSelf.isUping = [x boolValue];
                strongSelf.isAutoUp = [x boolValue];
            }];
        }
            break;
        case ParkTypeCarInfoAdd:{
            [RACObserve([AutomaicUpCacheModel sharedDefault], isAutoCarInfoAdd) subscribeNext:^(NSNumber * x) {
                SW(strongSelf,weakSelf);
                strongSelf.isUping = [x boolValue];
                strongSelf.isAutoUp = [x boolValue];
            }];
        }
        case ParkTypeThrough:{
            [RACObserve([AutomaicUpCacheModel sharedDefault], isAutoThrough) subscribeNext:^(NSNumber * x) {
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

- (void)setArr_illegal:(NSMutableArray *)arr_illegal{
    
    _arr_illegal = arr_illegal;
    
    NSArray * t_arr = [[_arr_illegal.rac_sequence map:^id(IllegalDBModel * value) {
        
        IllegalUpListCellViewModel * cellModel = [[IllegalUpListCellViewModel alloc] init];
        cellModel.illegalId = @(value.rowid);
        cellModel.carNumber = value.carNo;
        cellModel.address = value.address;
        cellModel.time = value.commitTime;
        cellModel.isAbnormal = value.isAbnormal;
        
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
    
    if (_arr_illegal.count > 0) {
        
        switch (_subType) {
            case ParkTypePark:
                [[UpCacheHelper sharedDefault] startWithType:UpCacheTypePark WithData:_arr_illegal[0]];
                break;
            case ParkTypeReversePark:
                [[UpCacheHelper sharedDefault] startWithType:UpCacheTypeReversePark WithData:_arr_illegal[0]];
                break;
            case ParkTypeLockPark:
                [[UpCacheHelper sharedDefault] startWithType:UpCacheTypeLockPark WithData:_arr_illegal[0]];
                break;
            case ParkTypeCarInfoAdd:
                [[UpCacheHelper sharedDefault] startWithType:UpCacheTypeCarInfoAdd WithData:_arr_illegal[0]];
                break;
            case ParkTypeThrough:
                [[UpCacheHelper sharedDefault] startWithType:UpCacheTypeThrough WithData:_arr_illegal[0]];
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
    
    [self.rac_deleteCache sendCompleted];
    [self.rac_addCache sendCompleted];
    
    [[UpCacheHelper sharedDefault] stop];
    [[[UpCacheHelper sharedDefault] rac_progress] sendCompleted];
    [[[UpCacheHelper sharedDefault] rac_upCache_success] sendCompleted];
    [[[UpCacheHelper sharedDefault] rac_upCache_error] sendCompleted];
    
    NSLog(@"IllegalParkUpListViewModel dealloc");
    
}

@end

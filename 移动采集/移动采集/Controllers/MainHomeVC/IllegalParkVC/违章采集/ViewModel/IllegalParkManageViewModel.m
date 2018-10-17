//
//  IllegalParkManageViewModel.m
//  移动采集
//
//  Created by hcat on 2018/9/26.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkManageViewModel.h"
#import "IllegalDBModel.h"

@interface IllegalParkManageViewModel()


@end


@implementation IllegalParkManageViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        WS(weakSelf);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NOTIFICATION_ILLEGALPARK_ADDCACHE_SUCCESS object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            SW(strongSelf, weakSelf);
            strongSelf.listViewModel.arr_illegal = [[NSMutableArray alloc] initWithArray:[IllegalDBModel localArrayFormType:@(strongSelf.subType)]];
            strongSelf.listViewModel.illegalCount = @(strongSelf.listViewModel.arr_illegal.count);
            [strongSelf.listViewModel.rac_addCache sendNext:@1];
        }];
        
    }
    
    return self;
}



- (NSArray *)arr_item{
    
    if (!_arr_item) {
        _arr_item = @[].mutableCopy;
    }
    
    return _arr_item;
    
}

- (void)setSubType:(ParkType)subType{
    
    _subType = subType;
    
    switch (_subType) {
        case ParkTypePark:{
            [self.arr_item addObject:@"违停采集"];
            self.cacheType = UpCacheTypePark;
        }
            break;
        case ParkTypeReversePark:{
            [self.arr_item addObject:@"不按朝向"];
            self.cacheType = UpCacheTypeReversePark;
        }
            break;
        case ParkTypeLockPark:{
            [self.arr_item addObject:@"违停锁车"];
            self.cacheType = UpCacheTypeLockPark;
        }
            break;
        case ParkTypeCarInfoAdd:{
            [self.arr_item addObject:@"车辆录入"];
            self.cacheType = UpCacheTypeCarInfoAdd;
        }
            break;
        case ParkTypeThrough:{
            [self.arr_item addObject:@"违反禁令采集"];
            self.cacheType = UpCacheTypeThrough;
        }
            break;
        default:
            break;
    }
    
    [self.arr_item addObject:@"等待上传"];
    
}

- (IllegalParkUpListViewModel *)listViewModel{
    
    if (!_listViewModel) {
        _listViewModel = [[IllegalParkUpListViewModel alloc] init];
        _listViewModel.arr_illegal = [[NSMutableArray alloc] initWithArray:[IllegalDBModel localArrayFormType:@(self.subType)]];
        _listViewModel.illegalType = self.illegalType;
        _listViewModel.subType = self.subType;
        _listViewModel.illegalCount = @(_listViewModel.arr_illegal.count);
        RAC(self,illegalCount) = RACObserve(_listViewModel, illegalCount);
    }

    return _listViewModel;
    
}

- (void)dealloc{
    NSLog(@"IllegalParkManageViewModel dealloc");
    
}


@end

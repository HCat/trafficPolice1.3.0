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
        
        @weakify(self);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NOTIFICATION_ILLEGALPARK_ADDCACHE_SUCCESS object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            @strongify(self);
            self.listViewModel.arr_illegal = [[NSMutableArray alloc] initWithArray:[IllegalDBModel localArrayFormType:@(self.subType)]];
            self.illegalCount = @(self.listViewModel.arr_illegal.count);
            [self.listViewModel.racSubject sendNext:@1];
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


- (void)setIllegalType:(IllegalType)illegalType{
    
    _illegalType = illegalType;
    
    if (_illegalType == IllegalTypeThrough) {
        [self.arr_item addObject:@"违反禁令采集"];
        [self.arr_item addObject:@"等待上传"];
    }
    
}

- (void)setSubType:(ParkType)subType{
    
    _subType = subType;
    
    switch (_subType) {
        case ParkTypePark:
            [self.arr_item addObject:@"违停采集"];
            break;
        case ParkTypeReversePark:
            [self.arr_item addObject:@"不按朝向"];
            break;
        case ParkTypeLockPark:
            [self.arr_item addObject:@"违停锁车"];
            break;
        case ParkTypeCarInfoAdd:
            [self.arr_item addObject:@"车辆录入"];
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
        self.illegalCount = @(_listViewModel.arr_illegal.count);
        RAC(_listViewModel,illegalCount) = RACObserve(self, illegalCount);
    }

    return _listViewModel;
    
}


@end

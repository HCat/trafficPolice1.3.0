//
//  IllegalParkManageViewModel.m
//  移动采集
//
//  Created by hcat on 2018/9/26.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkManageViewModel.h"
#import <ReactiveObjC.h>
#import <RACEXTScope.h>

@implementation IllegalParkManageViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        @weakify(self);
        [[RACObserve(self, illegalCount) skip:1] subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            NSNumber * count = x;
            
        
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
        case ParkTypeThrough:
            [self.arr_item addObject:@"违反禁令采集"];
            break;
            
        default:
            break;
    }
    
    [self.arr_item addObject:@"等待上传"];
    
}



@end

//
//  IllegalParkUpListViewModel.m
//  移动采集
//
//  Created by hcat on 2018/9/30.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkUpListViewModel.h"


@implementation IllegalUpListCellViewModel

@end

@implementation IllegalParkUpListViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        self.racSubject = [RACSubject subject];
       
    }
    
    return self;
}


- (void)setArr_illegal:(NSMutableArray *)arr_illegal{
    
    _arr_illegal = arr_illegal;
    
    NSArray * t_arr = [[_arr_illegal.rac_sequence map:^id(IllegalDBModel * value) {
        
        IllegalUpListCellViewModel * cellModel = [[IllegalUpListCellViewModel alloc] init];
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

- (NSMutableArray *)arr_viewModel{
    
    if (!_arr_viewModel) {
        _arr_viewModel = @[].mutableCopy;
    }
    
    return _arr_viewModel;
    
}




@end

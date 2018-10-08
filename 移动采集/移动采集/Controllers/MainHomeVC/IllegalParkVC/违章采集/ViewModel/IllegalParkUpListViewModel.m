//
//  IllegalParkUpListViewModel.m
//  移动采集
//
//  Created by hcat on 2018/9/30.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalParkUpListViewModel.h"
#import "IllegalDBModel.h"

@implementation IllegalParkUpListViewModel

- (NSMutableArray *)arr_illegal{
    
    if (!_arr_illegal) {
        _arr_illegal = @[].mutableCopy;
    }
    
    return _arr_illegal;
    
}


@end

//
//  AccidentViewModel.m
//  移动采集
//
//  Created by hcat on 2018/10/19.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentViewModel.h"
#import "AccidentDBModel.h"

@implementation AccidentViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        WS(weakSelf);
        [[[NSNotificationCenter defaultCenter] rac_addObserverForName:NOTIFICATION_ACCIDENT_ADDCACHE_SUCCESS object:nil] subscribeNext:^(NSNotification * _Nullable x) {
            SW(strongSelf, weakSelf);
            strongSelf.listViewModel.arr_accident = [[NSMutableArray alloc] initWithArray:[AccidentDBModel localArrayFormType:@(strongSelf.accidentType)]];
            strongSelf.listViewModel.illegalCount = @(strongSelf.listViewModel.arr_accident.count);
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

- (void)setAccidentType:(AccidentType)accidentType{
    
    _accidentType = accidentType;
    
    switch (_accidentType) {
        case AccidentTypeAccident:{
            [self.arr_item addObject:@"事故录入"];
            self.cacheType = UpCacheTypeAccident;
        }
            break;
        case AccidentTypeFastAccident:{
            [self.arr_item addObject:@"快处录入"];
            self.cacheType = UpCacheTypeFastAccident;
        }
            break;
        default:
            break;
    }
    
    [self.arr_item addObject:@"等待上传"];
}


- (AccidentUpListViewModel *)listViewModel{
    
    if (!_listViewModel) {
        _listViewModel = [[AccidentUpListViewModel alloc] init];
        _listViewModel.arr_accident = [[NSMutableArray alloc] initWithArray:[AccidentDBModel localArrayFormType:@(self.accidentType)]];
        _listViewModel.accidentType = self.accidentType;
        _listViewModel.illegalCount = @(_listViewModel.arr_accident.count);
        RAC(self,illegalCount) = RACObserve(_listViewModel, illegalCount);
    }
    
    return _listViewModel;
    
}


- (void)dealloc{
    NSLog(@"AccidentViewModel dealloc");
    
}


@end

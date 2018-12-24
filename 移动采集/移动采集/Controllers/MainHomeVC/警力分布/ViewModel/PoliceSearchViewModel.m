//
//  PoliceSearchViewModel.m
//  移动采集
//
//  Created by hcat on 2018/12/20.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceSearchViewModel.h"
#import "PoliceDistributeAPI.h"
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import "VehicleGPSModel.h"

@interface PoliceSearchViewModel()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;

@end

@implementation PoliceSearchViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        self.type = @1;
        self.arr_data = @[].mutableCopy;
        
        self.searchSubject = [RACSubject subject];
        self.search = [[AMapSearchAPI alloc] init];
        self.search.delegate = self;
        
        @weakify(self);
        
        self.searchCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            RACSignal * signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                if ([self.type isEqualToNumber:@1]) {
                    @strongify(self);
                    PoliceDistributeSearchParam * param = [[PoliceDistributeSearchParam alloc] init];
                    param.keywords = self.keywords;
                    param.type = self.type;
                    
                    PoliceDistributeSearchManger * manger = [[PoliceDistributeSearchManger alloc] init];
                    manger.param = param;
                    manger.isNeedShowHud = NO;
                    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        @strongify(self);
                        
                        if (manger.responseModel.code == CODE_SUCCESS) {
                            
                            if (self.arr_data && self.arr_data.count > 0) {
                                [self.arr_data removeAllObjects];
                            }
                            
                            for (PoliceLocationModel * model in manger.resultList) {
                                
                                PoliceSearchCellViewModel *annotation = [[PoliceSearchCellViewModel alloc] init];
                                annotation.policeModel = model;
                                [self.arr_data addObject:annotation];
                            }
                            
                        };
                        
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                        
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [subscriber sendError:request.error];
                        [subscriber sendCompleted];
                    }];
                }else if ([self.type isEqualToNumber:@2]){
                    
                    @strongify(self);
                    PoliceDistributeSearchParam * param = [[PoliceDistributeSearchParam alloc] init];
                    param.keywords = self.keywords;
                    param.type = self.type;
                    
                    PoliceDistributeSearchManger * manger = [[PoliceDistributeSearchManger alloc] init];
                    manger.param = param;
                    manger.isNeedShowHud = NO;
                    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                        @strongify(self);
                        
                        if (manger.responseModel.code == CODE_SUCCESS) {
                            
                            if (self.arr_data && self.arr_data.count > 0) {
                                [self.arr_data removeAllObjects];
                            }
                            
                            for (VehicleGPSModel * model in manger.carList) {
                                
                                PoliceSearchCellViewModel *annotation = [[PoliceSearchCellViewModel alloc] init];
                                annotation.carModel = model;
                                [self.arr_data addObject:annotation];
                            }
                            
                        };
                        
                        [subscriber sendNext:nil];
                        [subscriber sendCompleted];
                        
                    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                        [subscriber sendError:request.error];
                        [subscriber sendCompleted];
                    }];
                    
                }else if ([self.type isEqualToNumber:@3]){
                    
                    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
                    request.keywords = input;
                    request.city = [LocationHelper sharedDefault].city ? [LocationHelper sharedDefault].city : @"晋江市";
                    request.cityLimit = YES;
                    [self.search AMapPOIKeywordsSearch:request];
                    [subscriber sendCompleted];
                    
                }
                
                return nil;
            }];
            
            return signal;
            
            
            
            
        }];
        
        
        
    }
    
    return self;
    
}

#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error{
    self.arr_data = @[].mutableCopy;
    [self.searchSubject sendNext:nil];
    
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    
    if (self.arr_data && self.arr_data.count > 0) {
        [self.arr_data removeAllObjects];
    }
    
    for (AMapPOI * poi in response.pois) {
        PoliceSearchCellViewModel *annotation = [[PoliceSearchCellViewModel alloc] init];
        annotation.poi = poi;
        [self.arr_data addObject:annotation];
    }
    
    [self.searchSubject sendNext:nil];
    
}

- (void)dealloc{
    [self.searchSubject sendCompleted];
    
}



@end

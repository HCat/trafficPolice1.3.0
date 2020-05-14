//
//  PoliceSearchCellViewModel.m
//  移动采集
//
//  Created by hcat on 2018/12/21.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceSearchCellViewModel.h"

@implementation PoliceSearchCellViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        @weakify(self);
        [RACObserve(self, policeModel) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.type = @1;
            self.title = self.policeModel.userName;
            
        }];
        
        [RACObserve(self, poi) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.type = @3;
            self.title = self.poi.name;
            
        }];
        
        [RACObserve(self, carModel) subscribeNext:^(id  _Nullable x) {
            @strongify(self);
            self.type = @2;
            self.title = self.carModel.plateNo;
        }];
        
        
    }
    
    return self;
}




@end

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
        
        [RACObserve(self, policeModel) subscribeNext:^(id  _Nullable x) {
            self.type = @1;
            self.title = self.policeModel.userName;
            
        }];
        
        
        
    }
    
    return self;
}




@end

//
//  BaseViewModel.m
//  框架
//
//  Created by hcat on 2019/5/21.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "BaseViewModel.h"

@implementation BaseViewModel

+ (instancetype)alloc{
    
    BaseViewModel *viewModel = [super alloc];
    
    if (viewModel) {
        
        [viewModel lr_initialize];
    }
    return viewModel;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _errors = [RACSubject subject];
        
        _cancelCommand = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal empty];
        }];
    }
    
    return self;
}


- (instancetype)initWithModel:(id)model {
    
    self = [super init];
    if (self) {
    }
    return self;
}


- (void)lr_initialize{
    

}

- (void)dealloc {
    [_errors sendCompleted];
    NSLog(@"%@-dealloc",[self class]);
}

@end

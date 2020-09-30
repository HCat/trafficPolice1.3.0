//
//  TakeOutAddVC.h
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "TakeOutAddViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TakeOutAddSuccessBlock)(void);


@interface TakeOutAddVC : HideTabSuperVC

@property(nonatomic,copy) TakeOutAddSuccessBlock block;

- (instancetype)initWithViewModel:(TakeOutAddViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END

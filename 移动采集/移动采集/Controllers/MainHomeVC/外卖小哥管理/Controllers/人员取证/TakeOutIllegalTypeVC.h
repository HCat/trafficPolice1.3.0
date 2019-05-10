//
//  TakeOutIllegalTypeVC.h
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "TakeOutIllegalTypeViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^TakeOutIllegalTypeBlock)(NSString *type,NSString *type_code);


@interface TakeOutIllegalTypeVC : HideTabSuperVC

@property(nonatomic,copy) TakeOutIllegalTypeBlock block;


- (instancetype)initWithViewModel:(TakeOutIllegalTypeViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END

//
//  IllegalSecAddVC.h
//  移动采集
//
//  Created by hcat-89 on 2020/2/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "IllegalSecAddViewModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^IllegalSecAddSuccessBlock)(void);

@interface IllegalSecAddVC : HideTabSuperVC

@property (nonatomic,copy)IllegalSecAddSuccessBlock saveSuccessBlock;


- (instancetype)initWithViewModel:(IllegalSecAddViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END

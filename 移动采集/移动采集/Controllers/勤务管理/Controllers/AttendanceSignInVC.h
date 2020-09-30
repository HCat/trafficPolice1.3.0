//
//  AttendanceSignInVC.h
//  移动采集
//
//  Created by hcat on 2019/4/4.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "AttendanceSignInViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AttendanceSignInVC : HideTabSuperVC

- (instancetype)initWithViewModel:(AttendanceSignInViewModel *)viewModel;

@end

NS_ASSUME_NONNULL_END

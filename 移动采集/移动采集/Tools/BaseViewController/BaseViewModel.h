//
//  BaseViewModel.h
//  框架
//
//  Created by hcat on 2019/5/21.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BaseViewModelProtocol.h"

NS_ASSUME_NONNULL_BEGIN

@interface BaseViewModel : NSObject <BaseViewModelProtocol>

@property (nonatomic) RACSubject *errors;

/**
 *  取消请求Command
 */
@property (nonatomic, strong, readonly) RACCommand *cancelCommand;


@end

NS_ASSUME_NONNULL_END

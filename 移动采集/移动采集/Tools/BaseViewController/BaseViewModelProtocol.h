//
//  BaseViewModelProtocol.h
//  框架
//
//  Created by hcat on 2019/5/21.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewModelProtocol <NSObject>

@optional

- (instancetype)initWithModel:(id)model;

/**
 *  初始化
 */
- (void)lr_initialize;

@end

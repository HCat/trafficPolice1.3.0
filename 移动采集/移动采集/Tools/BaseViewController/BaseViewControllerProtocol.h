//
//  BaseViewControllerProtocol.h
//  框架
//
//  Created by hcat on 2019/5/21.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BaseViewModelProtocol;

@protocol BaseViewControllerProtocol <NSObject>

@optional

- (instancetype)initWithViewModel:(id <BaseViewModelProtocol>)viewModel;

- (void)lr_configUI;
- (void)lr_bindViewModel;



@end

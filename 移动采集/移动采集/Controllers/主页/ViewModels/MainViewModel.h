//
//  MainViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "MainAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainViewModel : BaseViewModel

@property (nonatomic, strong) NSArray <NSString *> *titles;

@property (nonatomic, strong) RACCommand * command_userIcon;

@property (nonatomic, copy) NSString * photoUrl; //用户头像

@end

NS_ASSUME_NONNULL_END

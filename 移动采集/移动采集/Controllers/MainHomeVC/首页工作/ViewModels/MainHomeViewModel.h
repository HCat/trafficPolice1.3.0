//
//  MainHomeViewModel.h
//  移动采集
//
//  Created by hcat on 2019/5/7.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CommonAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface MainHomeViewModel : NSObject

@property (nonatomic,strong) NSMutableArray * arr_illegal;
@property (nonatomic,strong) NSMutableArray * arr_accident;
@property (nonatomic,strong) NSMutableArray * arr_policeMatter;

@property (nonatomic,strong) RACCommand * command_requestNotice;
@property (nonatomic,strong) RACCommand * command_requestMenu;


- (NSMutableArray *)arrayFromSection:(NSInteger)section;

@end

NS_ASSUME_NONNULL_END

//
//  TakeOutSearchViewModel.h
//  移动采集
//
//  Created by hcat on 2019/5/8.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakeOutAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TakeOutSearchViewModel : NSObject

@property (nonatomic, strong) NSMutableArray * arr_content;
@property(strong, nonatomic) NSNumber * index;          //分页第几页
@property (nonatomic,strong) RACCommand * requestCommand;
@property (nonatomic,copy)   NSString * key;  
@property (nonatomic,strong) NSNumber * type;

@end

NS_ASSUME_NONNULL_END

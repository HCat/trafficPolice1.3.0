//
//  PoliceSearchViewModel.h
//  移动采集
//
//  Created by hcat on 2018/12/20.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoliceSearchCellViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoliceSearchViewModel : NSObject

@property (nonatomic, strong) NSNumber * type;  //1警员 2警车 3位置
@property (nonatomic, strong) NSString * keywords;  //搜索内容
@property (nonatomic, strong) NSMutableArray <PoliceSearchCellViewModel *> * arr_data;    //
@property (nonatomic, strong) RACCommand * searchCommand;//搜索请求
@property (strong, nonatomic) RACSubject * searchSubject;

@end

NS_ASSUME_NONNULL_END

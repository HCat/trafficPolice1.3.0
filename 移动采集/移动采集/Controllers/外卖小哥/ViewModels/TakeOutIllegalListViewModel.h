//
//  TakeOutIllegalListViewModel.h
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakeOutAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TakeOutIllegalListViewModel : NSObject

@property (nonatomic, strong) NSMutableArray * arr_content;
@property(nonatomic,copy) NSString * deliveryId;
@property(nonatomic,strong) RACCommand * requestCommand;

@end

NS_ASSUME_NONNULL_END

//
//  UpCacheHelper.h
//  移动采集
//
//  Created by hcat on 2018/10/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface UpCacheHelper : NSObject

LRSingletonH(Default)

@property (nonatomic,strong) RACSubject * rac_upCache_success;
@property (nonatomic,strong) RACSubject * rac_upCache_error;
@property (nonatomic,strong) RACSubject * rac_progress;
@property (nonatomic,strong) NSNumber * progress;


- (void)starWithType:(UpCacheType)cacheType WithData:(id)data;
- (void)stop;



@end

NS_ASSUME_NONNULL_END

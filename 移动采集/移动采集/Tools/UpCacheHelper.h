//
//  UpCacheHelper.h
//  移动采集
//
//  Created by hcat on 2018/10/11.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, UpCacheType) {
    UpCacheTypePark = 10,            //违停
    UpCacheTypeReversePark = 11,     //逆向违停
    UpCacheTypeLockPark = 12,        //违停锁车
    UpCacheTypeCarInfoAdd = 13,      //车辆录入
    UpCacheTypeThrough = 14,         //闯禁令
    UpCacheTypeAccident = 15,        //事故采集
    UpCacheTypeFastAccident = 16,    //快处采集
    UpCacheTypeAll = 17              //全部上传
};

@interface UpCacheHelper : NSObject

LRSingletonH(Default)

@property (nonatomic,strong) RACSubject * rac_upCache_success;
@property (nonatomic,strong) RACSubject * rac_upCache_error;


- (void)starWithType:(UpCacheType)cacheType WithData:(id)data;
- (void)stop;



@end

NS_ASSUME_NONNULL_END

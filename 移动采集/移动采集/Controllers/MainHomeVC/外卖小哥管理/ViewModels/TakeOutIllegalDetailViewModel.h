//
//  TakeOutIllegalDetailViewModel.h
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakeOutAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TakeOutIllegalDetailViewModel : NSObject

@property (nonatomic,strong) DeliveryIllegalDetailModel * model;

@property (nonatomic,copy) NSString * reportId;             //记录编号
@property(nonatomic,strong) RACCommand * requestCommand;    //

- (void)showPhotoBrowser:(NSArray *)photos inView:(UIView *)view withTag:(long)tag;

@end

NS_ASSUME_NONNULL_END

//
//  TakeOutTempHeadView.h
//  移动采集
//
//  Created by hcat on 2019/7/31.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeOutAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TakeOutTempHeadView : UICollectionReusableView

@property (nonatomic,strong) TakeOutSubmitTempReportParam * param;
@property (nonatomic, strong) NSArray < DeliveryIllegalTypeModel *> * deliveryIllegalList; //道路通用值

@end

NS_ASSUME_NONNULL_END

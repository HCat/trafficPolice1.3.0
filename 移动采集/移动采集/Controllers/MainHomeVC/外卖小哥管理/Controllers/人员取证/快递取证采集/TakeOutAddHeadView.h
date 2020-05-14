//
//  TakeOutAddHeadView.h
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TakeOutAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TakeOutAddHeadView : UICollectionReusableView

@property (nonatomic,strong) TakeOutSaveParam * param;
@property (nonatomic, strong) NSArray < DeliveryIllegalTypeModel *> * deliveryIllegalList; //道路通用值


@end

NS_ASSUME_NONNULL_END

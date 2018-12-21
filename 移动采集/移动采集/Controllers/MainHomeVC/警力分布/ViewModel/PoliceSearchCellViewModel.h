//
//  PoliceSearchCellViewModel.h
//  移动采集
//
//  Created by hcat on 2018/12/21.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoliceLocationModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface PoliceSearchCellViewModel : NSObject

@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) NSNumber * type;
@property (nonatomic, strong) PoliceLocationModel * policeModel;

@end

NS_ASSUME_NONNULL_END

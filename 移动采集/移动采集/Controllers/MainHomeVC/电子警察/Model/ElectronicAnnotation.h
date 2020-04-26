//
//  ElectronicAnnotation.h
//  移动采集
//
//  Created by hcat-89 on 2020/4/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "ElectronicDetailModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface ElectronicAnnotation : MAPointAnnotation

@property(nonatomic, strong) ElectronicDetailModel * model;

@end

NS_ASSUME_NONNULL_END

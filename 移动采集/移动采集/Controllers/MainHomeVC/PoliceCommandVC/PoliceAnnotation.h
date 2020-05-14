//
//  PoliceAnnotation.h
//  移动采集
//
//  Created by hcat on 2017/9/11.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "UserGpsListModel.h"

@interface PoliceAnnotation : MAPointAnnotation

@property (nonatomic,strong) UserGpsListModel *userModel;

@end

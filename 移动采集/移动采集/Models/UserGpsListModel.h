//
//  UserGpsListModel.h
//  移动采集
//
//  Created by hcat on 2017/9/11.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserGpsListModel : NSObject

@property (nonatomic,copy)   NSString * userId;     //用户id

@property (nonatomic,copy)   NSString * userName;   //用户名称

@property (nonatomic,strong) NSNumber * longitude;  //经度

@property (nonatomic,strong) NSNumber * latitude;   //纬度

@property (nonatomic,copy)   NSArray <NSString  *> * groupIds; //所属分组id
@property (nonatomic,copy)   NSArray <NSString  *> * groupNames; //所属分组名


@end

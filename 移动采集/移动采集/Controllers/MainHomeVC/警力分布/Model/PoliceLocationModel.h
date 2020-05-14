//
//  PoliceLocationModel.h
//  移动采集
//
//  Created by hcat on 2018/11/14.
//  Copyright © 2018 Hcat. All rights reserved.
//

//  警员信息Model


#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoliceLocationModel : NSObject

@property (nonatomic, strong) NSNumber * userId;                        //用户id
@property (nonatomic, copy) NSString * userName;                        //用户名称
@property (nonatomic, strong) NSNumber * latitude;                      //纬度
@property (nonatomic, strong) NSNumber * longitude;                     //经度
@property (nonatomic, strong) NSArray <NSNumber *> * groupIds;          //所属分组id
@property (nonatomic, strong) NSArray <NSString *> * groupNames;        //所属分组名
@property (nonatomic, copy) NSString * departmentId;                    //机构id
@property (nonatomic, copy) NSString * departmentName;                  //机构名称
@property (nonatomic, copy) NSString * telNum;                          //用户手机号码

@end

NS_ASSUME_NONNULL_END

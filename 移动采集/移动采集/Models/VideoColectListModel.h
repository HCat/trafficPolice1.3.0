//
//  VideoColectListModel.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/21.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoColectListModel : NSObject

@property (nonatomic,copy)   NSString * videoColectId ; //主键
@property (nonatomic,strong) NSNumber * collectTime ;   //采集时间
@property (nonatomic,copy)   NSString * longitude ;     //经度
@property (nonatomic,copy)   NSString * latitude;       //纬度
@property (nonatomic,copy)   NSString * address ;       //路名
@property (nonatomic,copy)   NSString * memo;           //备注
@property (nonatomic,copy)   NSString * path ;          //视频文件路径
@property (nonatomic,copy)   NSString * previewUrl;     //预览图
@property (nonatomic,strong) NSNumber * videoLength ;   //视频长度

@end

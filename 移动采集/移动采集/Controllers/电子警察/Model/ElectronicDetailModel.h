//
//  ElectronicDetailModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/4/24.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ElectronicDetailModel : NSObject

@property (nonatomic,strong) NSNumber * electronicId;       //设备编号
@property (nonatomic,copy) NSString   * cameraType;         //设备类型编号
@property (nonatomic,copy) NSString   * usePlace;           //用处
@property (nonatomic,strong) NSNumber   * rotate;             //角度
@property (nonatomic,copy) NSString   * color;              //颜色
@property (nonatomic,strong) NSNumber * lat;                //经度
@property (nonatomic,strong) NSNumber * lng;                //纬度
@property (nonatomic,copy) NSString   * address;            //地址
@property (nonatomic,strong) NSNumber * createTime;         //创建时间
@property (nonatomic,copy) NSString   * cameraName;         //设备名称
@property (nonatomic,copy) NSString   * cameraPlace;        //创建警员


@end

NS_ASSUME_NONNULL_END

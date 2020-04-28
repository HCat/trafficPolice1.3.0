//
//  ElectronicImageViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/4/27.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ElectronicPoliceAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ElectronicImageViewModel : NSObject


@property (nonatomic,strong) NSNumber * cameraId;
@property (nonatomic,strong) RACCommand * command_image;
@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片




@end

NS_ASSUME_NONNULL_END

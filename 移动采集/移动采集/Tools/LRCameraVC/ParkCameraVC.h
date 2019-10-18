//
//  ParkCameraVC.h
//  移动采集
//
//  Created by hcat on 2019/10/16.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

NS_ASSUME_NONNULL_BEGIN

@class ParkCameraVC;

typedef void (^fininshParkCaptureBlock)(ImageFileInfo * imageInfo);

@interface ParkCameraVC : BaseViewController

//type 1表示为拍照车牌识别模式  2表示正常拍照模式
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString * park_string;

//获取得到的照片转换成需要的imageInfo信息，具体可以查看这个类中拥有的属性
@property (nonatomic,strong) ImageFileInfo *imageInfo;

//拍照完之后调用的block
@property (nonatomic,copy) fininshParkCaptureBlock fininshCaptureBlock;

@end

NS_ASSUME_NONNULL_END

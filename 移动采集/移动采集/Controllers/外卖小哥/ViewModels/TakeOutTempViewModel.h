//
//  TakeOutTempViewModel.h
//  移动采集
//
//  Created by hcat on 2019/7/31.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakeOutAPI.h"
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

@interface TakeOutTempViewModel : NSObject

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片
@property (nonatomic, strong) NSArray < DeliveryIllegalTypeModel *> * deliveryIllegalList; //道路通用值

@property(nonatomic, strong) TakeOutSubmitTempReportParam * param;



@property(nonatomic, assign) BOOL isCanCommit;
@property(nonatomic, assign) NSUInteger count;

@property(nonatomic, strong) RACCommand * command_commit;
@property(nonatomic, strong) RACCommand * command_illegalList;


- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo IsPhotoAlbum:(BOOL)isPhotoAlbum withPHAsset:(PHAsset *)asset;
- (void)configParamInFilesAndRemarksAndTimes;

@end

NS_ASSUME_NONNULL_END

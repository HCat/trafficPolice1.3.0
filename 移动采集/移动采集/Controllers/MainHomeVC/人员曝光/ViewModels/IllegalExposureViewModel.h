//
//  IllegalExposureViewModel.h
//  移动采集
//
//  Created by hcat on 2019/12/5.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ExposureCollectAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalExposureViewModel : NSObject

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片
@property (nonatomic, strong) NSArray < IllegalExposureIllegalTypeModel *> * illegalList; //违法类型


@property(nonatomic, strong) ExposureCollectReportParam * param;

@property(nonatomic, assign) BOOL isCanCommit;
@property(nonatomic, strong) RACCommand * command_commit;
@property(nonatomic, strong) RACCommand * command_illegalList;

@property(nonatomic, strong) id first;
@property(nonatomic, strong) id secend;

- (void)replaceUpImageItemToUpImagesWithImageInfo:(nullable ImageFileInfo * )imageFileInfo remark:(NSString *)remark replaceIndex:(NSInteger)index;

- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark;
- (void)configParamInFilesAndRemarksAndTimes;
- (void)getParkingIdentifyRequest:(ImageFileInfo * )imageInfo;

@end

NS_ASSUME_NONNULL_END

//
//  IllegalAddViewModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/2/15.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IllegalAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalAddViewModel : NSObject

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片

@property(nonatomic, strong) IllegalSaveParam * param;

@property(nonatomic, assign) BOOL isCanCommit;
@property(nonatomic, strong) RACCommand * command_commit;
@property(nonatomic, strong) RACCommand * command_carNoSect;
@property(nonatomic, strong) RACCommand * command_identifyCarNo;

@property(nonatomic, strong) id first;
@property(nonatomic, strong) id secend;

- (void)replaceUpImageItemToUpImagesWithImageInfo:(nullable ImageFileInfo * )imageFileInfo remark:(NSString *)remark replaceIndex:(NSInteger)index;

- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark;
- (void)configParamInFilesAndRemarksAndTimes;
- (void)getParkingIdentifyRequest:(ImageFileInfo * )imageInfo;

#pragma mark  - 存储停止定位位置

- (void)handleBeforeCommit;


@end

NS_ASSUME_NONNULL_END

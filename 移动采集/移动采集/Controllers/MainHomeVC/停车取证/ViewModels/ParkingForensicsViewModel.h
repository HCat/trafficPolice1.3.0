//
//  ParkingForensicsViewModel.h
//  移动采集
//
//  Created by hcat on 2019/7/29.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ParkingForensicsAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface ParkingForensicsViewModel : NSObject

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片

@property (nonatomic, copy) NSString * fkParkplaceId;

@property(nonatomic, strong) ParkingForensicsParam * param;

@property(nonatomic, assign) BOOL isCanCommit;

@property(nonatomic, strong) RACCommand * command_commit;
@property(nonatomic, strong) RACCommand * command_isFirst;


- (void)replaceUpImageItemToUpImagesWithImageInfo:(nullable ImageFileInfo * )imageFileInfo remark:(NSString *)remark replaceIndex:(NSInteger)index;

- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark;
- (void)configParamInFilesAndRemarksAndTimes;

@end

NS_ASSUME_NONNULL_END

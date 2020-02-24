//
//  IllegalSecAddViewModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/2/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IllegalAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalSecAddViewModel : NSObject

@property (nonatomic,strong) NSMutableDictionary *illegal_image;    //第一次采集图片

@property (nonatomic,strong) NSMutableArray * arr_upImages;         //用于存储即将上传的图片

@property (nonatomic,strong) IllegalSecDetailModel * secDetailModel;//第一次提交数据

@property (nonatomic,strong) IllegalSecAddParam * param;

@property(nonatomic, assign) BOOL isCanCommit;
@property(nonatomic, assign) NSUInteger count;

@property(nonatomic, strong) RACCommand * command_load;             //加载一次数据
@property(nonatomic, strong) RACCommand * command_add;              //上传二次采集数据

- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo;
- (void)configParamInFilesAndRemarksAndTimes;

@end

NS_ASSUME_NONNULL_END

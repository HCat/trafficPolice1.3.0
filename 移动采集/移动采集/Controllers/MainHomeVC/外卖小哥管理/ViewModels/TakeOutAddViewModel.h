//
//  TakeOutAddViewModel.h
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TakeOutAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface TakeOutAddViewModel : NSObject

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片
@property (nonatomic, strong) NSArray < DeliveryIllegalTypeModel *> * deliveryIllegalList; //道路通用值

@property (nonatomic, copy) NSString * deliveryId;

@property(nonatomic, strong) TakeOutSaveParam * param;

@property(nonatomic, assign) BOOL isCanCommit;

@property(nonatomic, strong) RACCommand * command_commit;
@property(nonatomic, strong) RACCommand * command_illegalList;
@property(nonatomic, strong) RACCommand * command_companyList;

- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo;
- (void)configParamInFilesAndRemarksAndTimes;

@end

NS_ASSUME_NONNULL_END

//
//  IllegalParkForJJViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/22.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "IllegalParkAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalParkForJJViewModel : BaseViewModel

@property (nonatomic,strong) NSMutableArray *arr_upImages; //用于存储即将上传的图片

@property (nonatomic, strong) IllegalParkSaveParam * param;

@property(nonatomic, assign) BOOL isCanCommit;
@property(nonatomic, strong) RACCommand * command_commit;
@property(nonatomic, strong) RACCommand * command_illegalRecord;    //判断违停是否拥有违停记录
@property(nonatomic, strong) RACCommand * command_identifyCarNo;    //识别车牌号码

@property(nonatomic, strong) id first;
@property(nonatomic, strong) id secend;

@property (strong, nonatomic) NSArray * codes;


//通过所在路段的名字获取得到roadId
- (void)getRoadId;

- (void)replaceUpImageItemToUpImagesWithImageInfo:(nullable ImageFileInfo * )imageFileInfo remark:(NSString *)remark replaceIndex:(NSInteger)index;

- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark;

- (void)configParamInFilesAndRemarksAndTimes;


#pragma mark  - 提交之后的操作

- (void)handleBeforeCommit;




@end

NS_ASSUME_NONNULL_END

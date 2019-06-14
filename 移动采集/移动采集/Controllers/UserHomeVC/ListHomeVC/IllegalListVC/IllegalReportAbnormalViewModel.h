//
//  IllegalReportAbnormalViewModel.h
//  移动采集
//
//  Created by hcat on 2019/6/14.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ImageFileInfo.h"
#import "IllegalParkAPI.h"
#import "IllegalCollectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalReportAbnormalViewModel : NSObject

@property (nonatomic,strong) IllegalCollectModel * illegalCollect; //事故对象
@property (strong, nonatomic, nullable) ImageFileInfo * userPhoto;
@property (strong, nonatomic) IllegalReportAbnormalParam * param;

@property (strong, nonatomic) RACSubject * subject;

@property (strong, nonatomic) RACCommand * command_up;

@end

NS_ASSUME_NONNULL_END

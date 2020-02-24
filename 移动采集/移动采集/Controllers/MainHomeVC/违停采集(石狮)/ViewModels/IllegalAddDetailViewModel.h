//
//  IllegalAddDetailViewModel.h
//  移动采集
//
//  Created by hcat-89 on 2020/2/20.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IllegalParkDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalAddDetailViewModel : NSObject

@property (nonatomic,strong) NSNumber *illegalId;

@property (nonatomic,strong,nullable) IllegalParkDetailModel *model;

@property (nonatomic,strong) RACCommand * command_detail;


@end

NS_ASSUME_NONNULL_END

//
//  ExpressRegulationViewModel.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewModel.h"
#import "ExpressRegulationAPIS.h"

NS_ASSUME_NONNULL_BEGIN

@interface ExpressRegulationViewModel : BaseViewModel

@property (nonatomic, strong) NSMutableArray * arr_content;
@property(strong, nonatomic) NSNumber * start;          //分页第几页
@property (nonatomic,strong) RACCommand * requestCommand;
@property (nonatomic,copy)   NSString * searchName;
@property (nonatomic,strong) NSNumber * searchType;

@end

NS_ASSUME_NONNULL_END

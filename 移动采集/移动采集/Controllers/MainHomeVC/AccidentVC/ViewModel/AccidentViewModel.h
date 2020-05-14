//
//  AccidentViewModel.h
//  移动采集
//
//  Created by hcat on 2018/10/19.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AccidentUpListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface AccidentViewModel : NSObject

@property (nonatomic,strong) NSMutableArray * arr_item; //segmented中显示的内容
@property(nonatomic,assign)  AccidentType accidentType;
@property (nonatomic,strong) AccidentUpListViewModel * listViewModel;
@property (nonatomic,strong) NSNumber * illegalCount;   //未上传事故或快处记录数量
@property (nonatomic,assign) UpCacheType cacheType;

@end

NS_ASSUME_NONNULL_END

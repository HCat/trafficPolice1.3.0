//
//  IllegalParkManageViewModel.h
//  移动采集
//
//  Created by hcat on 2018/9/26.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IllegalParkUpListViewModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface IllegalParkManageViewModel : NSObject

@property (nonatomic,strong) NSMutableArray * arr_item; //segmented中显示的内容
@property (nonatomic,assign) IllegalType illegalType; //违法类型
@property (nonatomic,assign) ParkType subType;  //如果是违停的状况，则又分为3种状态，选填，默认1:违停，1001:朝向错误，1002:锁车，2001:信息录入
@property (nonatomic,strong) NSNumber * illegalCount;   //未上传违章记录数量
@property (nonatomic,strong) IllegalParkUpListViewModel * listViewModel;

@end

NS_ASSUME_NONNULL_END

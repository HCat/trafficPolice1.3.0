//
//  IllegalParkUpListViewModel.h
//  移动采集
//
//  Created by hcat on 2018/9/30.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IllegalDBModel.h"


NS_ASSUME_NONNULL_BEGIN

@interface IllegalUpListCellViewModel: NSObject

@property(nonatomic,strong) NSNumber *illegalId;
@property(nonatomic,copy) NSString * carNumber;
@property(nonatomic,strong) NSNumber * time;
@property(nonatomic,copy) NSString * address;
@property(nonatomic,assign) BOOL isAbnormal; //是否异常
@property(nonatomic,assign) CGFloat progress;

@end


@interface IllegalParkUpListViewModel : NSObject

@property (nonatomic,strong) NSMutableArray * arr_illegal;
@property (nonatomic,strong) NSNumber * illegalCount;   
@property (nonatomic,assign) IllegalType illegalType; //违法类型
@property (nonatomic,assign) ParkType subType;  //如果是违停的状况，则又分为3种状态，选填，默认1:违停，1001:朝向错误，1002:锁车，2001:信息
@property (nonatomic,strong) NSMutableArray<IllegalUpListCellViewModel *> * arr_viewModel;
@property (nonatomic,strong) RACSubject * rac_addCache;
@property (nonatomic,strong) RACSubject * rac_deleteCache;
@property (nonatomic,assign) BOOL isUping;
@property (nonatomic,assign) BOOL isAutoUp;


@end

NS_ASSUME_NONNULL_END

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

@property(nonatomic,copy) NSString * carNumber;
@property(nonatomic,strong) NSNumber * time;
@property(nonatomic,copy) NSString * address;
@property(nonatomic,assign) BOOL isAbnormal; //是否异常

@end


@interface IllegalParkUpListViewModel : NSObject

@property (nonatomic,strong) NSMutableArray * arr_illegal;
@property (nonatomic,strong) NSNumber * illegalCount;
@property (nonatomic,strong) NSMutableArray<IllegalUpListCellViewModel *> * arr_viewModel;
@property (nonatomic,strong) RACSubject *racSubject;

@end

NS_ASSUME_NONNULL_END

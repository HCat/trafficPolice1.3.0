//
//  AccidentUpListViewModel.h
//  移动采集
//
//  Created by hcat on 2018/10/19.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@interface AccidentUpListCellViewModel: NSObject

@property(nonatomic,strong) NSNumber *accidentId;
@property(nonatomic,copy) NSString * carNumber;
@property(nonatomic,strong) NSNumber * time;
@property(nonatomic,copy) NSString * address;
@property(nonatomic,assign) CGFloat progress;

@end


@interface AccidentUpListViewModel : NSObject

@property (nonatomic,strong) NSMutableArray * arr_accident;         //AccidentDBModel.h
@property (nonatomic,strong) NSNumber * illegalCount;
@property (nonatomic,assign) AccidentType accidentType; //事故类型
@property (nonatomic,strong) NSMutableArray<AccidentUpListCellViewModel *> * arr_viewModel;
@property (nonatomic,strong) RACSubject * rac_addCache;
@property (nonatomic,strong) RACSubject * rac_deleteCache;
@property (nonatomic,assign) BOOL isUping;
@property (nonatomic,assign) BOOL isAutoUp;


@end

NS_ASSUME_NONNULL_END

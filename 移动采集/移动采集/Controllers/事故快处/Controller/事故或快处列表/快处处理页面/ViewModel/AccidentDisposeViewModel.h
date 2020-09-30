//
//  AccidentDisposeViewModel.h
//  移动采集
//
//  Created by hcat on 2019/8/30.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FastAccidentAPI.h"

NS_ASSUME_NONNULL_BEGIN


@interface AccidentDisposeViewModel : NSObject

@property (nonatomic,strong) NSNumber *accidentId;        //事故ID
@property (nonatomic,strong) NSMutableArray * arr_count;    
@property (nonatomic,strong) FastAccidentDealAccidentParam * param;

@property (nonatomic,strong) RACCommand * command_people;
@property (nonatomic,strong) RACCommand * command_dealAccident;

@end

NS_ASSUME_NONNULL_END

//
//  AttendanceSignInViewModel.h
//  移动采集
//
//  Created by hcat on 2019/4/4.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PoliceDistributeAPI.h"

NS_ASSUME_NONNULL_BEGIN

@interface AttendanceSignInViewModel : NSObject

@property (nonatomic, strong) PoliceAnalyzeModel * policemodel; //

@property (nonatomic, strong) NSMutableArray * arr_signIn;  //分组数组
@property (nonatomic, strong) RACCommand * command_signIn;  //签到请求
@property (nonatomic, strong) NSNumber * count_signIn;      //分组数组数目


@end



NS_ASSUME_NONNULL_END

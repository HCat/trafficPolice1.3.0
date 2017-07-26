//
//  LRBaseRequest.h
//  trafficPolice
//
//  Created by hcat on 2017/5/18.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "LRBaseResponse.h"
#import "YTKUrlArgumentsFilter.h"


@interface LRBaseRequest : YTKRequest

@property (nonatomic,strong) LRBaseResponse *responseModel;

@property (nonatomic,assign) BOOL isLog;                //用来打印具体返回的数据    默认是YES
@property (nonatomic,assign) BOOL isNeedShowHud;        //是否需要提示信息, 默认是YES
@property (nonatomic,strong) UIView *v_showHud;         //用于提示框加载到对应的视图上面

@property (nonatomic,assign) BOOL isNeedLoadHud;        //是否需要加载HUD
@property (nonatomic,copy) NSString *loadingMessage;    //加载的信息
@property (nonatomic,copy) NSString *successMessage;    //成功的提示信息
@property (nonatomic,copy) NSString *failMessage;       //失败的提示信息

//全局为统一的Url添加参数。比如添加token，或者version
+ (void)setupRequestFilters:(NSDictionary *)arguments;
+ (void)clearRequestFilters;

@end

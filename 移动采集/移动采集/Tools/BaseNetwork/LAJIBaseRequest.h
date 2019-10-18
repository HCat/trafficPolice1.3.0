//
//  LAJIBaseRequest.h
//  移动采集
//
//  Created by hcat on 2019/9/27.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "LRBaseResponse.h"
#import "YTKUrlArgumentsFilter.h"

NS_ASSUME_NONNULL_BEGIN

@interface LAJIBaseRequest : YTKRequest

@property (nonatomic,strong) LRBaseResponse *responseModel;

@property (nonatomic,assign) BOOL isLog;                    //用来打印具体返回的数据    默认是YES

@property (nonatomic,strong) UIView *v_showHud;             //用于提示框加载到对应的视图上面
@property (nonatomic,assign) BOOL isNeedLoadHud;            //是否需要加载HUD, 默认是NO
@property (nonatomic,assign) BOOL isNeedShowHud;            //是否需要提示信息, 默认是NO
@property (nonatomic,copy)   NSString *loadingMessage;      //加载的信息
@property (nonatomic,copy)   NSString *successMessage;      //成功的提示信息
@property (nonatomic,copy)   NSString *failMessage;         //失败的提示信息 //这个是服务器返回的错误码
@property (nonatomic,assign) BOOL isNoShowFail;           //是否显示网络报错信息。默认是NO表明显示



//全局为统一的Url添加参数。比如添加token，或者version
+ (void)setupRequestFilters:(NSDictionary *)arguments;
+ (void)clearRequestFilters;

//方便配置提示信息
- (void)configLoadingTitle:(NSString *)title;

@end

NS_ASSUME_NONNULL_END

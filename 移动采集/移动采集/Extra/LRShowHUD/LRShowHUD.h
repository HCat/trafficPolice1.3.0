//
//  LRShowHUD.h
//
//  Created by hcat-89 on 2017/6/15.
//  Copyright © 2017年 hcat-89. All rights reserved.
//
//----------------------------------------------------------------------------------
//  1、基于 MBProgressHUD 最新版本封装（支持横竖屏）
//    当前扩展的 GitHub 地址：https://github.com/HCat/LRShowHUD
//  2、当前版本：1.0.0
//  3、如果在使用过程中有问题或者建议可以随时联系我：375348234@qq.com 或者 GitHub issue
//
//  4、更新日志：

//----------------------------------------------------------------------------------

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@class LRShowHUD;

/* 配置MBProgressHUD中的参数.主要是基本属性.包括字体大小，颜色以及其他配置选项 */
typedef void(^ConfigShowHUDBlock)(LRShowHUD * _Nullable showhud);

/* 配置自定义视图，视图赋值给MBProgressHUD.customView属性 */
typedef UIView * _Nullable (^ConfigShowHUDCustomViewBlock)();


@interface LRShowHUD : NSObject

@property(nonatomic,strong,nonnull,readonly) MBProgressHUD *hud;

#pragma mark - 显示纯文本信息
/**
 显示纯文本信息的HUD,并且在几秒之后消失,展示在keyWindow层上
 
 @param text        提示信息
 @param duration    持续多久时间之后隐藏
 */

+ (void)showTextOnly:(nonnull NSString *)text
            duration:(NSTimeInterval)duration;


/**
 显示纯文本信息的HUD,并且在几秒之后消失,已经进行默认配置，如果需要特殊配置，请用
 + (void)showTextOnly:(NSString *)text
             duration:(NSTimeInterval)duration
               inView:(UIView *)view
               config:(ConfigShowHUDBlock)config;

 @param text        提示信息
 @param duration    持续多久时间之后隐藏
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 */

+ (void)showTextOnly:(nonnull NSString *)text
            duration:(NSTimeInterval)duration
              inView:(nullable UIView *)view;



/**
 显示纯文本信息的HUD，并且在几秒之后消失
 
 @param text        提示信息
 @param duration    持续多久时间之后隐藏
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 @param config      MBProgressHUD的属性配置，默认在LRShowHUD.m中有进行配置，如果需要另外配置则在block中进行配置
 */

+ (void)showTextOnly:(nonnull NSString *)text
            duration:(NSTimeInterval)duration
              inView:(nullable UIView *)view
              config:(nullable ConfigShowHUDBlock)config;



/**
 初始化纯文本信息的HUD，返回LRShowHUD, 不会自动消失，需要在你需要移除的时候调用 hideAnimated: 等移除方法
 
 @param text        提示信息
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 @param config      MBProgressHUD的属性配置，默认在LRShowHUD.m中有进行配置，如果需要另外配置则在block中进行配置
 */
+ (nonnull instancetype)showTextOnly:(nonnull NSString *)text
                      inView:(nullable UIView *)view
                      config:(nullable ConfigShowHUDBlock)config;

#pragma mark - 显示菊花加载的HUD

/**
 显示带菊花提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 */
+ (void)showActivityLoading:(nullable NSString *)text
                   duration:(NSTimeInterval)duration;



/**
 显示带菊花提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 */
+ (void)showActivityLoading:(nullable NSString *)text
                   duration:(NSTimeInterval)duration
                     inView:(nullable UIView *)view;



/**
 显示带菊花提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 @param config      MBProgressHUD的属性配置，默认在LRShowHUD.m中有进行配置，如果需要另外配置则在block中进行配置
 */
+ (void)showActivityLoading:(nullable NSString *)text
                   duration:(NSTimeInterval)duration
                     inView:(nullable UIView *)view
                     config:(nullable ConfigShowHUDBlock)config;




/**
初始化纯文本信息的HUD，返回LRShowHUD, 不会自动消失，需要在你需要移除的时候调用 hideAnimated: 等移除方法

@param text        提示信息
@param view        展示的View 如果传nil，则展示在keyWindow层上
@param config      MBProgressHUD的属性配置，默认在LRShowHUD.m中有进行配置，如果需要另外配置则在block中进行配置
*/
+ (nonnull instancetype)showActivityLoading:(nullable NSString *)text
                                     inView:(nullable UIView *)view
                                     config:(nullable ConfigShowHUDBlock)config;


#pragma mark - 显示加载进度的HUD





#pragma mark - 显示错误的HUD

/**
 显示错误提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 */
+ (void)showError:(nullable NSString *)text
                   duration:(NSTimeInterval)duration;



/**
 显示错误提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 */
+ (void)showError:(nullable NSString *)text
                   duration:(NSTimeInterval)duration
                     inView:(nullable UIView *)view;



/**
 显示错误提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 @param config      MBProgressHUD的属性配置，默认在LRShowHUD.m中有进行配置，如果需要另外配置则在block中进行配置
 */
+ (void)showError:(nullable NSString *)text
                   duration:(NSTimeInterval)duration
                     inView:(nullable UIView *)view
                     config:(nullable ConfigShowHUDBlock)config;


#pragma mark - 显示成功的HUD

/**
 显示成功提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 */
+ (void)showSuccess:(nullable NSString *)text
         duration:(NSTimeInterval)duration;



/**
 显示成功提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 */
+ (void)showSuccess:(nullable NSString *)text
         duration:(NSTimeInterval)duration
           inView:(nullable UIView *)view;



/**
 显示成功提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 @param config      MBProgressHUD的属性配置，默认在LRShowHUD.m中有进行配置，如果需要另外配置则在block中进行配置
 */
+ (void)showSuccess:(nullable NSString *)text
         duration:(NSTimeInterval)duration
           inView:(nullable UIView *)view
           config:(nullable ConfigShowHUDBlock)config;


#pragma mark - 显示警告的HUD

/**
 显示警告提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 */
+ (void)showWarning:(nullable NSString *)text
           duration:(NSTimeInterval)duration;



/**
 显示警告提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 */
+ (void)showWarning:(nullable NSString *)text
           duration:(NSTimeInterval)duration
             inView:(nullable UIView *)view;



/**
 显示警告提示信息的HUD，并且在几秒之后消失
 
 @param text        提示信息 备注:text可为空，如果为空则只显示菊花加载
 @param duration    持续多久时间之后隐藏
 @param view        展示的View 如果传nil，则展示在keyWindow层上
 @param config      MBProgressHUD的属性配置，默认在LRShowHUD.m中有进行配置，如果需要另外配置则在block中进行配置
 */
+ (void)showWarning:(nullable NSString *)text
           duration:(NSTimeInterval)duration
             inView:(nullable UIView *)view
             config:(nullable ConfigShowHUDBlock)config;


#pragma mark - 隐藏

/**
 隐藏MBProgressHUD,默认动画隐藏
 */
- (void)hide;

/**
 隐藏MBProgressHUD
 
 @param isNeedAnimated        是否需要动画
 */
- (void)hideAnimated:(BOOL)isNeedAnimated;


/**
 延迟隐藏MBProgressHUD
 
 @param isNeedAnimated        是否需要动画
 @param delay                 延迟时间
 */
- (void)hideAnimated:(BOOL)isNeedAnimated afterDelay:(NSTimeInterval)delay;


@end

//
//  LRSettingItemModel.h
//  移动采集
//
//  Created by hcat on 2017/7/24.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, LRSettingAccessoryType) {
    LRSettingAccessoryTypeNone,                   // don't show any accessory view
    LRSettingAccessoryTypeDisclosureIndicator,    // the same with system DisclosureIndicator
    LRSettingAccessoryTypeSwitch,                 //  swithch
};



@interface XBSettingItemModel : NSObject
@property (nonatomic,copy)   NSString  *funcName;     /**<      功能名称*/
@property (nonatomic,strong) UIImage *img;            /**< 功能图片  */
@property (nonatomic,copy)   NSString *detailText;    /**< 更多信息-提示文字  */
@property (nonatomic,strong) UIImage *detailImage;    /**< 更多信息-提示图片  */


@property (nonatomic,assign) LRSettingAccessoryType  accessoryType;    /**< accessory */
@property (nonatomic,copy) void (^executeCode)();     /**<      点击item要执行的代码*/
@property (nonatomic,copy) void (^switchValueChanged)(BOOL isOn); /**<  XBSettingAccessoryTypeSwitch下开关变化 */

@end

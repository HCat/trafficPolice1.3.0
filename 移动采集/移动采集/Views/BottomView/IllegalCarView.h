//
//  IllegalCarView.h
//  移动采集
//
//  Created by hcat on 2018/6/25.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SuperviseBlock)(void);
typedef void(^ExemptCarBlock)(void);

@interface IllegalCarView : UIView

@property (nonatomic, copy) SuperviseBlock superviseBlock; //点击身份证事件
@property (nonatomic, copy) ExemptCarBlock exemptCarBlock; //点击驾驶证事件

+ (IllegalCarView *)initCustomView;

@end

//
//  SurePlaceholderView.h
//  AppPlaceholder
//
//  Created by 刘硕 on 2016/11/30.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LRPlaceholderView : UIView

@property (nonatomic, copy) void(^reloadClickBlock)(void);
@property (nonatomic, assign) BOOL isNetvailable;
@property (nonatomic, copy) NSString *str_placeholder;
@end

//
//  PolicePerformView.h
//  移动采集
//
//  Created by hcat on 2018/11/20.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^EditBlock)(void);


@interface PolicePerformView : UIView

@property (nonatomic, copy) NSString * name_string;
@property (nonatomic, copy) EditBlock editBlock;

+ (PolicePerformView *)initCustomView;


- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END

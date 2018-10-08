//
//  IllegalNetErrorView.h
//  移动采集
//
//  Created by hcat on 2018/9/29.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^SaveBlock)(void);
typedef void(^UpBlock)(void);


@interface IllegalNetErrorView : UIView

@property (weak, nonatomic) IBOutlet UIButton *btn_save;
@property (weak, nonatomic) IBOutlet UIButton *btn_up;

@property (nonatomic,copy) SaveBlock saveBlock;
@property (nonatomic,copy) UpBlock upBlock;

+ (IllegalNetErrorView *)initCustomView;

- (void)show;

- (void)hide;

@end

NS_ASSUME_NONNULL_END

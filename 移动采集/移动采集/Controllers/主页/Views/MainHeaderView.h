//
//  MainHeaderView.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MainHeaderView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lb_zhongdui;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;
@property (weak, nonatomic) IBOutlet UILabel *lb_phone;
@property (weak, nonatomic) IBOutlet UIImageView *imageV_user;
@property (weak, nonatomic) IBOutlet UIButton *btn_userInfo;


+ (MainHeaderView *)initCustomView;
- (void)scrollViewDidScroll:(CGFloat)contentOffsetY;
- (void)scrollViewWillBeginDragging:(CGFloat)contentOffsetY;

@end

NS_ASSUME_NONNULL_END

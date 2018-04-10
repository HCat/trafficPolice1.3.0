//
//  PoliceCarDetailView.h
//  移动采集
//
//  Created by hcat on 2018/4/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoliceCarDetailView : UIView

@property (nonatomic,copy) NSString *policeCarName;

+ (PoliceCarDetailView *)initCustomView;

- (void)dismiss;


@end

//
//  PoliceDetailView.h
//  移动采集
//
//  Created by hcat-89 on 2017/9/15.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PoliceDetailView : UIView

@property (nonatomic,copy) NSString *policeName;
@property (nonatomic,copy) NSString *policeGroup;


+ (PoliceDetailView *)initCustomView;

- (void)dismiss;
@end

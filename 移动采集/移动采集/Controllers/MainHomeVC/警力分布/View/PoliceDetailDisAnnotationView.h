//
//  PoliceDetailDisAnnotationView.h
//  移动采集
//
//  Created by hcat on 2018/11/19.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PoliceDetailDisAnnotationView : UIView

@property (weak, nonatomic) IBOutlet UILabel *lb_policeGroup;
@property (weak, nonatomic) IBOutlet UILabel *lb_policeInstitution;
@property (weak, nonatomic) IBOutlet UILabel *lb_name;


+ (PoliceDetailDisAnnotationView *)initCustomView;


@end

NS_ASSUME_NONNULL_END

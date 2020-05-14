//
//  CertificateView.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/17.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^IdentityCardBlock)(void);
typedef void(^DrivingLicenceBlock)(void);

@interface CertificateView : UIView

@property (nonatomic, copy) IdentityCardBlock identityCardBlock; //点击身份证事件
@property (nonatomic, copy) DrivingLicenceBlock drivingLicenceBlock; //点击驾驶证事件

+ (CertificateView *)initCustomView;

@end

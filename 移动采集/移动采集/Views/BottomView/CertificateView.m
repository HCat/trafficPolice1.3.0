//
//  CertificateView.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/5/17.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "CertificateView.h"

@implementation CertificateView

+ (CertificateView *)initCustomView{
    
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"CertificateView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (IBAction)handleBtnIdentityCardClick:(id)sender {
    if (self.identityCardBlock) {
        self.identityCardBlock();
    }
    
}

- (IBAction)handleBtnDrivingLicenceClick:(id)sender {
    if (self.drivingLicenceBlock) {
        self.drivingLicenceBlock();
    }
    
}


@end

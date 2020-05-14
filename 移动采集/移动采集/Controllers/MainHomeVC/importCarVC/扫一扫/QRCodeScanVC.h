//
//  QRCodeScanVC.h
//  移动采集
//
//  Created by hcat on 2017/9/6.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "HideTabSuperVC.h"

typedef void(^QRCodeScanSuccessBlock)(NSString * str_code);

@interface QRCodeScanVC : HideTabSuperVC

@property(nonatomic,copy) QRCodeScanSuccessBlock block;

@end

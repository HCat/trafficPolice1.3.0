//
//  PhoneLoginVC.h
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface CodeCell : UICollectionViewCell

@property (nonatomic,strong) UILabel *lb_number;

@end

@interface PhoneLoginVC : HideTabSuperVC

@property (nonatomic,copy) NSString *phone;

@end

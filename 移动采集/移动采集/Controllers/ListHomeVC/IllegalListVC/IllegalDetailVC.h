//
//  IllegalDetailVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"

@interface IllegalDetailVC : HideTabSuperVC

@property (nonatomic,strong) NSNumber *illegalId;
@property (nonatomic,assign) IllegalType illegalType;

@end

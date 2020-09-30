//
//  IllegalSecSaveVC.h
//  trafficPolice
//
//  Created by hcat on 2017/6/5.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HideTabSuperVC.h"

typedef void(^IllegalSecSaveSuccessBlock)();

@interface IllegalSecSaveVC : HideTabSuperVC

@property (nonatomic,strong) NSNumber * illegalThroughId;
@property (nonatomic,assign) int type;          // 2为闯禁令管理二次采集页面
@property (nonatomic,strong) NSMutableDictionary *illegal_image;
@property (nonatomic,copy)IllegalSecSaveSuccessBlock saveSuccessBlock;


@end

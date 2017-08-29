//
//  VideoDetailVC.h
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "HideTabSuperVC.h"
#import "NJKWebViewProgress.h"

@interface VideoDetailVC : HideTabSuperVC<UIWebViewDelegate, NJKWebViewProgressDelegate>

@property (nonatomic,copy) NSString *path;

@end

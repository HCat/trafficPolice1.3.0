//
//  WebVC.h
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/20.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "BaseViewController.h"
#import <WebKit/WebKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WebVC : BaseViewController

@property (nonatomic, copy) NSString * path;
@property (nonatomic, strong) WKWebView *webView;


@end

NS_ASSUME_NONNULL_END

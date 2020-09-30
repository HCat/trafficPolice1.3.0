//
//  WebVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/8/20.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "WebVC.h"

@interface WebVC ()

@end

@implementation WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)lr_configUI{
    
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];
    WKUserContentController *userContentController = [[WKUserContentController alloc] init];
        
    configuration.userContentController = userContentController;
         
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.scrollView.bouncesZoom = YES;
    self.webView.scrollView.bounces = NO;
    self.webView.scrollView.scrollEnabled = YES;
    [self.view addSubview:self.webView];
         
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(Height_NavBar);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    NSString *encodedString = [self.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [self.webView loadRequest:request];
    
}

@end

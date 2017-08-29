//
//  VideoDetailVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "VideoDetailVC.h"
#import "NJKWebViewProgressView.h"

@interface VideoDetailVC (){

    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}

@property (weak, nonatomic) IBOutlet UIWebView *webView;


@end

@implementation VideoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频详情";
    
    _progressProxy = [[NJKWebViewProgress alloc] init];
    _webView.delegate = _progressProxy;
    _progressProxy.webViewProxyDelegate = self;
    _progressProxy.progressDelegate = self;
    
    CGFloat progressBarHeight = 2.f;
    CGRect navigationBarBounds = self.navigationController.navigationBar.bounds;
    CGRect barFrame = CGRectMake(0, navigationBarBounds.size.height - progressBarHeight, navigationBarBounds.size.width, progressBarHeight);
    _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
    _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    
    NSURL* url = [NSURL URLWithString:_path];//创建URL
    NSURLRequest* request = [NSURLRequest requestWithURL:url];//创建NSURLRequest
    [_webView loadRequest:request];//加载
    _webView.backgroundColor = [UIColor clearColor];
    [_webView setOpaque:NO];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
    
}


#pragma mark -dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    LxPrintf(@"VideoDetailVC dealloc");

}

@end

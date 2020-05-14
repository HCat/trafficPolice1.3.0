//
//  VideoDetailVC.m
//  trafficPolice
//
//  Created by hcat-89 on 2017/6/7.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "VideoDetailVC.h"


@interface VideoDetailVC ()

@property (nonatomic, strong) WKWebView *webView;
@property (nonatomic, strong) UIProgressView *progressView;


@end

@implementation VideoDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"视频详情";
    
    //初始化页面
    WKWebViewConfiguration *configuration = [[WKWebViewConfiguration alloc] init];

    //设置为YES即可
    configuration.allowsInlineMediaPlayback = YES;
    WKPreferences *preferences = [WKPreferences new];
    preferences.javaScriptCanOpenWindowsAutomatically = YES;
    configuration.preferences = preferences;
    
    self.webView = [[WKWebView alloc] initWithFrame:self.view.frame configuration:configuration];
    self.webView.scrollView.showsHorizontalScrollIndicator = NO;
    self.webView.UIDelegate = self;
    [self.webView setNavigationDelegate:self];
    [self.view addSubview:self.webView];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.top.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
    }];
    
    //进度条
    self.progressView = [[UIProgressView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 0.8)];
    self.progressView.progressTintColor = UIColorFromRGB(0xFE423F);
    //设置进度条的高度，下面这句代码表示进度条的宽度变为原来的1倍，高度变为原来的1.5倍.
    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.5f);
    [self.webView addSubview:self.progressView];
    [self.webView addObserver:self
                   forKeyPath:@"estimatedProgress"
                      options:NSKeyValueObservingOptionNew
                      context:nil];
       
    NSString *encodedString = [self.path stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSURL* url = [NSURL URLWithString:encodedString];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:20];
    [self.webView loadRequest:request];
   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
   
}

#pragma mark- XXXXXXXXXXXXXXXKVO监听XXXXXXXXXXXXXXXXXXXX

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([self.progressView isDescendantOfView:self.webView]) {
        if ([keyPath isEqualToString:@"estimatedProgress"]) {
            self.progressView.progress = self.webView.estimatedProgress;
            if (self.progressView.progress == 1) {
                /*
                 *添加一个简单的动画，将progressView的Height变为1.4倍，在开始加载网页的代理中会恢复为1.5倍
                 *动画时长0.25s，延时0.3s后开始动画
                 *动画结束后将progressView隐藏
                 */
                
                @weakify(self);
                [UIView animateWithDuration:0.25f delay:0.3f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    @strongify(self);
                    self.progressView.transform = CGAffineTransformMakeScale(1.0f, 1.4f);
                } completion:^(BOOL finished) {
                    self.progressView.hidden = YES;
                    
                }];
            }
        }else{
            
            //[super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
        }
    }
    
    if ([keyPath isEqualToString:@"URL"]) {
        NSLog(@"url == %@",self.webView.URL.absoluteString);
    }
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

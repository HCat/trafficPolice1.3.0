//
//  BaseViewController.m
//  trafficPolice
//
//  Created by Binrong Liu on 2017/5/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "BaseViewController.h"
#import <JANALYTICSService.h>

@interface BaseViewController ()

@end

@implementation BaseViewController

+ (instancetype)alloc{
    
    BaseViewController *viewController = [super alloc];
    
    @weakify(viewController)
    
    [[viewController rac_signalForSelector:@selector(viewDidLoad)] subscribeNext:^(id x) {
        
        @strongify(viewController)
        [viewController lr_configUI];
        [viewController lr_bindViewModel];
    }];
    
    [[viewController rac_signalForSelector:@selector(viewWillAppear:)] subscribeNext:^(id x) {
        
        //@strongify(viewController)
        
        
    }];
    
    return viewController;
}

- (instancetype)init{
    
    if (self = [super init]) {
        
        
    }
    
    return self;
}




- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = DefaultBGColor;
    self.zx_navStatusBarStyle = ZXNavStatusBarStyleDefault;
    self.zx_navLineView.hidden = YES;
    [self.zx_navBar setBackgroundColor:DefaultNavColor];
    self.zx_navTintColor = UIColorFromRGB(0xffffff);
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    if (@available(iOS 11.0, *)) {
        
    } else {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    NSLog(@"%@",[NSString stringWithUTF8String:object_getClassName(self)]);
    [JANALYTICSService startLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    
    
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [JANALYTICSService stopLogPageView:[NSString stringWithUTF8String:object_getClassName(self)]];
    
}

#pragma mark - RAC
/**
 *  添加控件
 */
- (void)lr_configUI{
    
    
    
}

/**
 *  绑定
 */
- (void)lr_bindViewModel{
    
    
    
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
   
    NSLog(@"%@-dealloc",[self class]);

}


@end

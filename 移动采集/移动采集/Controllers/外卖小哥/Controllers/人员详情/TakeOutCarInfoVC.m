//
//  TakeOutCarInfoVC.m
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutCarInfoVC.h"
#import <UIImageView+WebCache.h>
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

@interface TakeOutCarInfoVC ()

@property(nonatomic, strong) TakeOutCarInfoViewModel * viewModel;


@property (weak, nonatomic) IBOutlet UILabel *lb_plateNo;     //车牌号
@property (weak, nonatomic) IBOutlet UILabel *lb_color;       //车身颜色
@property (weak, nonatomic) IBOutlet UILabel *lb_brandModel;  //厂牌型号
@property (weak, nonatomic) IBOutlet UILabel *lb_frameNo;     //车架号
@property (weak, nonatomic) IBOutlet UILabel *lb_vehicleType; //车辆类型
@property (weak, nonatomic) IBOutlet UIImageView *imageV_picUrl;      //车身照片

@property (weak, nonatomic) IBOutlet UIButton *btn_show;


@end

@implementation TakeOutCarInfoVC

- (instancetype)initWithViewModel:(TakeOutCarInfoViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    @weakify(self);
    [RACObserve(self.viewModel, model) subscribeNext:^(DeliveryVehicleModel * _Nullable x) {
        @strongify(self);
        if (x) {
            
            self.lb_plateNo.text = x.plateNo;     //车牌号
            self.lb_color.text = x.color;       //车身颜色
            self.lb_brandModel.text = x.brandModel;  //厂牌型号
            self.lb_frameNo.text = x.frameNo;     //车架号
            self.lb_vehicleType.text = x.vehicleType; //车辆类型
            [self.imageV_picUrl sd_setImageWithURL:[NSURL URLWithString:x.picUrl] placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];;      //车身照片

        }
        
    }];
    
    
    [[self.btn_show rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        //将arr_upImages中有图片的赋值到t_arr中用于LLPhotoBrowser中
        
        NSMutableArray *t_arr = [NSMutableArray array];
        
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:self.imageV_picUrl imageUrl:[NSURL URLWithString:self.viewModel.model.picUrl]];
        [t_arr addObject:item];
        
        KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:0];
        [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
        [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
        browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
        browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces             = NO;
        browser.isShowDeleteBtn     = NO;
        [browser showFromViewController:self];
        
        
    }];
    
    
    
    [self.viewModel.requestCommand execute:nil];
    
    
}

- (void)configUI{
    self.title = @"车辆详情";

}

- (void)dealloc{
    LxPrintf(@"TakeOutCarInfoVC dealloc");
}

@end

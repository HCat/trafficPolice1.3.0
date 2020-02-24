//
//  IllegalReportAbnormalVC.m
//  移动采集
//
//  Created by hcat on 2019/6/14.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "IllegalReportAbnormalVC.h"

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import "LRCameraVC.h"

@interface IllegalReportAbnormalVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_upPhoto;

@property (weak, nonatomic) IBOutlet UIButton *btn_delete;

@property (weak, nonatomic) IBOutlet UIButton *btn_up_info;


@property (strong, nonatomic) IllegalReportAbnormalViewModel * viewModel;

@end

@implementation IllegalReportAbnormalVC

- (instancetype)initWithViewModel:(IllegalReportAbnormalViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    @weakify(self);
    
    [RACObserve(self.viewModel, userPhoto) subscribeNext:^(ImageFileInfo *  _Nullable x) {
        @strongify(self);
        if (x) {
            
            [self.btn_upPhoto setImage:x.image forState:UIControlStateNormal];
            self.btn_delete.hidden = NO;
            self.btn_delete.enabled = YES;
        }else{
            [self.btn_upPhoto setImage:[UIImage imageNamed:@"btn_realName_add"] forState:UIControlStateNormal];
            self.btn_delete.hidden = YES;
            self.btn_delete.enabled = NO;
        }
        
    }];
    
    [self.viewModel.command_up.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if ([x isEqualToString:@"提交成功"]) {
            if (self.viewModel.illegalCollect) {
                self.viewModel.illegalCollect.state = @8;
                self.viewModel.illegalCollect.stateName  = @"异常处理中";
            }
            if (self.viewModel.illegalPark) {
                self.viewModel.illegalPark.state = @8;
                self.viewModel.illegalPark.stateName  = @"异常处理中";
            }
           
            [self.viewModel.subject sendNext:nil];
            
            [[RACScheduler currentScheduler] afterDelay:1 schedule:^{
                @strongify(self);
                [self.navigationController popViewControllerAnimated:YES];
                
            }];
        }
        
    }];
    
}

#pragma mark - configUI

- (void)configUI{
    
    self.title = @"上报异常";
    
    @weakify(self);
    
    //上传按钮配置
    self.btn_up_info.layer.cornerRadius = 5.f;
    self.btn_up_info.layer.masksToBounds = YES;
    
    [[self.btn_delete rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.userPhoto = nil;
    }];;
    
    [[self.btn_upPhoto rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        if (self.viewModel.userPhoto) {
            
            NSMutableArray *t_arr = [NSMutableArray array];
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:self.btn_upPhoto.imageView image:self.viewModel.userPhoto.image];
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
            
        }else{
            
            [self showCameraWithType:5 withFinishBlock:^(LRCameraVC *camera) {
                if (camera) {
                    @strongify(self);
                    if (camera.type == 5) {
                       self.viewModel.userPhoto = [[ImageFileInfo alloc] initWithImage:camera.image withName:key_files];;
                    }
                }
            } isNeedRecognition:NO];
            
        }
        
    }];
    
    //上传实名验证
    [[self.btn_up_info rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.viewModel.command_up execute:nil];
        
    }];
    
}

-(void)showCameraWithType:(NSInteger)type withFinishBlock:(void(^)(LRCameraVC *camera))finishBlock isNeedRecognition:(BOOL)isNeedRecognition{
    
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = type;
    home.isIllegal = isNeedRecognition;
    home.fininshCaptureBlock = finishBlock;
    [self presentViewController:home
                       animated:YES
                     completion:^{
                     }];
    
}

- (void)dealloc{
    LxPrintf(@"IllegalReportAbnormalVC dealloc");
}

@end

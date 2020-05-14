//
//  TakeOutIllegalDetailViewModel.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutIllegalDetailViewModel.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import "TakeOutIllegalDetailVC.h"

@implementation TakeOutIllegalDetailViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        @weakify(self);
        
        self.requestCommand = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                TakeOutReportDetailManger * manger = [[TakeOutReportDetailManger alloc] init];
                manger.reportId = self.reportId;
                [manger configLoadingTitle:@"加载"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        self.model = manger.takeOutReponse;
                        
                        [subscriber sendNext:nil];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
    }
    
    return self;
    
}



- (void)showPhotoBrowser:(NSArray *)photos inView:(UIView *)view withTag:(long)tag{
    
    KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:photos selectedIndex:tag];
    [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
    [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
    browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces             = NO;
    browser.isShowDeleteBtn     = NO;
    
    TakeOutIllegalDetailVC *vc_target = (TakeOutIllegalDetailVC *)[ShareFun findViewController:view withClass:[TakeOutIllegalDetailVC class]];
    [browser showFromViewController:vc_target];
    
}

@end

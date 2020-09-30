//
//  TaskFlowsListModel.m
//  移动采集
//
//  Created by hcat-89 on 2020/3/3.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "TaskFlowsListModel.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import "TaskFlowsDetailVC.h"

@implementation TaskFlowsListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"taskFlowsId" : @"id",
             };
}

- (void)showPhotoBrowser:(NSArray *)photos inView:(UITableViewCell *)cell withTag:(long)tag{
    
    KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:photos selectedIndex:tag];
    [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
    [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
    browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces             = NO;
    browser.isShowDeleteBtn     = NO;
    
    TaskFlowsDetailVC *vc_target = (TaskFlowsDetailVC *)[ShareFun findViewController:cell withClass:[TaskFlowsDetailVC class]];
    [browser showFromViewController:vc_target];

}

@end

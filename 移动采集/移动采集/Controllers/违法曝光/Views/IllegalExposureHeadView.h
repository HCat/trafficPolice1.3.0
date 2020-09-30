//
//  IllegalExposureHeadView.h
//  移动采集
//
//  Created by hcat on 2019/12/5.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ExposureCollectAPI.h"

NS_ASSUME_NONNULL_BEGIN

@protocol IllegalExposureHeadViewDelegate <NSObject>

- (void)recognitionCarNumber:(ImageFileInfo * )imageInfo;

-(void)handleCommitClicked;

@end

@interface IllegalExposureHeadView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIButton *btn_commit;
@property (nonatomic,strong) ExposureCollectReportParam * param;
@property (nonatomic, strong) NSArray < IllegalExposureIllegalTypeModel *> * illegalList; //违法类型
@property (nonatomic,weak) id<IllegalExposureHeadViewDelegate>delegate;




@end

NS_ASSUME_NONNULL_END

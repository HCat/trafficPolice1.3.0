//
//  JointImageCell.m
//  移动采集
//
//  Created by hcat on 2017/11/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "JointImageCell.h"
#import "JointImageVC.h"
#import "JointEnforceVC.h"
#import <PureLayout.h>
#import <UIButton+WebCache.h>
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"


@interface JointImageCell()

@property(nonatomic,strong) NSMutableArray * arr_view;

@end

@implementation JointImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_view = [NSMutableArray array];
}

#pragma mark - set && get

- (void)setImageList:(NSMutableArray<JointLawImageModel *> *)imageList{
    
    _imageList = imageList;
    
    if (_imageList) {
        
        if (_arr_view && _arr_view.count > 0) {
            
            for (int i = 0;i < [_arr_view count]; i++) {
            
                UIButton *t_button  = _arr_view[i];
                [t_button removeFromSuperview];
            }
            [_arr_view removeAllObjects];
            
        }
        
        NSMutableArray *arr_v = [NSMutableArray new];
        
        for (int i = 0;i < [_imageList count]; i++) {
            
            JointLawImageModel *pic = _imageList[i];
            
            UIButton *t_button = [UIButton newAutoLayoutView];
            [t_button sd_setImageWithURL:[NSURL URLWithString:pic.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
            [t_button setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
            t_button.tag = i;
            t_button.layer.cornerRadius = 5.0f;
            t_button.layer.masksToBounds = YES;
            t_button.imageView.contentMode = UIViewContentModeScaleAspectFill;
            [t_button addTarget:self action:@selector(handleImageBtnShowClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.contentView addSubview:t_button];
            [_arr_view addObject:t_button];
            
            if ( i % 3 == 0) {
                
                if (arr_v && [arr_v count] > 0) {
                    [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:20.0 insetSpacing:YES matchedSizes:YES];
                    [arr_v removeAllObjects];
                }
                
                if ( i ==  0){
                    [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:60.0];
                }else{
                    UIButton *btn_before = _arr_view[i - 3];
                    [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:20.0];
                    
                }
                
            }
            
            [arr_v addObject:t_button];
        }
        
        if ([arr_v count] == 1) {
            
            UIButton *btn_before = arr_v[0];
            [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*20)/3];
            [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:20.0f];
        }else if ([arr_v count] == 2){
            
            UIButton *btn_before = arr_v[0];
            UIButton *btn_after = arr_v[1];
            [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*20)/3];
            [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*20)/3];
            
            [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:20.0f];
            [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:20.0];
            
            [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
        }else if ([arr_v count] == 3 ){
            [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:20.0 insetSpacing:YES matchedSizes:YES];
            
        }
        
        [arr_v removeAllObjects];
        
        for (int i = 0;i < [_arr_view count]; i++) {
            UIButton *t_button  = _arr_view[i];
            [t_button autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:t_button];
            
            if (i == _arr_view.count - 1 ) {
                UIButton *t_button_last  = _arr_view[i];
                [t_button_last autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-15.f];
            }
            
        }
        
        [self setNeedsUpdateConstraints];
        [self updateConstraintsIfNeeded];
        
        [self setNeedsLayout];
        [self layoutIfNeeded];

    }

}


#pragma mark -

- (IBAction)handleBtnImageAddClicked:(id)sender {
    
    WS(weakSelf);
     JointEnforceVC *t_vc = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    JointImageVC *t_imageAddVC = [[JointImageVC alloc] init];
    
    NSMutableArray *t_mutableArr = [NSMutableArray array];
    if (_imageList && _imageList.count > 0) {
        for (int i = 0; i < _imageList.count; i++) {
            JointLawImageModel *pic = _imageList[i];
            [t_mutableArr addObject:pic.imgId];
        }
        t_imageAddVC.oldIds = t_mutableArr.copy;
    }
    
    t_imageAddVC.block = ^(NSArray<JointLawImageModel *> *imageList) {
        SW(strongSelf, weakSelf);
        if (strongSelf.imageList.count > 0) {
            [strongSelf.imageList removeAllObjects];
        }
        [strongSelf.imageList addObjectsFromArray:imageList];
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_RELOADJOINTLAWIMAGE object:nil];
    };
    [t_vc.navigationController  pushViewController:t_imageAddVC animated:YES];
    
}

- (IBAction)handleImageBtnShowClicked:(id)sender{
    
    NSInteger tag = [(UIButton *)sender tag];
    
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    if (_arr_view && _arr_view.count > 0) {
        for (int i = 0; i < _arr_view.count; i++) {
            UIButton *btn = _arr_view[i];
            JointLawImageModel *picModel  = _imageList[i];
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:picModel.imgUrl]];
            [t_arr addObject:item];
        }
        
    }
    
    JointEnforceVC *vc_target = (JointEnforceVC *)[ShareFun findViewController:self withClass:[JointEnforceVC class]];
    
    KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:tag];
    [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
    [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
    browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
    browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
    browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
    browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
    browser.bounces             = NO;
    browser.isShowDeleteBtn     = NO;
    [browser showFromViewController:vc_target];
    
    
}

#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    
    NSLog(@"JointImageCell dealloc");
    
}

@end

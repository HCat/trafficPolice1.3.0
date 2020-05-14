//
//  IllegalImageCell.m
//  trafficPolice
//
//  Created by hcat on 2017/6/9.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalImageCell.h"
#import <UIButton+WebCache.h>
#import <PureLayout.h>

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

#import "AccidentPicListModel.h"

#import "IllegalDetailVC.h"
#import "IllegalExposureDetailVC.h"
#import "IllegalAddDetailVC.h"

@interface IllegalImageCell()

@property (nonatomic,strong) NSMutableArray *arr_view;

@end

@implementation IllegalImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.arr_view = [NSMutableArray array];
    
    // Initialization code
}

- (void) setArr_images:(NSMutableArray *)arr_images{
    
    _arr_images = arr_images;
    
    if (_arr_images && _arr_images.count > 0) {
        
        if (_arr_view && _arr_view.count > 0) {
            
            for (int i = 0;i < [_arr_view count]; i++) {
                
                AccidentPicListModel *picModel  = _arr_images[i];
                
                UIView *t_v  = _arr_view[i];
                UIButton *t_button = [t_v viewWithTag:i + 100];
                UILabel *t_lb = [t_v viewWithTag:i + 1000];
                if (picModel.imgUrl) {
                   [t_button sd_setImageWithURL:[NSURL URLWithString:picModel.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
                }else if (picModel.picImage){
                    [t_button setImage:picModel.picImage forState:UIControlStateNormal];
                }
                
                t_lb.text = picModel.picName;
            }
            
        }else{
            
            NSMutableArray *arr_v = [NSMutableArray new];
            
            for (int i = 0;i < [_arr_images count]; i++) {
                
                AccidentPicListModel *picModel  = _arr_images[i];
                
                UIView *t_v = [UIView newAutoLayoutView];
            
                [self.contentView addSubview:t_v];
                
                UIButton * t_button = [UIButton newAutoLayoutView];
                if (picModel.imgUrl) {
                    [t_button sd_setImageWithURL:[NSURL URLWithString:picModel.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
                }else if (picModel.picImage){
                    [t_button setImage:picModel.picImage forState:UIControlStateNormal];
                }
                [t_button setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
                t_button.tag = i + 100;
                t_button.layer.cornerRadius = 5.0f;
                t_button.layer.masksToBounds = YES;
                t_button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
                [t_v addSubview:t_button];
                
                UILabel * t_lable = [UILabel newAutoLayoutView];
                t_lable.text = picModel.picName;
                t_lable.tag = i + 1000;
                t_lable.font = [UIFont systemFontOfSize:14.f];
                t_lable.textColor = UIColorFromRGB(0x444444);
                t_lable.textAlignment = NSTextAlignmentCenter;
                [t_v addSubview:t_lable];
                
                [t_button autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
                [t_button autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:t_v];
                
                [t_lable autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_button withOffset:5.f];
                [t_lable autoPinEdgeToSuperviewEdge:ALEdgeLeading];
                [t_lable autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
                
                UILabel * t_lable_time = [UILabel newAutoLayoutView];
                t_lable_time.text = [ShareFun timeWithTimeInterval:picModel.uploadTime dateFormat:@"HH:mm:ss"];
                t_lable_time.tag = i + 2000;
                t_lable_time.font = [UIFont systemFontOfSize:14.f];
                t_lable_time.textColor = UIColorFromRGB(0xe6504a);
                t_lable_time.textAlignment = NSTextAlignmentCenter;
                [t_v addSubview:t_lable_time];
                
                [t_lable_time autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:t_lable withOffset:5.f];
                [t_lable_time autoPinEdgeToSuperviewEdge:ALEdgeLeading];
                [t_lable_time autoPinEdgeToSuperviewEdge:ALEdgeTrailing];
                
                
                [_arr_view addObject:t_v];
                
                if ( i % 3 == 0) {
                    
                    if (arr_v && [arr_v count] > 0) {
                        [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 insetSpacing:YES matchedSizes:YES];
                        [arr_v removeAllObjects];
                    }
                    
                    if ( i ==  0){
                        [t_v autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:60.0];
                    }else{
                        UIView *v_before = _arr_view[i - 3];
                        [t_v autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:v_before withOffset:10.0];
                        
                    }
                    
                }
                
                [arr_v addObject:t_v];
            }
            
            if ([arr_v count] == 1) {
                
                UIView *v_before = arr_v[0];
                [v_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*10)/3];
                [v_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
                
            }else if ([arr_v count] == 2){
                
                UIView *v_before = arr_v[0];
                UIView *v_after = arr_v[1];
                [v_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*10)/3];
                [v_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*10)/3];
                
                [v_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
                [v_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:v_before withOffset:10.0];
                
                [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
                
            }else if ([arr_v count] == 3 ){
                
                [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 insetSpacing:YES matchedSizes:YES];
                
            }
            
            [arr_v removeAllObjects];
            
            for (int i = 0;i < [_arr_view count]; i++) {
                UIView *t_v  = _arr_view[i];
                [t_v autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:t_v withOffset:44.f];
            }
            
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
        }
    }
    
}

- (IBAction)btnTagAction:(id)sender{
    
    NSInteger tag = [(UIButton *)sender tag];
    
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    if (_arr_view && _arr_view.count > 0) {
        for (int i = 0; i < _arr_view.count; i++) {
            UIView *t_v = _arr_view[i];
            AccidentPicListModel *picModel  = _arr_images[i];
            UIButton *t_btn = [t_v viewWithTag:i + 100];
            if (picModel.imgUrl) {
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:t_btn.imageView imageUrl:[NSURL URLWithString:picModel.imgUrl]];
                [t_arr addObject:item];
            }else if (picModel.picImage){
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:t_btn.imageView image:picModel.picImage];
                [t_arr addObject:item];
            }
            
            
        }
        
    }
    
    if (self.type && [self.type intValue] == 1) {
        
        IllegalExposureDetailVC *vc_target = (IllegalExposureDetailVC *)[ShareFun findViewController:self withClass:[IllegalExposureDetailVC class]];
        
        KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:tag - 100];
        [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
        [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
        browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
        browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces             = NO;
        browser.isShowDeleteBtn     = NO;
        [browser showFromViewController:vc_target];
        
       
    }else if ([self.type intValue] == 2) {
        
        IllegalAddDetailVC *vc_target = (IllegalAddDetailVC *)[ShareFun findViewController:self withClass:[IllegalAddDetailVC class]];
        
        KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:tag - 100];
        [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
        [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
        browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
        browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces             = NO;
        browser.isShowDeleteBtn     = NO;
        [browser showFromViewController:vc_target];
        
       
    }else{
        
        IllegalDetailVC *vc_target = (IllegalDetailVC *)[ShareFun findViewController:self withClass:[IllegalDetailVC class]];
        KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:tag - 100];
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

}

- (float)heightWithimages{
    
    if (_arr_images && _arr_images.count > 0 ) {
        
        if (_arr_images.count % 3 == 0) {
            
            //22.f 是UILabel的高度17加上UILabel和UIButton之间的距离5
            return 80 + ((ScreenWidth - 4*10)/3 + 22.f + 10 + 17)*(_arr_images.count/3);
            
        }else{
            
            return 80 + ((ScreenWidth - 4*10)/3 + 22.f + 10 + 17)*((_arr_images.count/3) + 1);
            
        }
        
    }else{
        
        return 80;
    }
    
}

#pragma mark -

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{

    LxPrintf(@"IllegalImageCell dealloc");

}

@end

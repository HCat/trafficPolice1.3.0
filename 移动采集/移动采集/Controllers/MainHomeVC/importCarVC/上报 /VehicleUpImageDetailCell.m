//
//  VehicleUpImageDetailCell.m
//  移动采集
//
//  Created by hcat on 2018/5/29.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpImageDetailCell.h"
#import <UIButton+WebCache.h>
#import <PureLayout.h>

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"
#import "VehicleUpCarDetailVC.h"

@interface VehicleUpImageDetailCell()

@property (nonatomic,strong) NSMutableArray *arr_view;
@property (nonatomic,strong) NSMutableArray<VehcleUpImageModel *> *arr_images;

@end



@implementation VehicleUpImageDetailCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_view = [NSMutableArray array];
}

-(void)setModel:(VehicleUpDetailModel *)model{
    _model = model;
    
    if (_model) {
        self.arr_images  = [NSMutableArray arrayWithArray:_model.imgList];
    }
    
    
}


- (void) setArr_images:(NSMutableArray *)arr_images{
    
    _arr_images = arr_images;
    
    if (_arr_images && _arr_images.count > 0) {
     
        if (_arr_view && _arr_view.count > 0) {
            
            for (int i = 0;i < [_arr_view count]; i++) {
                
                VehcleUpImageModel * pic = _arr_images[i];
                
                UIButton *t_button  = _arr_view[i];
                [t_button sd_setImageWithURL:[NSURL URLWithString:pic.mediaUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
            }
            
        }else{
            
            NSMutableArray *arr_v = [NSMutableArray new];
            
            for (int i = 0;i < [_arr_images count]; i++) {
                
                VehcleUpImageModel *pic = _arr_images[i];
                
                UIButton *t_button = [UIButton newAutoLayoutView];
                [t_button sd_setImageWithURL:[NSURL URLWithString:pic.mediaUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
                [t_button setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
                t_button.tag = i;
                t_button.layer.cornerRadius = 5.0f;
                t_button.layer.masksToBounds = YES;
                t_button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:t_button];
                [_arr_view addObject:t_button];
                
                if ( i % 3 == 0) {
                    
                    if (arr_v && [arr_v count] > 0) {
                        [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 insetSpacing:YES matchedSizes:YES];
                        [arr_v removeAllObjects];
                    }
                    
                    if ( i ==  0){
                        [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeTop ofView:self.contentView withOffset:40.0];
                    }else{
                        UIButton *btn_before = _arr_view[i - 3];
                        [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:10.0];
                        
                    }
                    
                }
                
                [arr_v addObject:t_button];
            }
            
            if ([arr_v count] == 1) {
                
                UIButton *btn_before = arr_v[0];
                [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*10)/3];
                [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
            }else if ([arr_v count] == 2){
                
                UIButton *btn_before = arr_v[0];
                UIButton *btn_after = arr_v[1];
                [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*10)/3];
                [btn_after autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 4*10)/3];
                
                [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:10.0f];
                [btn_after autoPinEdge:ALEdgeLeading toEdge:ALEdgeTrailing ofView:btn_before withOffset:10.0];
                
                [arr_v autoAlignViewsToAxis:ALAxisHorizontal];
            }else if ([arr_v count] == 3 ){
                [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:10.0 insetSpacing:YES matchedSizes:YES];
                
            }
            
            [arr_v removeAllObjects];
            
            for (int i = 0;i < [_arr_view count]; i++) {
                UIButton *t_button  = _arr_view[i];
                [t_button autoMatchDimension:ALDimensionHeight toDimension:ALDimensionWidth ofView:t_button];
                
                if (i == _arr_view.count - 1 ) {
                    UIButton *t_button_last  = _arr_view[i];
                    [t_button_last autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-20.f];
                }
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
            UIButton *btn = _arr_view[i];
            VehcleUpImageModel *picModel  = _arr_images[i];
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:picModel.mediaUrl]];
            [t_arr addObject:item];
        }
        
    }
    
    VehicleUpCarDetailVC *vc_target = (VehicleUpCarDetailVC *)[ShareFun findViewController:self withClass:[VehicleUpCarDetailVC class]];
    
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









- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - dealloc

- (void)dealloc{
    
    LxPrintf(@"");
    
}

@end

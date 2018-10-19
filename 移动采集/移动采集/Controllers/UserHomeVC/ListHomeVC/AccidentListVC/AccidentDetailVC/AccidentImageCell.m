//
//  AccidentImageCell.m
//  trafficPolice
//
//  Created by hcat on 2017/6/8.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "AccidentImageCell.h"
#import <UIButton+WebCache.h>
#import <PureLayout.h>

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

#import "AccidentDetailVC.h"


@interface AccidentImageCell()

@property (nonatomic,strong) NSMutableArray *arr_view;

@property (weak, nonatomic) IBOutlet UIView *v_title;
@property (weak, nonatomic) IBOutlet UILabel *lb_title;



@end


@implementation AccidentImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.arr_view = [NSMutableArray array];
    // Initialization code
}


- (void) setArr_images:(NSMutableArray *)arr_images{
    
    _arr_images = arr_images;
    
    if (_arr_images && _arr_images.count > 0) {
        _v_title.hidden = NO;
        _lb_title.hidden = NO;
        
        if (_arr_view && _arr_view.count > 0) {
            
            for (int i = 0;i < [_arr_view count]; i++) {
                
                AccidentPicListModel *pic = _arr_images[i];
                
                UIButton *t_button  = _arr_view[i];
                if (pic.imgUrl) {
                    [t_button sd_setImageWithURL:[NSURL URLWithString:pic.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
                }else if (pic.picImage){
                    [t_button setImage:pic.picImage forState:UIControlStateNormal];
                }
            }
        
        }else{
        
            NSMutableArray *arr_v = [NSMutableArray new];
            
            for (int i = 0;i < [_arr_images count]; i++) {
                
                AccidentPicListModel *pic = _arr_images[i];
                
                UIButton *t_button = [UIButton newAutoLayoutView];
                if (pic.imgUrl) {
                    [t_button sd_setImageWithURL:[NSURL URLWithString:pic.imgUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
                }else if (pic.picImage){
                    [t_button setImage:pic.picImage forState:UIControlStateNormal];
                }
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
            }
            
            [self setNeedsUpdateConstraints];
            [self updateConstraintsIfNeeded];
            
            [self setNeedsLayout];
            [self layoutIfNeeded];
            
        }
        
    }else{
        _v_title.hidden = YES;
        _lb_title.hidden = YES;
    }
    
}


- (IBAction)btnTagAction:(id)sender{
    
    NSInteger tag = [(UIButton *)sender tag];
    
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    if (_arr_view && _arr_view.count > 0) {
        for (int i = 0; i < _arr_view.count; i++) {
            UIButton *btn = _arr_view[i];
            AccidentPicListModel *picModel  = _arr_images[i];
           
            if (picModel.imgUrl) {
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:picModel.imgUrl]];
                [t_arr addObject:item];
            }else if (picModel.picImage){
                KSPhotoItem *item = [KSPhotoItem itemWithSourceView:btn.imageView image:picModel.picImage];
                [t_arr addObject:item];
            }
        }
        
    }
    
    AccidentDetailVC *vc_target = (AccidentDetailVC *)[ShareFun findViewController:self withClass:[AccidentDetailVC class]];
    
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

- (float)heightWithimages{

    if (_arr_images && _arr_images.count > 0 ) {
        
        if (_arr_images.count % 3 == 0) {
            return 40 + ((ScreenWidth - 4*10)/3 + 10)*(_arr_images.count/3);
        }else{
            return 40 + ((ScreenWidth - 4*10)/3 + 10)*((_arr_images.count/3) + 1);
        }
    }else{
    
        return 0;
    }
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

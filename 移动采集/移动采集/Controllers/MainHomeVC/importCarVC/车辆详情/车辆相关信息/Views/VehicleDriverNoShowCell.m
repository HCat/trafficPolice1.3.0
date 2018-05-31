//
//  VehicleDriverNoShowCell.m
//  移动采集
//
//  Created by hcat-89 on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleDriverNoShowCell.h"
#import <UIButton+WebCache.h>
#import <PureLayout.h>
#import "CALayer+Additions.h"

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

#import "VehicleCarMoreVC.h"
#import "VehicleAPI.h"

@interface VehicleDriverNoShowCell ()

@property (nonatomic,weak) IBOutlet UILabel * lb_driverName;         //驾驶员姓名
@property (nonatomic,weak) IBOutlet UILabel * lb_driverCode;         //驾驶证号码
@property (nonatomic,weak) IBOutlet UILabel * lb_drivingType;        //准驾车型
@property (nonatomic,weak) IBOutlet UILabel * lb_vehicleImgList;//证件照片

@property (nonatomic,copy)   NSArray <VehicleImageModel *> * driverImgList; //驾驶员证件照片

@property (nonatomic,strong) NSMutableArray *arr_view;

@property (weak, nonatomic) IBOutlet UIButton *btn_show;
@property (weak, nonatomic) IBOutlet UIView *v_backgound;

@end

@implementation VehicleDriverNoShowCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!self.arr_view) {
        self.arr_view = [NSMutableArray array];
    }

}
- (void)setDriver:(VehicleDriverModel *)driver{
    
    _driver = driver;
    
    if (_driver) {
        
        _lb_driverName.text = [ShareFun takeStringNoNull:_driver.driverName];
        _lb_drivingType.text = [ShareFun takeStringNoNull:_driver.drivingType];
        _lb_driverCode.text = [ShareFun idCardToAsterisk:[ShareFun takeStringNoNull:_driver.driverCode]];;
       
        self.driverImgList = _driver.driverImgList;
        
    }
    
}


- (void)setDriverImgList:(NSArray<VehicleImageModel *> *)driverImgList{
    
    if (!_driverImgList) {
        _driverImgList = driverImgList;
        
        if (_driverImgList && _driverImgList.count > 0) {
            
            NSMutableArray *arr_v = [NSMutableArray new];
            
            for (int i = 0;i < [_driverImgList count]; i++) {
                
                VehicleImageModel *pic = _driverImgList[i];
                
                UIButton *t_button = [UIButton newAutoLayoutView];
                
                NSString *str_url = [NSString stringWithFormat:@"%@%@",Base_URL,pic.mediaThumbUrl];
                
                [t_button sd_setImageWithURL:[NSURL URLWithString:str_url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
                
                [t_button setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
                t_button.tag = i;
                t_button.layer.cornerRadius = 5.0f;
                t_button.layer.masksToBounds = YES;
                t_button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                t_button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentFill;
                t_button.contentVerticalAlignment = UIControlContentVerticalAlignmentFill;
                [t_button addTarget:self action:@selector(btnTagAction:) forControlEvents:UIControlEventTouchUpInside];
                [self.contentView addSubview:t_button];
                [_arr_view addObject:t_button];
                
                if ( i % 2 == 0) {
                    
                    if (arr_v && [arr_v count] > 0) {
                        [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:35.0 insetSpacing:YES matchedSizes:YES];
                        [arr_v removeAllObjects];
                    }
                    
                    if ( i ==  0){
                        [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:_lb_vehicleImgList withOffset:20.0];
                    }else{
                        UIButton *btn_before = _arr_view[i - 2];
                        [t_button autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:btn_before withOffset:10.0];
                        
                    }
                    
                }
                
                [arr_v addObject:t_button];
            }
            
            if ([arr_v count] == 1) {
                
                UIButton *btn_before = arr_v[0];
                [btn_before autoSetDimension:ALDimensionWidth toSize:(ScreenWidth - 3*35)/2];
                [btn_before autoPinEdgeToSuperviewEdge:ALEdgeLeading withInset:35.0f];
            }else if ([arr_v count] == 2){
                [arr_v autoDistributeViewsAlongAxis:ALAxisHorizontal alignedTo:ALAttributeHorizontal withFixedSpacing:35.0 insetSpacing:YES matchedSizes:YES];
                
            }
            
            [arr_v removeAllObjects];
            
            for (int i = 0;i < [_arr_view count]; i++) {
                UIButton *t_button  = _arr_view[i];
                [t_button autoSetDimension:ALDimensionHeight toSize:100.f];
                
                if (i == _arr_view.count - 1 ) {
                    UIButton *t_button_last  = _arr_view[i];
                    [t_button_last autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-15.0f relation:NSLayoutRelationLessThanOrEqual];
                }
            }
            
        }else{
            
            [_lb_vehicleImgList autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-15.0f];
            
        }
        
    }

}


- (IBAction)btnTagAction:(id)sender{
    
    NSInteger tag = [(UIButton *)sender tag];
    
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    if (_arr_view && _arr_view.count > 0) {
        for (int i = 0; i < _arr_view.count; i++) {
            UIButton *btn = _arr_view[i];
            VehicleImageModel *picModel  = _driverImgList[i];
            
            NSString *str_url = [NSString stringWithFormat:@"%@%@",Base_URL,picModel.mediaThumbWaterUrl];
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:str_url]];
            [t_arr addObject:item];
        }
        
    }
    
    VehicleCarMoreVC *vc_target = (VehicleCarMoreVC *)[ShareFun findViewController:self withClass:[VehicleCarMoreVC class]];
    
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

#pragma mark - 按钮事件

- (IBAction)handleBtnNoShowMoreClicked:(id)sender {
    
    if (self.block) {
        self.block();
    }
    
    
}


#pragma mark - dealloc

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{

    LxPrintf(@"VehicleDriverNoShowCell dealloc");

}

@end

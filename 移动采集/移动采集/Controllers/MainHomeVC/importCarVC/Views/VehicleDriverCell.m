//
//  VehicleDriverCell.m
//  移动采集
//
//  Created by hcat-89 on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleDriverCell.h"

#import <UIButton+WebCache.h>
#import <PureLayout.h>
#import "CALayer+Additions.h"

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

#import "VehicleDetailVC.h"
#import "VehicleAPI.h"

@interface VehicleDriverCell ()

@property (nonatomic,weak) IBOutlet UILabel * lb_driverName;         //驾驶员姓名
@property (nonatomic,weak) IBOutlet UILabel * lb_sex;                //驾驶员性别 1：男 2：女
@property (nonatomic,weak) IBOutlet UILabel * lb_driverCode;         //驾驶证号码
@property (nonatomic,weak) IBOutlet UILabel * lb_drivingType;        //准驾车型
@property (nonatomic,weak) IBOutlet UILabel * lb_yearTrialDeadline;  //年审截止日期
@property (nonatomic,weak) IBOutlet UILabel * lb_invalidDate;        //有效期截止日期
@property (nonatomic,weak) IBOutlet UILabel * lb_certificationDate;  //从业时间
@property (nonatomic,weak) IBOutlet UILabel * lb_driverLicence;      //从业资格证号
@property (nonatomic,weak) IBOutlet UILabel * lb_licenceInvalidTime; //资格证有效期
@property (nonatomic,weak) IBOutlet UILabel * lb_telephone;          //联系电话
@property (nonatomic,weak) IBOutlet UILabel * lb_address;            //居住地址
@property (nonatomic,weak) IBOutlet UILabel * lb_vehicleImgList;//证件照片


@property (nonatomic,copy)   NSArray <VehicleImageModel *> * driverImgList; //驾驶员证件照片

@property (nonatomic,strong) NSMutableArray *arr_view;


@end

@implementation VehicleDriverCell

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
        
        if ([_driver.sex isEqualToString:@"1"]) {
            _lb_sex.text = @"男";
        }else{
            _lb_sex.text = @"女";
        }
        
        _lb_driverCode.text = [ShareFun idCardToAsterisk:[ShareFun takeStringNoNull:_driver.driverCode]];
        _lb_yearTrialDeadline.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_driver.yearTrialDeadline dateFormat:@"yyyy年MM月dd日"]];
        _lb_drivingType.text = [ShareFun takeStringNoNull:_driver.drivingType];
        _lb_invalidDate.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_driver.invalidDate dateFormat:@"yyyy年MM月dd日"]];
        _lb_certificationDate.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_driver.certificationDate dateFormat:@"yyyy年MM月dd日"]];
        _lb_driverLicence.text = [ShareFun idCardToAsterisk:[ShareFun takeStringNoNull:_driver.driverLicence]];
        _lb_licenceInvalidTime.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_driver.licenceInvalidTime dateFormat:@"yyyy年MM月dd日"]];
        _lb_telephone.text = [ShareFun takeStringNoNull:_driver.telephone];
        _lb_address.text = [ShareFun takeStringNoNull:_driver.address];
        
        
        
        self.driverImgList = [_driver.driverImgList copy];
        
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
                
                [t_button sd_setImageWithURL:[NSURL URLWithString:pic.mediaUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    [GCDQueue executeInLowPriorityGlobalQueue:^{
                        UIImage * t_image = [ShareFun addWatemarkTextAfteriOS7_WithLogoImage:image watemarkText:@"此证件仅提供交警存档使用，他用无效." needHigh:NO];
                        [GCDQueue executeInMainQueue:^{
                            [t_button setImage:t_image forState:UIControlStateNormal];
                        }];
                    }];
                    
                }];
                [t_button setBackgroundColor:UIColorFromRGB(0xf2f2f2)];
                t_button.tag = i;
                t_button.layer.cornerRadius = 5.0f;
                t_button.layer.masksToBounds = YES;
                t_button.imageView.contentMode = UIViewContentModeScaleAspectFill;
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
                [t_button autoSetDimension:ALDimensionHeight toSize:100.0f];
                
                if (i == _arr_view.count - 1 ) {
                    UIButton *t_button_last  = _arr_view[i];
                    [t_button_last autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_lb_sex withOffset:-15.f];
                }
            }
            
        }else{
            
            [_lb_vehicleImgList autoPinEdge:ALEdgeBottom toEdge:ALEdgeTop ofView:_lb_sex withOffset:-15.f];
            
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
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:picModel.mediaUrl] withVehiclePhotoModel:picModel];
            [t_arr addObject:item];
        }
        
    }
    
    VehicleDetailVC *vc_target = (VehicleDetailVC *)[ShareFun findViewController:self withClass:[VehicleDetailVC class]];
    
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
    
    LxPrintf(@"VehicleDriverCell dealloc");
    
}

@end

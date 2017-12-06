//
//  VehicleMemberCell.m
//  移动采集
//
//  Created by hcat-89 on 2017/9/8.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleMemberCell.h"

#import <UIButton+WebCache.h>
#import <PureLayout.h>
#import "CALayer+Additions.h"

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

#import "VehicleDetailVC.h"

@interface VehicleMemberCell ()

@property (nonatomic,weak) IBOutlet UILabel * lb_name;               //运输主体名称
@property (nonatomic,weak) IBOutlet UILabel * lb_memtype;            //运输主体性质:1土方车 2水泥砼车 3砂石子车
@property (nonatomic,weak) IBOutlet UILabel * lb_licenseTime;   //营业执照有效期,开始时间到结束时间
@property (nonatomic,weak) IBOutlet UILabel * lb_memberArea;            //所在区域
@property (nonatomic,weak) IBOutlet UILabel * lb_address;            //详细地址
@property (nonatomic,weak) IBOutlet UILabel * lb_contact;            //法人代表
@property (nonatomic,weak) IBOutlet UILabel * lb_manager;            //车队管理员
@property (nonatomic,weak) IBOutlet UILabel * lb_safer;              //安全管理员
@property (nonatomic,weak) IBOutlet UILabel * lb_vehicleImgList;             //证件照片

@property (nonatomic,strong) NSMutableArray *arr_view;

@end


@implementation VehicleMemberCell

- (void)awakeFromNib {
    [super awakeFromNib];
    if (!self.arr_view) {
        self.arr_view = [NSMutableArray array];
    }
}

- (void)setMemberInfo:(MemberInfoModel *)memberInfo{

    _memberInfo = memberInfo;
    
    if (_memberInfo) {
        
        _lb_name.text = [ShareFun takeStringNoNull:_memberInfo.name];   //运输主体名称
        //车辆类型:1土方车 2水泥砼车 3砂石子车
        if ([_memberInfo.memtype isEqualToNumber:@1]) {
            _lb_memtype.text = @"土方车";
        }else if ([_memberInfo.memtype isEqualToNumber:@2]){
            _lb_memtype.text = @"水泥砼车";
        }else{
            _lb_memtype.text = @"砂石子车";
        }
        

        _lb_licenseTime.text = [ShareFun takeStringNoNull:[NSString stringWithFormat:@"%@到%@",[ShareFun timeWithTimeInterval:_memberInfo.licenseTimeStart dateFormat:@"yyyy年MM月dd日"],[ShareFun timeWithTimeInterval:_memberInfo.licenseTimeEnd dateFormat:@"yyyy年MM月dd日"]]];
        _lb_address.text = [ShareFun takeStringNoNull:_memberInfo.address];
        
        _lb_contact.text = [ShareFun takeStringNoNull:_memberInfo.contact];
        
        _lb_manager.text = [ShareFun takeStringNoNull:_memberInfo.manager];
        
        _lb_safer.text = [ShareFun takeStringNoNull:_memberInfo.safer];
        
    
    }

}

- (void)setMemberArea:(NSString *)memberArea{

    _memberArea = memberArea;
    
    _lb_memberArea.text = [ShareFun takeStringNoNull:_memberArea];
    
}

- (void)setImagelists:(NSArray<VehicleImageModel *> *)imagelists{
    
    if (!_imagelists) {
        _imagelists = imagelists;
        
        if (_imagelists && _imagelists.count > 0) {
            
            
            NSMutableArray *arr_v = [NSMutableArray new];
            
            for (int i = 0;i < [_imagelists count]; i++) {
                
                VehicleImageModel *pic = _imagelists[i];
                
                UIButton *t_button = [UIButton newAutoLayoutView];
                [t_button sd_setImageWithURL:[NSURL URLWithString:pic.mediaUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                    
                    [GCDQueue executeInLowPriorityGlobalQueue:^{
                        UIImage * t_image = [ShareFun addWatemarkTextAfteriOS7_WithLogoImage:image watemarkText:@"此证件仅提供交警存档使用，他用无效" NeedHigh:NO];
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
                    [t_button_last autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-55.0];
                }
            }
            
        }else{
            
            [_lb_vehicleImgList autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50];
            
        }
        
    }
    
}


- (IBAction)btnTagAction:(id)sender{
    
    NSInteger tag = [(UIButton *)sender tag];
    
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    if (_arr_view && _arr_view.count > 0) {
        for (int i = 0; i < _arr_view.count; i++) {
            UIButton *btn = _arr_view[i];
            VehicleImageModel *picModel  = _imagelists[i];
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

    LxPrintf(@"VehicleMemberCell dealloc");
    
}

@end

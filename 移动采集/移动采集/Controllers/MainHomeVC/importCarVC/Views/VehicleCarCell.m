//
//  VehicleCarCell.m
//  移动采集
//
//  Created by hcat on 2017/9/7.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "VehicleCarCell.h"
#import <UIButton+WebCache.h>
#import <PureLayout.h>
#import "CALayer+Additions.h"

#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

#import "VehicleDetailVC.h"
#import "VehicleReportVC.h"

@interface VehicleCarCell()

@property (nonatomic,weak) IBOutlet UILabel * lb_plateno;                    //车牌号
@property (nonatomic,weak) IBOutlet UILabel * lb_jinNumber;                    //晋工号
@property (nonatomic,weak) IBOutlet UILabel * lb_carType;                    //车辆类型:1土方车 2水泥砼车 3砂石子车
@property (nonatomic,weak) IBOutlet UILabel * lb_inspectTimeEnd;             //年审截止日期
@property (nonatomic,weak) IBOutlet UILabel * lb_compInsuranceTimeEnd;       //强制险截止日期
@property (nonatomic,weak) IBOutlet UILabel * lb_bussInsuranceTimeEnd;       //商业险截止日期
@property (nonatomic,weak) IBOutlet UILabel * lb_factoryno;                  //车架号码
@property (nonatomic,weak) IBOutlet UILabel * lb_motorid;                    //发动机号码
@property (nonatomic,weak) IBOutlet UILabel * lb_description;                //车辆描述
@property (nonatomic,weak) IBOutlet UILabel * lb_driver;                     //车主姓名
@property (nonatomic,weak) IBOutlet UILabel * lb_dvrcard;                    //车主身份证
@property (nonatomic,weak) IBOutlet UILabel * lb_drivermobile;               //车主电话
@property (nonatomic,weak) IBOutlet UILabel * lb_carHopper;                  //车斗信息
@property (nonatomic,weak) IBOutlet UILabel * lb_status;                     //车辆状态
@property (nonatomic,weak) IBOutlet UILabel * lb_remark;                     //备注
@property (nonatomic,weak) IBOutlet UILabel * lb_vehicleImgList;             //证件照片
@property (weak, nonatomic) IBOutlet UIButton *btn_edit;
@property (nonatomic,strong) NSMutableArray *arr_view;

@end

@implementation VehicleCarCell


- (void)awakeFromNib {
    [super awakeFromNib];
    
    if (!self.arr_view) {
        self.arr_view = [NSMutableArray array];
    }
    
    // Initialization code
}

- (void)setVehicle:(VehicleModel *)vehicle{

    _vehicle = vehicle;
    
    if (_vehicle) {
        
        _lb_plateno.text = [ShareFun takeStringNoNull:_vehicle.plateno];  //车牌号
        
        _lb_jinNumber.text = [ShareFun takeStringNoNull:[NSString stringWithFormat:@"%@%@",_vehicle.memFormNo,_vehicle.selfNo]];
        
        //车辆类型:1土方车 2水泥砼车 3砂石子车
        if ([_vehicle.carType isEqualToNumber:@1]) {
            _lb_carType.text = @"土方车";
        }else if ([_vehicle.carType isEqualToNumber:@2]){
            _lb_carType.text = @"水泥砼车";
        }else{
            _lb_carType.text = @"砂石子车";
        }
        
        _lb_inspectTimeEnd.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_vehicle.inspectTimeEnd dateFormat:@"yyyy年MM月dd日"]];             //年审截止日期
        _lb_compInsuranceTimeEnd.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_vehicle.compInsuranceTimeEnd dateFormat:@"yyyy年MM月dd日"]]; //强制险截止日期
        _lb_bussInsuranceTimeEnd.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_vehicle.bussInsuranceTimeEnd dateFormat:@"yyyy年MM月dd日"]]; //商业险截止日期
        _lb_factoryno.text = [ShareFun takeStringNoNull:_vehicle.factoryno];            //车架号码
        _lb_motorid.text = [ShareFun takeStringNoNull:_vehicle.motorid];                //发动机号码
        _lb_description.text = [ShareFun takeStringNoNull:_vehicle.description_text];   //车辆描述
        _lb_driver.text = [ShareFun takeStringNoNull:_vehicle.driver];                  //车主姓名
        _lb_dvrcard.text = [ShareFun idCardToAsterisk:[ShareFun takeStringNoNull:_vehicle.dvrcard]];                //车主身份证
        _lb_drivermobile.text = [ShareFun takeStringNoNull:_vehicle.drivermobile];      //车主电话
        
        //车厢外高度
        _lb_carHopper.text = [ShareFun takeStringNoNull:_vehicle.carriageOutsideH];
        _lb_status.text = [ShareFun takeStringNoNull:_vehicle.status];                  //车辆状态
        _lb_remark.text = [ShareFun takeStringNoNull:_vehicle.remark];                  //备注
        
        
    }

}

- (void)setImagelists:(NSMutableArray <VehicleImageModel *> *)imagelists{

    _imagelists = imagelists;
    
    if (_imagelists && _imagelists.count > 0) {
        
        
        if (_arr_view && _arr_view.count > 0) {
            for (UIButton *t_button in _arr_view) {
                [t_button removeFromSuperview];
               
            }
            [_arr_view removeAllObjects];
        }
        
        NSMutableArray *arr_v = [NSMutableArray new];
        
        for (int i = 0;i < [_imagelists count]; i++) {
            
            VehicleImageModel *pic = _imagelists[i];
            
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
                [t_button_last autoPinEdge:ALEdgeBottom toEdge:ALEdgeBottom ofView:self.contentView withOffset:-55.0];
            }
        }
        
    }else{
        
        [_lb_vehicleImgList autoPinEdgeToSuperviewEdge:ALEdgeBottom withInset:50];
        
    }
    
}

- (void)setIsReportEdit:(NSNumber *)isReportEdit{
    _isReportEdit = isReportEdit;
    
    if ([_isReportEdit isEqualToNumber:@1]) {
        _btn_edit.hidden = NO;
    }else{
        _btn_edit.hidden = YES;
    }
    
}


- (IBAction)btnTagAction:(id)sender{

    NSInteger tag = [(UIButton *)sender tag];
    
    
    NSMutableArray *t_arr = [NSMutableArray array];
    
    if (_arr_view && _arr_view.count > 0) {
        for (int i = 0; i < _arr_view.count; i++) {
            UIButton *btn = _arr_view[i];
            VehicleImageModel *picModel  = _imagelists[i];
            
            NSString *str_url = [NSString stringWithFormat:@"%@%@",Base_URL,picModel.mediaThumbWaterUrl];
            
            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:str_url]];
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

//编辑按钮事件
- (IBAction)handleBtnEditClicked:(id)sender {
    
    VehicleDetailVC *vc_target = (VehicleDetailVC *)[ShareFun findViewController:self withClass:[VehicleDetailVC class]];
    
    VehicleReportVC *t_vc = [[VehicleReportVC alloc] init];
    WS(weakSelf);
    t_vc.block = ^(VehicleImageModel *imageModel,NSString *oldImgId,NSString *carriageOutsideH) {
        SW(strongSelf, weakSelf);
        if (imageModel && imageModel.mediaId.length > 0) {
            if (oldImgId) {
                [strongSelf.imagelists enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    
                    VehicleImageModel *t_image = (VehicleImageModel *)obj;
                    if([t_image.mediaId isEqualToString:oldImgId]){
                        *stop = YES;
                        [strongSelf.imagelists removeObject:obj];
                    }
                    
                }];
            }
            
            [strongSelf.imagelists addObject:imageModel];
            if (strongSelf.editBlock) {
                strongSelf.editBlock();
            }
            
            return;
        }
        
        if (oldImgId) {
            
            [strongSelf.imagelists enumerateObjectsUsingBlock:^(id _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                
                VehicleImageModel *t_image = (VehicleImageModel *)obj;
                if([t_image.mediaId isEqualToString:oldImgId]){
                    *stop = YES;
                    [strongSelf.imagelists removeObject:obj];
                }
                
            }];
            
        
        }
        
        if (carriageOutsideH && carriageOutsideH.length > 0) {
            strongSelf.vehicle.carriageOutsideH = carriageOutsideH;
        }
        
        if (strongSelf.editBlock) {
            strongSelf.editBlock();
        }
        
    };
    t_vc.platNo = _vehicle.vehicleid;
    [vc_target.navigationController pushViewController:t_vc animated:YES];

}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{

    LxPrintf(@"VehicleCarCell dealloc");

}

@end

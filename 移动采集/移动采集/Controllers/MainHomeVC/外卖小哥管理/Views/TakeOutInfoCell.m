//
//  TakeOutInfoCell.m
//  移动采集
//
//  Created by hcat on 2019/5/9.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutInfoCell.h"
#import <UIImageView+WebCache.h>
#import "TakeOutInfoView.h"
#import "TakeOutInfoVC.h"
#import "TakeOutCarInfoVC.h"
#import "TakeOutIllegalListVC.h"
#import "KSPhotoBrowser.h"
#import "KSSDImageManager.h"

@interface TakeOutInfoCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_name; //快递员姓名
@property (weak, nonatomic) IBOutlet UILabel *lb_licenseNo;//快递员身份证
@property (weak, nonatomic) IBOutlet UILabel *lb_score; //快递员剩余分数
@property (weak, nonatomic) IBOutlet UIImageView *imageV_picUrl; //快递员人头像照片
@property (weak, nonatomic) IBOutlet UILabel *lb_deliveryTypeStr;//暂无，兼职，专职

@property (weak, nonatomic) IBOutlet UILabel *lb_unit;
@property (weak, nonatomic) IBOutlet UILabel *lb_car;

@property (weak, nonatomic) IBOutlet UIButton *btn_showImage;



@property (weak, nonatomic) IBOutlet UIImageView *imageV_user;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_unit;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_car;

@property (weak, nonatomic) IBOutlet UIButton *btn_illegal;


@end

@implementation TakeOutInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    @weakify(self);
    [RACObserve(self, model) subscribeNext:^(DeliveryInfoModel *  _Nullable x) {
        @strongify(self);
        if (x) {
            
            self.lb_name.text = x.name; //快递员姓名
            self.lb_licenseNo.text = x.licenseNo;//快递员身份证
            self.lb_score.text = [x.score stringValue]; //快递员剩余分数
            self.lb_deliveryTypeStr.text = x.deliveryTypeStr;
            [self.imageV_picUrl sd_setImageWithURL:[NSURL URLWithString:x.picUrl] placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
            
            if (x.dcList && x.dcList.count > 0) {
                
                TakeOutInfoView * t_view = nil;
                
                for (int i = 0 ; i < x.dcList.count ; i++ ) {
                    
                    DeliveryCompanyModel * companyModel = x.dcList[i];
                    TakeOutInfoView * view = [TakeOutInfoView initCustomView];
                    view.str_title = [NSString stringWithFormat:@"%@",companyModel.companyName];
                    view.str_content = companyModel.companyNo;
                    view.isMore = NO;
                    view.index = i;
                    [view configUI];
                    [self.contentView addSubview:view];
                    
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(0);
                        make.right.mas_equalTo(0);
                        make.height.mas_equalTo(43);
                    }];
                    
                    if (t_view) {
                        [view mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(t_view.mas_bottom);
                        }];
                    }else{
                        [view mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(self.lb_unit.mas_bottom).with.offset(10);
                        }];
                        
                    }
                    t_view = view;
                }
                
                self.layout_unit.constant = 20 + x.dcList.count * 43;
                [self layoutIfNeeded];
                
            }
            
            if (x.dvList && x.dvList.count > 0) {
                
                TakeOutInfoView * t_view = nil;
                
                for (int i = 0 ; i < x.dvList.count ; i++ ) {
                    
                    DeliveryVehicleInfoModel * companyModel = x.dvList[i];
                    TakeOutInfoView * view = [TakeOutInfoView initCustomView];
                    view.str_title = companyModel.companyName;
                    view.str_content = companyModel.plateNo;
                    view.isMore = YES;
                    view.index = i;
                    [view configUI];
                    view.selectedBlock = ^(int index) {
                        DeliveryVehicleInfoModel * t_companyModel = self.model.dvList[index];
                        
                        TakeOutCarInfoViewModel * viewModel = [[TakeOutCarInfoViewModel alloc] init];
                        viewModel.vehicleId = t_companyModel.vehicleId;
                        TakeOutCarInfoVC * t_vc = [[TakeOutCarInfoVC alloc] initWithViewModel:viewModel];
                        TakeOutInfoVC * vc = (TakeOutInfoVC *)[ShareFun findViewController:self withClass:[TakeOutInfoVC class]];
                        [vc.navigationController pushViewController:t_vc animated:YES];
                        
                    };
                    
                    
                    [self.contentView addSubview:view];
                    
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.left.mas_equalTo(0);
                        make.right.mas_equalTo(0);
                        make.height.mas_equalTo(43);
                    }];
                    
                    if (t_view) {
                        
                        [view mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(t_view.mas_bottom);
                        }];
                        
                    }else{
                        
                        [view mas_updateConstraints:^(MASConstraintMaker *make) {
                            make.top.mas_equalTo(self.lb_car.mas_bottom).with.offset(10);
                        }];
                        
                    }
                    t_view = view;
                }
                
                self.layout_car.constant = 20 + x.dvList.count * 43;
                [self layoutIfNeeded];
                
            }
            
        }
    
    }];
    
    [[self.btn_illegal rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
       @strongify(self);
        
        if (self.model) {
        
            TakeOutIllegalListViewModel * viewModel = [[TakeOutIllegalListViewModel alloc] init];
            viewModel.deliveryId = self.model.deliveryId;
            TakeOutIllegalListVC * t_vc = [[TakeOutIllegalListVC alloc] initWithViewModel:viewModel];
            TakeOutInfoVC * vc = (TakeOutInfoVC *)[ShareFun findViewController:self withClass:[TakeOutInfoVC class]];
            [vc.navigationController pushViewController:t_vc animated:YES];
            
        }
        
        
    }];
    
    
    [[self.btn_showImage rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        //将arr_upImages中有图片的赋值到t_arr中用于LLPhotoBrowser中
        
        TakeOutInfoVC * vc = (TakeOutInfoVC *)[ShareFun findViewController:self withClass:[TakeOutInfoVC class]];
        
        NSMutableArray *t_arr = [NSMutableArray array];
        
        KSPhotoItem *item = [KSPhotoItem itemWithSourceView:self.imageV_picUrl imageUrl:[NSURL URLWithString:self.model.picUrl]];
        [t_arr addObject:item];
        
        KSPhotoBrowser *browser     = [KSPhotoBrowser browserWithPhotoItems:t_arr selectedIndex:0];
        [KSPhotoBrowser setImageManagerClass:KSSDImageManager.class];
        [browser setDelegate:(id<KSPhotoBrowserDelegate> _Nullable)self];
        browser.dismissalStyle      = KSPhotoBrowserInteractiveDismissalStyleScale;
        browser.backgroundStyle     = KSPhotoBrowserBackgroundStyleBlur;
        browser.loadingStyle        = KSPhotoBrowserImageLoadingStyleIndeterminate;
        browser.pageindicatorStyle  = KSPhotoBrowserPageIndicatorStyleText;
        browser.bounces             = NO;
        browser.isShowDeleteBtn     = NO;
        [browser showFromViewController:vc];
        
        
    }];
    
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
   LxPrintf(@"TakeOutSearchVC dealloc");
}

@end

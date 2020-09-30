//
//  TakeOutIllegalDetailVC.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutIllegalDetailVC.h"
#import "NSArray+MASConstraint.h"
#import "KSPhotoBrowser.h"
#import <UIButton+WebCache.h>
#import "DeliveryIllegalDetailModel.h"

@interface TakeOutIllegalDetailVC ()

@property(nonatomic,strong) TakeOutIllegalDetailViewModel * viewModel;

@property (weak, nonatomic) IBOutlet UIView * v_content;

@property (weak, nonatomic) IBOutlet UILabel * lb_reportTime;        //上报时间
@property (weak, nonatomic) IBOutlet UILabel * lb_address;           //所在位置
@property (weak, nonatomic) IBOutlet UILabel * lb_illegalType;       //违法类型
@property (weak, nonatomic) IBOutlet UILabel * lb_roadName;          //道路名称
@property (weak, nonatomic) IBOutlet UILabel * lb_remark;            //备注

@property (weak, nonatomic) IBOutlet UIView *v_photos;
@property (strong, nonatomic) NSMutableArray *arr_buttons;


@end

@implementation TakeOutIllegalDetailVC

- (instancetype)initWithViewModel:(TakeOutIllegalDetailViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr_buttons = @[].mutableCopy;
    [self configUI];
    [self bindViewModel];
    
    [self.viewModel.requestCommand execute:nil];
}

#pragma mark - configUI

- (void)configUI{
    self.title = @"违法详情";
    self.v_content.hidden = NO;
    
}


#pragma mark - bindViewModel

- (void)bindViewModel{
    
    @weakify(self);
    
    [self.viewModel.requestCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self)
        
        if (self.viewModel.model) {
            
            self.v_content.hidden = NO;
            
            self.lb_reportTime.text = [ShareFun takeStringNoNull:self.viewModel.model.illegalCollect.collectTime];
            self.lb_roadName.text = [ShareFun takeStringNoNull:self.viewModel.model.illegalCollect.roadName];
            self.lb_address.text = [ShareFun takeStringNoNull:self.viewModel.model.illegalCollect.address];
            self.lb_illegalType.text = [ShareFun takeStringNoNull:self.viewModel.model.illegalCollect.illegalType];
            self.lb_remark.text = [ShareFun takeStringNoNull:self.viewModel.model.illegalCollect.addressRemark];
            
            if (self.arr_buttons && self.arr_buttons.count == 0) {
                for (int i = 0; i < self.viewModel.model.picList.count; i++) {
                    DeliveryIllegalImageModel * imageModel = self.viewModel.model.picList[i];
                    NSString * imageUrl = imageModel.imgUrl;
                    UIButton * t_button = [[UIButton alloc] init];
                    [t_button sd_setImageWithURL:[NSURL URLWithString:imageUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
                    
                    t_button.imageView.contentMode = UIViewContentModeScaleAspectFill;
                    t_button.tag = 1000+i;
                    t_button.layer.cornerRadius = 5.f;
                    t_button.layer.masksToBounds = YES;
                    [[t_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                        @strongify(self);
                        UIButton * button = (UIButton *)x;
                        NSMutableArray *t_arr = [NSMutableArray array];
                        
                        for (int i = 0; i < self.arr_buttons.count; i++) {
                            UIButton * btn = self.arr_buttons[i];
                            DeliveryIllegalImageModel * imageModel = self.viewModel.model.picList[i];
                            NSString * imageUrl = imageModel.imgUrl;
                            KSPhotoItem *item = [KSPhotoItem itemWithSourceView:btn.imageView imageUrl:[NSURL URLWithString:imageUrl]];
                            [t_arr addObject:item];
                        }
                        
                        [self.viewModel showPhotoBrowser:t_arr inView:self.view withTag:(button.tag - 1000)];
                        
                    }];
                    [self.v_photos addSubview:t_button];
                    [self.arr_buttons addObject:t_button];
                }
                if (self.v_photos.subviews.count > 0) {
                    CGFloat height = (SCREEN_WIDTH - 30 * 2 - 2 * 24)/3;
                    [self.v_photos.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:height
                                                                       fixedLineSpacing:10 fixedInteritemSpacing:24
                                                                              warpCount:3
                                                                             topSpacing:10
                                                                          bottomSpacing:10 leadSpacing:30 tailSpacing:30];
                }
            }
            
            [self.v_content layoutIfNeeded];
            
        };
    }];
    
}


#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"TakeOutIllegalDetailVC dealloc");
}

@end

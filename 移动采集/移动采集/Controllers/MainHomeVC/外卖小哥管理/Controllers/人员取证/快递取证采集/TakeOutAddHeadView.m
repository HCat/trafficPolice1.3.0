//
//  TakeOutAddHeadView.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutAddHeadView.h"
#import "NSArray+MASConstraint.h"
#import "UIImage+Category.h"
#import "PersonLocationVC.h"
#import "TakeOutAddVC.h"
#import "BottomPickerView.h"
#import "BottomView.h"

@interface TakeOutAddHeadView()

@property (weak, nonatomic) IBOutlet UITextField * tf_order;              //配送单
@property (weak, nonatomic) IBOutlet UITextField * tf_address;              //所在位置
@property (weak, nonatomic) IBOutlet UIView *view_type;

@property (weak, nonatomic) IBOutlet UIButton *btn_personLocation; //手动定位

@property (assign, nonatomic) NSUInteger count;
@property (nonatomic, strong) NSMutableArray <UIButton *> * arr_button; //用于存储类型Button

@end


@implementation TakeOutAddHeadView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //添加对定位的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        
    }
    return self;
}


- (void)awakeFromNib {
    
    @weakify(self);
    [super awakeFromNib];
    
    self.arr_button = @[].mutableCopy;
    
    _tf_order.attributedPlaceholder   = [ShareFun highlightInString:@"请选择配送单(必选)" withSubString:@"(必选)"];
    _tf_address.attributedPlaceholder     = [ShareFun highlightInString:@"请输入所在位置(必填)" withSubString:@"(必填)"];
    
    //配置点击UITextField
    [self setUpClickUITextField:self.tf_order];
    [self setUpCommonUITextField:self.tf_address];

    [[LocationHelper sharedDefault] startLocation];
    
    _btn_personLocation.enabled = YES;
    [_btn_personLocation setBackgroundColor:DefaultBtnColor];
    
    //监听建筑垃圾类型数量
    [RACObserve(self,count) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        for (int i = 0; i < self.count; i++) {
            DeliveryIllegalTypeModel * t_dic  = self.deliveryIllegalList[i];
            
            UIButton * t_button = [[UIButton alloc] init];
            t_button.layer.cornerRadius = 5.0f;
            t_button.layer.masksToBounds = YES;
            [t_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [t_button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateNormal];
            [t_button setBackgroundImage:[UIImage imageWithColor:DefaultColor] forState:UIControlStateSelected];
            t_button.tag = 1000 + i;
            [t_button setTitleColor:UIColorFromRGB(0x999999) forState:UIControlStateNormal];
            [t_button setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
            [t_button setTitle:t_dic.illegalName forState:UIControlStateNormal];
            [[t_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                UIButton * btn = (UIButton *)x;
                NSInteger tag = btn.tag - 1000;
                btn.selected = !btn.selected;
                
                DeliveryIllegalTypeModel * t_dic  = self.deliveryIllegalList[tag];
                t_dic.isSelected = btn.selected;
                
                NSMutableArray * arr = [NSMutableArray array];
                for (DeliveryIllegalTypeModel * model in self.deliveryIllegalList) {
                    if (model.isSelected) {
                        [arr addObject:model.illegalId];
                    }
                }
                
                if (arr.count > 0) {
                    self.param.illegalType = [arr componentsJoinedByString:@","];
                }
                
            }];
            [self.view_type addSubview:t_button];
            [self.arr_button addObject:t_button];
        }
        if (self.view_type.subviews.count > 0) {
            [self.view_type.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:30.f
                                                                fixedLineSpacing:15 fixedInteritemSpacing:15
                                                                       warpCount:4
                                                                      topSpacing:15
                                                                   bottomSpacing:15 leadSpacing:15 tailSpacing:15];
        }
        
        
    }];
    
    
    //监听获取照片之后的操作
    [RACObserve(self,deliveryIllegalList) subscribeNext:^(NSArray <DeliveryIllegalTypeModel  *> * _Nullable x) {
        @strongify(self);
        
        if (x) {
            if (self.count != x.count) {
                self.count = x.count;
            }
        }
        
    }];
    
    RAC(self.param, address) = self.tf_address.rac_textSignal;
    
}

#pragma mark - 手动定位按钮事件

- (IBAction)handlebtnPersonLocationClicked:(id)sender {
    
    PersonLocationVC *t_personLocationVc = [PersonLocationVC new];
    TakeOutAddVC * t_vc = (TakeOutAddVC *)[ShareFun findViewController:self withClass:[TakeOutAddVC class]];
    [t_vc.navigationController pushViewController:t_personLocationVc animated:YES];
    WS(weakSelf);
    t_personLocationVc.block = ^(LocationStorageModel *model) {
        SW(strongSelf, weakSelf);
        strongSelf.tf_address.text     = model.address;
        strongSelf.param.address = model.address;
        
    };
    
}


- (IBAction)handlebtnCompanyListClicked:(id)sender {
    
    @weakify(self);
    [self showBottomPickViewWithTitle:@"当前配送单" items:[ShareValue sharedDefault].deliveryCompanyList block:^(NSString *title,NSString * itemId) {
        @strongify(self);
        
        self.tf_order.text = title;
        self.param.companyNo  = itemId;
        [BottomView dismissWindow];
        
    }];
    
}


#pragma mark - 重新定位之后的通知

-(void)locationChange{
    
    _tf_address.text     = [LocationHelper sharedDefault].address;
    _param.address = [LocationHelper sharedDefault].address;
    _param.lng     = @([LocationHelper sharedDefault].longitude);
    _param.lat      = @([LocationHelper sharedDefault].latitude);
    
}

#pragma mark - 配置UITextField

- (void)setUpClickUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 20, 5)];
    imageView.image = [UIImage imageNamed:@"icon_dropDownArrow.png"];
    imageView.contentMode = UIViewContentModeCenter;
    textField.rightView = imageView;
    textField.rightViewMode = UITextFieldViewModeAlways;
    [textField setDelegate:(id<UITextFieldDelegate> _Nullable)self];
    
}

- (void)setUpCommonUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}

#pragma mark - 通用显示模态PickView视图

- (void)showBottomPickViewWithTitle:(NSString *)title items:(NSArray *)items block:(void(^)(NSString *title,NSString * itemId))block{
    
    BottomPickerView *t_view = [BottomPickerView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
    t_view.pickerTitle = title;
    t_view.items = items;
    t_view.selectedCompanyBtnBlock = block;
    
    [BottomView showWindowWithBottomView:t_view];
    
}


#pragma mark - 实时监听UITextField内容的变化

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _tf_order) {
        [self handlebtnCompanyListClicked:nil];
        return NO;
    }
    
    return YES;
}


@end

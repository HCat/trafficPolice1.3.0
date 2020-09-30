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
#import "UIButton+NoRepeatClick.h"
#import "TTGTextTagCollectionView.h"

@interface TakeOutAddHeadView()

@property (weak, nonatomic) IBOutlet UITextField * tf_order;              //配送单
@property (weak, nonatomic) IBOutlet UITextField * tf_address;              //所在位置
@property (weak, nonatomic) IBOutlet UITextField *tf_remark;



@property (weak, nonatomic) IBOutlet UIView *view_type;
@property (weak, nonatomic) IBOutlet UIView * view_parent;


@property (weak, nonatomic) IBOutlet UIButton *btn_personLocation; //手动定位

@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *v_tag;

@property (assign, nonatomic) NSUInteger count;
@property (nonatomic, strong) NSMutableArray <UIButton *> * arr_button; //用于存储类型Button

@property (nonatomic, strong) NSArray < DeliveryIllegalTypeModel *> * deliveryList; //道路通用值

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
    [self setUpCommonUITextField:self.tf_remark];
    
    _v_tag.alignment = TTGTagCollectionAlignmentLeft;
    _v_tag.manualCalculateHeight = YES;
    [_v_tag setDelegate:(id<TTGTextTagCollectionViewDelegate>)self];
    TTGTextTagConfig *config = [TTGTextTagConfig new];
    config.tagTextFont = [UIFont systemFontOfSize:13];
    
    config.tagTextColor = UIColorFromRGB(0x333333);
    config.tagBackgroundColor = UIColorFromRGB(0xFFFFFF);
    config.tagSelectedTextColor = UIColorFromRGB(0xFFFFFF);
    config.tagSelectedBackgroundColor = UIColorFromRGB(0x4281E8);
    config.tagCornerRadius = 3.f;
    config.tagSelectedCornerRadius = 3.f;
    config.tagBorderWidth = 0.0f;
    config.tagSelectedBorderWidth = 0.0f;
    
    config.tagShadowColor = [UIColor clearColor];
    
    _v_tag.defaultConfig = config;

    [[LocationHelper sharedDefault] startLocation];
    
    _btn_personLocation.enabled = YES;
    [_btn_personLocation setBackgroundColor:DefaultBtnColor];
    
    //监听建筑垃圾类型数量
    [RACObserve(self,count) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        for (int i = 0; i < self.count; i++) {
            DeliveryIllegalTypeModel * t_dic  = self.deliveryIllegalList[i];
            
            UIButton * t_button = [[UIButton alloc] init];
            t_button.layer.cornerRadius = 30/2.0f;
            t_button.layer.borderWidth = 1.f;
            t_button.layer.masksToBounds = YES;
            t_button.isIgnore = YES;
            [t_button.titleLabel setFont:[UIFont systemFontOfSize:14]];
            [t_button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xeeeeee)] forState:UIControlStateNormal];
            [t_button setBackgroundImage:[UIImage imageWithColor:[UIColor whiteColor]] forState:UIControlStateSelected];
            t_button.tag = 1000 + i;
            [t_button setTitleColor:UIColorFromRGB(0x333333) forState:UIControlStateNormal];
            [t_button setTitleColor:UIColorFromRGB(0x4281E8) forState:UIControlStateSelected];
            [t_button setTitle:t_dic.illegalName forState:UIControlStateNormal];
            if (i == 0) {
                t_button.selected = YES;
                DeliveryIllegalTypeModel * model = self.deliveryIllegalList[0];
                model.isSelected = YES;
                self.deliveryList = t_dic.illegalList;
                t_button.layer.borderColor = UIColorFromRGB(0x4281E8).CGColor;
            }
            [[t_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                UIButton * btn = (UIButton *)x;
                NSInteger tag = btn.tag - 1000;
                
                if (btn.selected) {
                    return;
                }
                
                for (int i = 0; i < self.deliveryIllegalList.count; i++) {
                    
                    DeliveryIllegalTypeModel * model = self.deliveryIllegalList[i];
                    UIButton * t_button = self.arr_button[i];
                    t_button.selected = NO;
                    model.isSelected = NO;
                    t_button.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
                }
                
                btn.selected = !btn.selected;
                
                DeliveryIllegalTypeModel * t_dic  = self.deliveryIllegalList[tag];
                t_dic.isSelected = btn.selected;
                
                btn.layer.borderColor = UIColorFromRGB(0x4281E8).CGColor;
                self.deliveryList = t_dic.illegalList;
                
            }];
            [self.view_parent addSubview:t_button];
            [self.arr_button addObject:t_button];
        }
        if (self.view_parent.subviews.count > 0) {
            [self.view_parent.subviews mas_distributeSudokuViewsWithFixedItemWidth:0 fixedItemHeight:30.f
                                                                fixedLineSpacing:15 fixedInteritemSpacing:15
                                                                       warpCount:1
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
    
    
    [RACObserve(self.tf_address, text) subscribeNext:^(id  _Nullable x) {
       @strongify(self);
        if (x) {
            self.param.address = x;
        }
        
        
    }];
    
    [RACObserve(self.tf_remark, text) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (x) {
            self.param.remark = x;
        }
        
        
    }];
    
}

#pragma mark - set&&get

- (void)setDeliveryList:(NSArray<DeliveryIllegalTypeModel *> *)deliveryList{
    _deliveryList = deliveryList;
    
    [_v_tag removeAllTags];
    
    if (_deliveryList && _deliveryList.count > 0) {
        
        NSMutableArray <NSString * > * t_tag = @[].mutableCopy;
        NSMutableArray <NSNumber * > * t_tagIndexs = @[].mutableCopy;
        for (int i = 0; i < _deliveryList.count; i++) {
            
            DeliveryIllegalTypeModel * model = _deliveryList[i];
            [t_tag addObject:model.illegalName];
            if (model.isSelected) {
                [t_tagIndexs addObject:@(i)];
            }
            
        }
        
        [_v_tag addTags:t_tag];
        if (t_tagIndexs) {
            for (NSNumber *number in t_tagIndexs) {
                [_v_tag setTagAtIndex:number.integerValue selected:YES];
            }
        }
        
    }
    
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


- (void)setParam:(TakeOutSaveParam *)param{
    
    _param = param;
    
    
    
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

#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected{
    
    DeliveryIllegalTypeModel * model = _deliveryList[index];
    model.isSelected = selected;
    
    NSMutableArray * t_arr = @[].mutableCopy;
    
    for (DeliveryIllegalTypeModel * model in self.deliveryIllegalList) {
        for (DeliveryIllegalTypeModel * t_model in model.illegalList) {
            if (t_model.isSelected) {
                [t_arr addObject:t_model.illegalId];
            }
        }
    }
    
    if (t_arr.count > 0) {
        self.param.illegalType = [t_arr componentsJoinedByString:@","];
    }else{
        self.param.illegalType = nil;
    }
    
}


@end

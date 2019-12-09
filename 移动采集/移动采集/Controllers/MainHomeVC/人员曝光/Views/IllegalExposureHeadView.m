//
//  IllegalExposureHeadView.m
//  移动采集
//
//  Created by hcat on 2019/12/5.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "IllegalExposureHeadView.h"
#import "NSArray+MASConstraint.h"
#import "UIImage+Category.h"
#import "PersonLocationVC.h"
#import "LRCameraVC.h"
#import "BottomPickerView.h"
#import "BottomView.h"
#import "UIButton+NoRepeatClick.h"
#import "TTGTextTagCollectionView.h"
#import "IllegalExposureVC.h"
#import "SearchLocationVC.h"
#import "ParkCameraVC.h"

@interface IllegalExposureHeadView()

@property (weak, nonatomic) IBOutlet UITextField * tf_userName;             //姓名
@property (weak, nonatomic) IBOutlet UITextField * tf_carNo;                //车牌号
@property (weak, nonatomic) IBOutlet UITextField * tf_roadSection;

@property (weak, nonatomic) IBOutlet UITextField * tf_address;              //所在位置
@property (weak, nonatomic) IBOutlet UITextField * tf_remark;              //备注

@property (weak, nonatomic) IBOutlet UIButton *btn_identify;                //识别
@property (weak, nonatomic) IBOutlet UIButton *btn_IsHaveCar;   // 是否有车

@property (weak, nonatomic) IBOutlet UIButton *btn_switchLocation; //定位开关
@property (weak, nonatomic) IBOutlet UIButton *btn_personLocation; //手动定位
@property (nonatomic,assign) BOOL btnType; //1:代表开  0:代表关



@property (weak, nonatomic) IBOutlet UIView *view_type;
@property (weak, nonatomic) IBOutlet UIView * view_parent;


@property (weak, nonatomic) IBOutlet TTGTextTagCollectionView *v_tag;

@property (assign, nonatomic) NSUInteger count;
@property (nonatomic, strong) NSMutableArray <UIButton *> * arr_button; //用于存储类型Button

@property (nonatomic, strong) NSArray < IllegalExposureIllegalTypeModel *> * t_illegalList; //违法类型

@property(nonatomic,strong) NSArray *codes;

@end

@implementation IllegalExposureHeadView

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
    
    _tf_roadSection.attributedPlaceholder = [ShareFun highlightInString:@"请选择路段(必选)" withSubString:@"(必选)"];
    
    _tf_address.attributedPlaceholder     = [ShareFun highlightInString:@"请输入所在位置(必填)" withSubString:@"(必填)"];
    
    //配置点击UITextField

    [self setUpCommonUITextField:self.tf_userName];
    [self setUpCommonUITextField:self.tf_carNo];
    [self setUpCommonUITextField:self.tf_address];
    [self setUpCommonUITextField:self.tf_remark];


    self.btn_IsHaveCar.isIgnore = YES;
    
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
    
    
    //[[LocationHelper sharedDefault] startLocation];
    
    _btn_personLocation.enabled = YES;
    [_btn_personLocation setBackgroundColor:DefaultBtnColor];
    
    //监听建筑垃圾类型数量
    [RACObserve(self,count) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        for (int i = 0; i < self.count; i++) {
            IllegalExposureIllegalTypeModel * t_dic  = self.illegalList[i];
            
            UIButton * t_button = [[UIButton alloc] init];
            t_button.layer.cornerRadius = 5.f;
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
                IllegalExposureIllegalTypeModel * model = self.illegalList[0];
                model.isSelected = YES;
                self.t_illegalList = t_dic.exposureTypeList;
                t_button.layer.borderColor = UIColorFromRGB(0x4281E8).CGColor;
            }
            
            [[t_button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
                @strongify(self);
                
            
                UIButton * btn = (UIButton *)x;
                NSInteger tag = btn.tag - 1000;
                if (btn.selected) {
                    return;
                }
                
                for (int i = 0; i < self.illegalList.count; i++) {
                    
                    IllegalExposureIllegalTypeModel * model = self.illegalList[i];
                    UIButton * t_button = self.arr_button[i];
                    t_button.selected = NO;
                    model.isSelected = NO;
                    t_button.layer.borderColor = UIColorFromRGB(0x333333).CGColor;
                    
                }
                
                btn.selected = !btn.selected;
                
                IllegalExposureIllegalTypeModel * t_dic  = self.illegalList[tag];
                t_dic.isSelected = btn.selected;
                btn.layer.borderColor = UIColorFromRGB(0x4281E8).CGColor;
                self.t_illegalList = t_dic.exposureTypeList;
                
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
    [RACObserve(self,illegalList) subscribeNext:^(NSArray <IllegalExposureIllegalTypeModel  *> * _Nullable x) {
        @strongify(self);
        
        if (x) {
            if (self.count != x.count) {
                self.count = x.count;
            }
        }
        
    }];
    
        
    [self.tf_address.rac_textSignal subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self);
        self.param.address = x;
    }];
    
    [self.tf_userName.rac_textSignal subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self);
        self.param.userName = x;

    }];

    [self.tf_carNo.rac_textSignal subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self);
        self.param.carNo = x;

    }];
    
    [self.tf_remark.rac_textSignal subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        if (x) {
            self.param.addressRemark = x;
        }

    }];

    //默认是手动定位还是自动定位操作
    self.btnType = [LocationStorage sharedDefault].isIllegalExposure;
    //不管是手动定位还是自动定位都需要经纬度
    if ([LocationStorage sharedDefault].isIllegalExposure == NO) {
        
        LocationStorageModel * model = [LocationStorage sharedDefault].illegalExposure;
        _param.roadName      = model.streetName;
        _tf_roadSection.text = model.streetName;
        _tf_address.text     = model.address;
        _param.address       = model.address;
        [self getRoadId];

    }
    
    [[self.btn_IsHaveCar rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        self.param.remarkNoCar = @(![self.param.remarkNoCar boolValue]);
        
    }];
    
}


#pragma mark - set && get

- (NSArray *)codes{
    
    _codes = [ShareValue sharedDefault].roadModels;
    
    return _codes;
    
}

- (void)setBtnType:(BOOL)btnType{
    _btnType = btnType;
    _param.isManualPos = @(!_btnType);
    if (_btnType) {
        [_btn_switchLocation setImage:[UIImage imageNamed:@"btn_location_on"] forState:UIControlStateNormal];
        _btn_personLocation.enabled = NO;
        [_btn_personLocation setBackgroundColor:DefaultBtnNuableColor];
    }else{
        [_btn_switchLocation setImage:[UIImage imageNamed:@"btn_location_off"] forState:UIControlStateNormal];
        _btn_personLocation.enabled = YES;
        [_btn_personLocation setBackgroundColor:DefaultBtnColor];
    }
    
}


- (void)setT_illegalList:(NSArray<IllegalExposureIllegalTypeModel *> *)illegalList{
    _t_illegalList = illegalList;
    
    [_v_tag removeAllTags];
    
    for (IllegalExposureIllegalTypeModel * model in self.illegalList) {
        
        for (int i = 0; i < model.exposureTypeList.count; i++) {
            IllegalExposureIllegalTypeModel * t_model = model.exposureTypeList[i];
            if (t_model.isSelected) {
                t_model.isSelected = NO;
            }
        }
    }
    self.param.illegalType = nil;
    
    
    if (_t_illegalList && _t_illegalList.count > 0) {
        
        NSMutableArray <NSString * > * t_tag = @[].mutableCopy;
        //NSMutableArray <NSNumber * > * t_tagIndexs = @[].mutableCopy;
        for (int i = 0; i < _t_illegalList.count; i++) {
            
            IllegalExposureIllegalTypeModel * model = _t_illegalList[i];
            [t_tag addObject:model.illegalName];
//            if (model.isSelected) {
//                [t_tagIndexs addObject:@(i)];
//            }
        
        }
        
        [_v_tag addTags:t_tag];
//        if (t_tagIndexs) {
//            for (NSNumber *number in t_tagIndexs) {
//                [_v_tag setTagAtIndex:number.integerValue selected:YES];
//            }
//        }
        
    }
 
}

#pragma mark - buttonMethods

#pragma mark - 识别车牌号按钮事件

- (IBAction)handleBtnCarNumberClicked:(id)sender {
    
    @weakify(self);
    
    IllegalExposureVC * t_vc = (IllegalExposureVC *)[ShareFun findViewController:self withClass:[IllegalExposureVC class]];
    
    ParkCameraVC *home = [[ParkCameraVC alloc] init];
    home.type = 1;
    home.fininshCaptureBlock = ^(ImageFileInfo * imageInfo) {
        
        @strongify(self);
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(recognitionCarNumber:)]) {
            [self.delegate recognitionCarNumber:imageInfo];
        }
    };
    
    [t_vc presentViewController:home
                       animated:NO
                     completion:^{
                     }];
   
}


#pragma mark - 切换定位开关

- (IBAction)handleBtnSwitchLocationClicked:(id)sender {
    
    if (_btnType) {
        [[LocationStorage sharedDefault] setIsIllegalExposure:NO];
        
        LocationStorageModel * model = [LocationStorage sharedDefault].illegalExposure;
        _param.roadName      = model.streetName;
        _tf_address.text     = model.address;
        _param.address       = model.address;
        [self getRoadId];
        
    }else{
        
        [[LocationStorage sharedDefault] setIsIllegalExposure:YES];
        
        _param.longitude      = nil;
        _param.latitude       = nil;
        _param.roadId         = nil;
        _param.roadName       = nil;
        _param.address        = nil;
        _tf_address.text      = nil;
        
    }
    
    self.btnType = !_btnType;
    
    [[LocationHelper sharedDefault] startLocation];
    
   
}


#pragma mark - 手动定位按钮事件

- (IBAction)handlebtnPersonLocationClicked:(id)sender {
    
    PersonLocationVC *t_personLocationVc = [PersonLocationVC new];
    IllegalExposureVC * t_vc = (IllegalExposureVC *)[ShareFun findViewController:self withClass:[IllegalExposureVC class]];
    [t_vc.navigationController pushViewController:t_personLocationVc animated:YES];
    WS(weakSelf);
    t_personLocationVc.block = ^(LocationStorageModel *model) {
        SW(strongSelf, weakSelf);
        strongSelf.param.roadName      = model.streetName;
        strongSelf.param.address       = model.address;
        strongSelf.tf_address.text     = model.address;
        [self getRoadId];
    };
    
}


#pragma mark - 重新定位之后的通知

-(void)locationChange{
    
    if (self.btnType == 1) {
        
        _param.roadName      = [LocationHelper sharedDefault].streetName;
        _param.address       = [LocationHelper sharedDefault].address;
        _tf_address.text     = [LocationHelper sharedDefault].address;
        [self getRoadId];

    }
    _param.longitude     = @([LocationHelper sharedDefault].longitude);
    _param.latitude      = @([LocationHelper sharedDefault].latitude);
    
}

#pragma mark - 配置UITextField

- (void)setUpCommonUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 5, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}

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

#pragma mark - 通用显示模态PickView视图

- (void)showBottomPickViewWithTitle:(NSString *)title items:(NSArray *)items block:(void(^)(NSString *title,NSString * itemId))block{
    
    BottomPickerView *t_view = [BottomPickerView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
    t_view.pickerTitle = title;
    t_view.items = items;
    t_view.selectedCompanyBtnBlock = block;
    
    [BottomView showWindowWithBottomView:t_view];
    
}



#pragma mark - 选择路段按钮事件
- (IBAction)handlebtnChoiceLocationClicked:(id)sender {
    
    WS(weakSelf);
    
    SearchLocationVC *t_searchLocationvc = [SearchLocationVC new];
    t_searchLocationvc.searchType = SearchLocationTypeIllegal;
    t_searchLocationvc.arr_content = self.codes;
    t_searchLocationvc.arr_temp = self.codes;
    
    t_searchLocationvc.getRoadBlock = ^(CommonGetRoadModel *model) {
        SW(strongSelf, weakSelf);
        strongSelf.param.roadId = model.getRoadId;
        strongSelf.param.roadName = model.getRoadName;
    
    };
    
    IllegalExposureVC* t_vc = (IllegalExposureVC *)[ShareFun findViewController:self withClass:[IllegalExposureVC class]];
    [t_vc.navigationController pushViewController:t_searchLocationvc animated:YES];
    
}


#pragma mark - TTGTextTagCollectionViewDelegate

- (void)textTagCollectionView:(TTGTextTagCollectionView *)textTagCollectionView didTapTag:(NSString *)tagText atIndex:(NSUInteger)index selected:(BOOL)selected{
    
    for (int i = 0; i < self.t_illegalList.count; i++) {
        IllegalExposureIllegalTypeModel * t_model = self.t_illegalList[i];
        if (t_model.isSelected) {
            [_v_tag setTagAtIndex:i selected:NO];
            t_model.isSelected = NO;
        }
    }
    
    [_v_tag setTagAtIndex:index selected:selected];
    
    IllegalExposureIllegalTypeModel * model = _t_illegalList[index];
    model.isSelected = selected;
    
    NSMutableArray * t_arr = @[].mutableCopy;
    
    for (IllegalExposureIllegalTypeModel * model in self.illegalList) {
        for (IllegalExposureIllegalTypeModel * t_model in model.exposureTypeList) {
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


- (void)setParam:(ExposureCollectReportParam *)param{
    
    _param = param;
    
    @weakify(self);
    
    [[LocationHelper sharedDefault] startLocation];
    
    [RACObserve(self.param, carNo) subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x && x.length > 0) {
            self.tf_carNo.text = x;

        }
    }];
    
    [RACObserve(self.param, remarkNoCar) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        
        
        if ([x boolValue] == 1) {
            [self.btn_IsHaveCar setBackgroundColor:DefaultBtnNuableColor];
            [self.btn_identify setBackgroundColor:DefaultBtnColor];
            self.btn_identify.enabled = YES;
            self.tf_carNo.enabled = YES;
        }else{
            [self.btn_IsHaveCar setBackgroundColor:DefaultBtnColor];
            [self.btn_identify setBackgroundColor:DefaultBtnNuableColor];
            self.btn_identify.enabled = NO;
            self.tf_carNo.enabled = NO;
        }
    
    }];

    [RACObserve(self.param, roadName) subscribeNext:^(NSString * _Nullable x) {
         @strongify(self);
         if (x && x.length > 0) {
             self.tf_roadSection.text = x;
         }
    }];
    
    [self.tf_roadSection setDelegate:(id<UITextFieldDelegate> _Nullable)self];
   
}

#pragma mark - 通过所在路段的名字获取得到roadId

- (void)getRoadId{

    if (self.codes && self.codes.count > 0) {
        for(CommonGetRoadModel *model in self.codes){
            if ([model.getRoadName isEqualToString:_tf_roadSection.text]) {
                _param.roadId = model.getRoadId;
                break;
            }
        }
    }
    
    if (!_param.roadId) {
         _param.roadId = @0;
    }
    
}



@end

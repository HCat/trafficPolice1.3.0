//
//  AccidentInfoCell.m
//  移动采集
//
//  Created by hcat on 2018/7/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentInfoCell.h"
#import "UserModel.h"
#import "BottomPickerView.h"
#import "BottomView.h"
#import "AccidentManageVC.h"
#import "SearchLocationVC.h"
#import <UITableView+YYAdd.h>

@interface AccidentInfoCell()

//判断是否显示更多信息
@property (nonatomic,assign) BOOL isShowMoreAccidentInfo;
//判断是否是第一次加载
@property (nonatomic,assign) BOOL isFirstLoading;

//如果事故信息的登录人员是保险人员，则不显示事故成因
@property (weak, nonatomic) IBOutlet UILabel *lb_accidentCauses;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_accidentCauses;

//事故信息里面的更多信息按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_moreAccidentInfo;


//点击事故信息更多信息将要显示或者隐藏的UILabel 和 UIView 主要为：受伤人数 和 道路类型
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lb_moreAccidentInfos;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *v_moreAccidentInfos;


@property (weak, nonatomic) IBOutlet UITextField *tf_accidentCauses;    //事故成因(必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_accidentTime;      //事故时间(必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_location;          //所在位置(必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_accidentAddress;   //事故地址(必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_weather;           //天气情况
@property (weak, nonatomic) IBOutlet UITextField *tf_injuriesNumber;    //受伤人数
@property (weak, nonatomic) IBOutlet UITextField *tf_roadType;          //道路类型


@property (strong, nonatomic) AccidentGetCodesResponse *codes; 

@end


@implementation AccidentInfoCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //添加对定位的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        
        self.isFirstLoading = YES;
        
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.isShowMoreAccidentInfo = NO;
    if ([UserModel getUserModel].isInsurance) {
        self.lb_accidentCauses.hidden = YES;
        self.tf_accidentCauses.hidden = YES;
        self.layout_accidentCauses.constant = 45.f;
        [self layoutIfNeeded];
    }
    
    [self setUpCommonUI];
    

}

#pragma mark - 配置UI

- (void)setUpCommonUI{
    
    //设置UITextField的Placeholder高亮来提示哪些是需要输入的
    _tf_accidentCauses.attributedPlaceholder = [ShareFun highlightInString:@"请选择事故成因(必选)" withSubString:@"(必选)"];
    _tf_accidentTime.attributedPlaceholder = [ShareFun highlightInString:@"请输入事故时间(必填)" withSubString:@"(必填)"];
    _tf_location.attributedPlaceholder = [ShareFun highlightInString:@"请选择位置(必选)" withSubString:@"(必选)"];
    _tf_accidentAddress.attributedPlaceholder = [ShareFun highlightInString:@"请输入事故地点(必填)" withSubString:@"(必填)"];
    
    //配置点击UITextField
    [self setUpClickUITextField:self.tf_accidentCauses];
    [self setUpClickUITextField:self.tf_location];
    [self setUpClickUITextField:self.tf_injuriesNumber];
    [self setUpClickUITextField:self.tf_roadType];
    
    //配置通用UITextField
    [self setUpCommonUITextField:self.tf_accidentTime];
    [self setUpCommonUITextField:self.tf_accidentAddress];
    [self setUpCommonUITextField:self.tf_weather];
    
    //事故信息里面添加对UITextField的监听
    [self addChangeForEventEditingChanged:self.tf_accidentTime];
    [self addChangeForEventEditingChanged:self.tf_accidentAddress];
    [self addChangeForEventEditingChanged:self.tf_weather];
    

}

#pragma mark - set

- (void)setIsShowMoreAccidentInfo:(BOOL)isShowMoreAccidentInfo{
    
    _isShowMoreAccidentInfo = isShowMoreAccidentInfo;
    
    if (_isShowMoreAccidentInfo) {
        
        WS(weakSelf);
        
       
        SW(strongSelf, weakSelf);
        for (UILabel *t_label in strongSelf.lb_moreAccidentInfos) {
            
            CATransition *animation = [CATransition animation];
            animation.type = kCATransitionFade;
            animation.duration = 0.8f;
            [t_label.layer addAnimation:animation forKey:nil];
            t_label.hidden = NO;
            
        }
        for (UIView *t_v in strongSelf.v_moreAccidentInfos) {
            CATransition *animation = [CATransition animation];
            animation.type = kCATransitionFade;
            animation.duration = 0.8f;
            [t_v.layer addAnimation:animation forKey:nil];
            t_v.hidden = NO;

        }
        
        
        
    }else{
        
        for (UILabel *t_label in _lb_moreAccidentInfos) {
            t_label.hidden = YES;
        }
        for (UIView *t_v in _v_moreAccidentInfos) {
            t_v.hidden = YES;
        }
        
    }
    
}

- (void)setAccidentType:(AccidentType)accidentType{
    
    _accidentType = accidentType;
    
    //快处事故的UI处理
    if (_accidentType == AccidentTypeFastAccident){
        
        self.isShowMoreAccidentInfo       = NO;
        self.btn_moreAccidentInfo.hidden  = YES;
    
    }
}

- (void)setPartyFactory:(AccidentUpFactory *)partyFactory{
    
    _partyFactory = partyFactory;
    
    if (_isFirstLoading) {
        
        //重新定位下
        [[LocationHelper sharedDefault] startLocation];
        
        //获取当前事故时间
        _tf_accidentTime.text = [ShareFun getCurrentTime];
        self.partyFactory.param.happenTimeStr = [ShareFun getCurrentTime];
        
        self.isFirstLoading = NO;
    }
    
}

#pragma mark - get

- (AccidentGetCodesResponse *)codes{
    
    _codes = [ShareValue sharedDefault].accidentCodes;
    
    return _codes;
}

#pragma mark - 数据请求部分

- (void) getServerData{
    
    //获取当前天气
    WS(weakSelf);
    CommonGetWeatherManger *manger = [CommonGetWeatherManger new];
    manger.isNoShowFail = YES;
    manger.location = [[NSString stringWithFormat:@"%f,%f",[LocationHelper sharedDefault].longitude,[LocationHelper sharedDefault].latitude] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.tf_weather.text = manger.weather.weather;
            strongSelf.partyFactory.param.weather = manger.weather.weather;
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - public

- (CGFloat)heightOfCell{
    
    CGFloat height = 0;
    
    if ([UserModel getUserModel].isInsurance) {
        
        height += 233.f;
    }else{
        height += 275.f;
    }
    
    if(self.isShowMoreAccidentInfo){
        
        height += 85;
    }
    
    return height;
    
    
}



#pragma mark - 按钮事件

#pragma mark - 事故信息的更多信息按钮点击

- (IBAction)handleBtnMoreAccidentInfoClicked:(id)sender {
    
    [[ShareFun getTableView:self] beginUpdates];
    self.isShowMoreAccidentInfo = !_isShowMoreAccidentInfo;
    [[ShareFun getTableView:self] endUpdates];
    
    [[ShareFun getTableView:self] scrollToRow:1 inSection:0 atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    
}


#pragma mark - 重新定位按钮点击

- (IBAction)handleBtnLocationClicked:(id)sender {
    _tf_location.text = nil;
    [_partyFactory setRoadId:nil];
    _partyFactory.param.roadName = nil;
    [self.partyFactory juegeCanCommit];
    [[LocationHelper sharedDefault] startLocation];
    
}


#pragma mark - 事故成因按钮点击

- (IBAction)handleBtnAccidentCausesClicked:(id)sender {
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"事故成因" items:self.codes.cause block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        
        SW(strongSelf, weakSelf);
        strongSelf.tf_accidentCauses.text = title;
        strongSelf.partyFactory.param.causesType  = @(itemId);
        [self.partyFactory juegeCanCommit];
        [BottomView dismissWindow];
        
    }];
    
}

#pragma mark - 所在位置按钮点击

- (IBAction)handleBtnChoiceLocationClicked:(id)sender {
    
    AccidentManageVC *t_vc = (AccidentManageVC *)[ShareFun findViewController:self withClass:[AccidentManageVC class]];
    SearchLocationVC *t_searchLocationvc = [SearchLocationVC new];
    t_searchLocationvc.searchType = SearchLocationTypeAccident;
    t_searchLocationvc.arr_content = self.codes.road;
    t_searchLocationvc.arr_temp = self.codes.road;
    
    WS(weakSelf);
    t_searchLocationvc.searchLocationBlock = ^(AccidentGetCodesModel *model) {
        SW(strongSelf, weakSelf);
        strongSelf.tf_location.text = model.modelName;
        strongSelf.partyFactory.param.roadId = @(model.modelId);
        [strongSelf.partyFactory juegeCanCommit];
    };
    [t_vc.navigationController pushViewController:t_searchLocationvc animated:YES];
    
}

#pragma mark - 受伤人数按钮点击

- (IBAction)handleBtnInjuryNumberClicked:(id)sender {
    WS(weakSelf);
    
    NSArray *items = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10"];
    BottomPickerView *t_view = [BottomPickerView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
    t_view.pickerTitle = @"受伤人数";
    t_view.items = items;
    t_view.selectedBtnBlock = ^(NSArray *items, NSInteger index) {
        SW(strongSelf, weakSelf);
        NSString * number = items[index];
        strongSelf.tf_injuriesNumber.text = number;
        strongSelf.partyFactory.param.injuredNum  = number;
        
        [BottomView dismissWindow];
    };
    
    [BottomView showWindowWithBottomView:t_view];
    
}

#pragma mark - 道路类型按钮点击

- (IBAction)handleBtnRoadTypeClicked:(id)sender {
    
    WS(weakSelf);
    
    [self showBottomPickViewWithTitle:@"道路类型" items:self.codes.roadType block:^(NSString *title, NSInteger itemId, NSInteger itemType) {
        SW(strongSelf, weakSelf);
        strongSelf.tf_roadType.text = title;
        strongSelf.partyFactory.param.roadType  = @(itemType);
        
        [BottomView dismissWindow];
        
    }];
    
    
}


#pragma mark - 定位成功的通知

-(void)locationChange{
    //这里待优化
    _tf_location.text = [LocationHelper sharedDefault].streetName;
    [_partyFactory setRoadId:[LocationHelper sharedDefault].streetName];
    _partyFactory.param.roadName = [LocationHelper sharedDefault].streetName;
    
    if(_partyFactory.param.weather || _partyFactory.param.weather.length == 0){
        //异步请求即将用到数据
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self getServerData];
        });
        
    }
    
    [self.partyFactory juegeCanCommit];
    
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


#pragma mark - 实时监听UITextField内容的变化

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _tf_accidentCauses) {
        [self handleBtnAccidentCausesClicked:nil];
        return NO;
    }
    
    if (textField == _tf_location) {
        [self handleBtnChoiceLocationClicked:nil];
        return NO;
    }
    
    if (textField == _tf_injuriesNumber) {
        [self handleBtnInjuryNumberClicked:nil];
        return NO;
    }
    
    if (textField == _tf_roadType) {
        [self handleBtnRoadTypeClicked:nil];
        return NO;
    }
    
    return YES;
}



#pragma mark - 添加监听Textfield的变化，用于给参数实时赋值

- (void)addChangeForEventEditingChanged:(UITextField *)textField{
    [textField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}


-(void)passConTextChange:(id)sender{
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    NSInteger length =  textField.text.length;
    if (textField == _tf_accidentTime) {
        _partyFactory.param.happenTimeStr = length > 0 ? _tf_accidentTime.text : nil;
    }
    
    if (textField == _tf_accidentAddress) {
        _partyFactory.param.address = length > 0 ? _tf_accidentAddress.text : nil;
    }
    
    if (textField == _tf_weather) {
        _partyFactory.param.weather = length > 0 ? _tf_weather.text : nil;
    }
    
    [self.partyFactory juegeCanCommit];
    
    
}

#pragma mark - 通用显示模态PickView视图

- (void)showBottomPickViewWithTitle:(NSString *)title items:(NSArray *)items block:(void(^)(NSString *title, NSInteger itemId, NSInteger itemType))block{
    
    BottomPickerView *t_view = [BottomPickerView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
    t_view.pickerTitle = title;
    t_view.items = items;
    t_view.selectedAccidentBtnBlock = block;
    
    [BottomView showWindowWithBottomView:t_view];
    
}

- (void)handleBeforeCommit{
    
    _isFirstLoading = YES;
    _tf_accidentCauses.text = nil;    //事故成因(必填)
    _tf_accidentTime.text = nil;      //事故时间(必填)
    _tf_location.text = nil;          //所在位置(必填)
    _tf_accidentAddress.text = nil;   //事故地址(必填)
    _tf_weather.text = nil;           //天气情况
    _tf_injuriesNumber.text = nil;    //受伤人数
    _tf_roadType.text = nil;          //道路类型
    
}


#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"AccidentInfoCell dealloc");
    
}

@end

//
//  VehicleUpBasicInfoCell.m
//  移动采集
//
//  Created by hcat on 2018/5/15.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpBasicInfoCell.h"
#import "LRCameraVC.h"
#import "VehicleUpVC.h"
#import "CertificateView.h"
#import "BottomView.h"
#import "SearchLocationVC.h"
#import "PersonLocationVC.h"

@interface VehicleUpBasicInfoCell()

@property (weak, nonatomic) IBOutlet UITextField *tf_carNumber;         //车牌号
@property (weak, nonatomic) IBOutlet UITextField *tf_name;              //驾驶员姓名(甲方必填)
@property (weak, nonatomic) IBOutlet UITextField *tf_identityCard;      //驾驶员身份证
@property (weak, nonatomic) IBOutlet UITextField *tf_roadSection;       //选择路段
@property (weak, nonatomic) IBOutlet UITextField *tf_address;           //所在位置

@property (weak, nonatomic) IBOutlet UIButton *btn_switchLocation; //定位开关
@property (weak, nonatomic) IBOutlet UIButton *btn_personLocation; //手动定位

@property (nonatomic,assign) BOOL btnType; //1:代表开  0:代表关

@property(nonatomic,strong) NSArray *codes;

@end


@implementation VehicleUpBasicInfoCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //添加对定位的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        
    }
    return self;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    
    _tf_carNumber.attributedPlaceholder    = [ShareFun highlightInString:@"请输入车牌号(必填)" withSubString:@"(必填)"];
    _tf_name.attributedPlaceholder         = [ShareFun highlightInString:@"请输入名字(必填)" withSubString:@"(必填)"];
    _tf_identityCard.attributedPlaceholder = [ShareFun highlightInString:@"请输入身份证号(必填)" withSubString:@"(必填)"];
    _tf_roadSection.attributedPlaceholder  = [ShareFun highlightInString:@"请选择路段(必选)" withSubString:@"(必选)"];
    _tf_address.attributedPlaceholder      = [ShareFun highlightInString:@"请输入所在位置(必填)" withSubString:@"(必填)"];
    
    
    [self addChangeForEventEditingChanged:_tf_carNumber];
    [self addChangeForEventEditingChanged:_tf_name];
    [self addChangeForEventEditingChanged:_tf_identityCard];
    [self addChangeForEventEditingChanged:_tf_address];
    
    //配置点击UITextField
    [self setUpClickUITextField:_tf_roadSection];
    //配置通用UITextField
    [self setUpCommonUITextField:_tf_carNumber];
    [self setUpCommonUITextField:_tf_name];
    [self setUpCommonUITextField:_tf_identityCard];
    [self setUpCommonUITextField:_tf_address];
    
}


#pragma mark - set&&get

- (void)setParam:(VehicleCarlUpParam *)param{
    
    _param = param;

    if (_param) {
        _tf_carNumber.text      = _param.plateNo;
        _tf_name.text           = _param.driver;
        _tf_identityCard.text   = _param.idCardNum;
    
    }
    
}

- (void)setBtnType:(BOOL)btnType{
    _btnType = btnType;
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

- (NSArray *)codes{
    
    _codes = [ShareValue sharedDefault].roadModels;
    
    return _codes;
    
}

#pragma mark - public

- (void)startLocation{
    
    self.btnType = [LocationStorage sharedDefault].isVehicle;
    
    if ([LocationStorage sharedDefault].isVehicle) {
        [[LocationHelper sharedDefault] startLocation];
    }else{
        [self stopLocationAction:[LocationStorage sharedDefault].vehicle];
    }
}

#pragma mark - buttonMethods

#pragma mark - 识别车牌号按钮事件

- (IBAction)handleBtnCarNumberClicked:(id)sender {

    WS(weakSelf);
    
    VehicleUpVC *up_vc = (VehicleUpVC *)[ShareFun findViewController:self withClass:[VehicleUpVC class]];
    
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = 1;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        
        if (camera) {
            
            SW(strongSelf, weakSelf);
            
            if (camera.type == 1) {
                
                if (camera.commonIdentifyResponse) {
                    
                   strongSelf.tf_carNumber.text  = camera.commonIdentifyResponse.carNo;
                   strongSelf.param.plateNo = camera.commonIdentifyResponse.carNo;
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_JUDEGECOMMIT object:nil userInfo:nil];
                    
                }
                
            }
        }
    };
    
    [up_vc presentViewController:home
                       animated:NO
                     completion:^{
                     }];
    
}

#pragma mark - 姓名识别按钮点击

- (IBAction)handleBtnNameIdentifyClicked:(id)sender {
    
    WS(weakSelf);
    //调用身份证和驾驶证模态视图
    CertificateView *t_view = [CertificateView initCustomView];
    [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 103)];
    t_view.identityCardBlock = ^(){
        LxPrintf(@"身份证点击");
        SW(strongSelf, weakSelf);
        
        //UIView获取UIViewController,来弹出LRCameraVC拍照，拍照完之后调用fininshCaptureBlock
        VehicleUpVC *t_vc = (VehicleUpVC *)[ShareFun findViewController:self withClass:[VehicleUpVC class]];
        LRCameraVC *home = [[LRCameraVC alloc] init];
        home.isAccident = YES;
        home.type = 2;
        home.fininshCaptureBlock = ^(LRCameraVC *camera) {
            if (camera) {
                if (camera.type == 2) {
                    strongSelf.tf_name.text = camera.commonIdentifyResponse.name;
                    strongSelf.tf_identityCard.text = camera.commonIdentifyResponse.idNo;
                    strongSelf.param.driver = camera.commonIdentifyResponse.name;
                    strongSelf.param.idCardNum = camera.commonIdentifyResponse.idNo;
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_JUDEGECOMMIT object:nil userInfo:nil];
                }
            }
        };
        [t_vc presentViewController:home
                           animated:NO
                         completion:^{
                         }];
        
        [BottomView dismissWindow];
        
    };
    t_view.drivingLicenceBlock = ^(){
        
        LxPrintf(@"驾驶证点击");
        SW(strongSelf, weakSelf);
        VehicleUpVC *t_vc = (VehicleUpVC *)[ShareFun findViewController:self withClass:[VehicleUpVC class]];
        LRCameraVC *home = [[LRCameraVC alloc] init];
        home.isAccident = YES;
        home.type = 3;
        home.fininshCaptureBlock = ^(LRCameraVC *camera) {
            if (camera) {
                if (camera.type == 3) {
                    strongSelf.tf_name.text = camera.commonIdentifyResponse.name;
                    strongSelf.tf_identityCard.text = camera.commonIdentifyResponse.idNo;
                    strongSelf.param.driver = camera.commonIdentifyResponse.name;
                    strongSelf.param.idCardNum = camera.commonIdentifyResponse.idNo;
                    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_JUDEGECOMMIT object:nil userInfo:nil];
                }
            }
        };
        [t_vc presentViewController:home
                           animated:NO
                         completion:^{
                         }];
        
        [BottomView dismissWindow];
        
    };
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
        strongSelf.tf_roadSection.text = model.getRoadName;
        strongSelf.param.roadId = model.getRoadId;
        strongSelf.param.road = model.getRoadName;
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_JUDEGECOMMIT object:nil userInfo:nil];
   
    };
    VehicleUpVC *t_vc = (VehicleUpVC *)[ShareFun findViewController:self withClass:[VehicleUpVC class]];
    [t_vc.navigationController pushViewController:t_searchLocationvc animated:YES];
   
    
}

#pragma mark - 切换定位开关

- (IBAction)handleBtnSwitchLocationClicked:(id)sender {
    
    if (_btnType) {
        
        [[LocationStorage sharedDefault] setIsVehicle:NO];
        
        [self stopLocationAction:[LocationStorage sharedDefault].vehicle];
        
    }else{
        
        [[LocationStorage sharedDefault] setIsVehicle:YES];
        
        [self handlebtnLocationClicked:nil];
    }
    
    self.btnType = !_btnType;
    
    
}

- (IBAction)handlebtnLocationClicked:(id)sender {
    
    _tf_roadSection.text  = nil;
    _tf_address.text      = nil;
    
    _param.roadId         = nil;
    _param.road       = nil;
    _param.position        = nil;

    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_JUDEGECOMMIT object:nil userInfo:nil];
    
    [[LocationHelper sharedDefault] startLocation];
    
}


#pragma mark - 手动定位按钮事件

- (IBAction)handlebtnPersonLocationClicked:(id)sender {
    
    VehicleUpVC *t_vc = (VehicleUpVC *)[ShareFun findViewController:self withClass:[VehicleUpVC class]];
    PersonLocationVC *t_personLocationVc = [PersonLocationVC new];
    [t_vc.navigationController pushViewController:t_personLocationVc animated:YES];
    WS(weakSelf);
    t_personLocationVc.block = ^(LocationStorageModel *model) {
        SW(strongSelf, weakSelf);
        [strongSelf stopLocationAction:model];
    };
    
}

#pragma mark - 添加监听Textfield的变化，用于给参数实时赋值

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    if (textField == _tf_roadSection) {
        [self handlebtnChoiceLocationClicked:nil];
        return NO;
    }

    return YES;
}


- (void)addChangeForEventEditingChanged:(UITextField *)textField{
    [textField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

-(void)passConTextChange:(id)sender{
    
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    NSInteger length =  textField.text.length;
    
    if (textField == _tf_carNumber) {
        _param.plateNo = length > 0 ? _tf_carNumber.text : nil;
    }
    
    if (textField == _tf_name) {
        _param.driver = length > 0 ? _tf_name.text : nil;
    }
    
    if (textField == _tf_identityCard) {
        _param.idCardNum = length > 0 ? _tf_identityCard.text : nil;
    }

    if (textField == _tf_address) {
        _param.position = length > 0 ? _tf_address.text : nil;
    }
    
     [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_JUDEGECOMMIT object:nil userInfo:nil];
    
    
}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    _tf_roadSection.text = [LocationHelper sharedDefault].streetName;
    _tf_address.text     = [LocationHelper sharedDefault].address;
  
    _param.road      = [LocationHelper sharedDefault].streetName;
    _param.position       = [LocationHelper sharedDefault].address;
    [self getRoadId];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_JUDEGECOMMIT object:nil userInfo:nil];
}

#pragma mark - 关闭定位之后所做的赋值操作

- (void)stopLocationAction:(LocationStorageModel *)model{
    
    _tf_roadSection.text = model.streetName;
    _tf_address.text     = model.address;
    
    _param.road      = model.streetName;
    _param.position       = model.address;
    [self getRoadId];
  
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_JUDEGECOMMIT object:nil userInfo:nil];
    
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

#pragma mark - 通过所在路段的名字获取得到roadId

- (void)getRoadId{
    
    _param.roadId = nil;
    if (self.codes && self.codes.count > 0) {
        for(CommonGetRoadModel *model in self.codes){
            if ([model.getRoadName isEqualToString:_tf_roadSection.text]) {
                _param.roadId = model.getRoadId;
                break;
            }
        }
    }
        
}


#pragma mark - dealloc

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self ];
    LxPrintf(@"VehicleUpBasicInfoCell dealloc");
    
}

@end

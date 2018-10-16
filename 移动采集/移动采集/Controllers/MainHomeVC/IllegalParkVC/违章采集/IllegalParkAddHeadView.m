//
//  IllegalParkAddHeadView.m
//  trafficPolice
//
//  Created by hcat on 2017/5/31.
//  Copyright © 2017年 Degal. All rights reserved.
//

#import "IllegalParkAddHeadView.h"

#import "IllegalParkVC.h"
#import "CarInfoAddVC.h"
#import "SearchLocationVC.h"
#import "PersonLocationVC.h"

@interface IllegalParkAddHeadView()

@property (weak, nonatomic) IBOutlet UITextField *tf_carNumber;         //车牌号
@property (weak, nonatomic) IBOutlet UITextField *tf_roadSection;       //选择路段
@property (weak, nonatomic) IBOutlet UITextField *tf_address;           //所在位置
@property (weak, nonatomic) IBOutlet UITextField *tf_addressRemarks;    //地址备注

@property (weak, nonatomic) IBOutlet UIButton *btn_switchLocation; //定位开关
@property (weak, nonatomic) IBOutlet UIButton *btn_personLocation; //手动定位
@property (nonatomic,assign) BOOL btnType; //1:代表开  0:代表关



@property (nonatomic,assign) NSInteger length;                          //textField的长度，用于判断说如果执行两次相同长度的textField监听
@property (nonatomic,assign,readwrite) BOOL isCanCommit;

@property(nonatomic,strong) NSArray *codes;

@end

@implementation IllegalParkAddHeadView

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
    
    _tf_carNumber.attributedPlaceholder   = [ShareFun highlightInString:@"请输入车牌号(必填)" withSubString:@"(必填)"];

    _tf_roadSection.attributedPlaceholder = [ShareFun highlightInString:@"请选择路段(必选)" withSubString:@"(必选)"];

    _tf_address.attributedPlaceholder     = [ShareFun highlightInString:@"请输入所在位置(必填)" withSubString:@"(必填)"];
  
    
    [self addChangeForEventEditingChanged:_tf_carNumber];
    [self addChangeForEventEditingChanged:_tf_address];
    [self addChangeForEventEditingChanged:_tf_addressRemarks];
    
}

#pragma mark - set && get 

- (NSArray *)codes{
    
    _codes = [ShareValue sharedDefault].roadModels;
    
    return _codes;
    
}

- (void)setSubType:(ParkType)subType{
    _subType = subType;
    
    if (_subType == ParkTypePark) {
        
        self.btnType = [LocationStorage sharedDefault].isPark;
        
        [[LocationHelper sharedDefault] startLocation];
        
        if ([LocationStorage sharedDefault].isPark == NO) {
            [self stopLocationAction:[LocationStorage sharedDefault].park];
        }
        
    }else if (_subType == ParkTypeReversePark){
        
        self.btnType = [LocationStorage sharedDefault].isTowardError;
        
        [[LocationHelper sharedDefault] startLocation];
        
        if ([LocationStorage sharedDefault].isTowardError == NO) {
            [self stopLocationAction:[LocationStorage sharedDefault].towardError];
        }
        
    }else if (_subType == ParkTypeLockPark){
        
         self.btnType = [LocationStorage sharedDefault].isLockCar;
         [[LocationHelper sharedDefault] startLocation];
        
        if ([LocationStorage sharedDefault].isLockCar == NO) {
            [self stopLocationAction:[LocationStorage sharedDefault].lockCar];
        }
        
    }else if (_subType == ParkTypeCarInfoAdd){
        
         self.btnType = [LocationStorage sharedDefault].isInforInput;
         [[LocationHelper sharedDefault] startLocation];
        
        if ([LocationStorage sharedDefault].isInforInput == NO) {
            [self stopLocationAction:[LocationStorage sharedDefault].inforInput];
        }
        
    }else if (_subType == ParkTypeThrough){
        
         self.btnType = [LocationStorage sharedDefault].isThrough;
         [[LocationHelper sharedDefault] startLocation];
        
        if ([LocationStorage sharedDefault].isThrough == NO) {
            [self stopLocationAction:[LocationStorage sharedDefault].through];
        }
        
    }
    
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


#pragma mark - buttonMethods

#pragma mark - 识别车牌号按钮事件

- (IBAction)handleBtnCarNumberClicked:(id)sender {
    
    WS(weakSelf);
    
    UIViewController *t_vc = nil;
    
    if (_subType != ParkTypeCarInfoAdd) {
        t_vc = (IllegalParkVC *)[ShareFun findViewController:self withClass:[IllegalParkVC class]];
    }else{
        t_vc = (CarInfoAddVC *)[ShareFun findViewController:self withClass:[CarInfoAddVC class]];
        
    }
    
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = 1;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        
        if (camera) {
            
            SW(strongSelf, weakSelf);
            
            if (camera.type == 1) {
                
                if (camera.commonIdentifyResponse) {
                    [strongSelf takePhotoToDiscernmentWithCarNumber:camera.commonIdentifyResponse.carNo withCarcolor:camera.carColor];
                }
            
                if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(recognitionCarNumber:)]) {
                    [strongSelf.delegate recognitionCarNumber:camera];
                }
            
            }
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
        [[LocationStorage sharedDefault] closeLocation:_subType];
        if (_subType == ParkTypePark) {
            [self stopLocationAction:[LocationStorage sharedDefault].park];
        }else if (_subType == ParkTypeReversePark){
            [self stopLocationAction:[LocationStorage sharedDefault].towardError];
        }else if (_subType == ParkTypeLockPark){
            [self stopLocationAction:[LocationStorage sharedDefault].lockCar];
        }else if (_subType == ParkTypeCarInfoAdd){
            [self stopLocationAction:[LocationStorage sharedDefault].inforInput];
        }else if (_subType == ParkTypeThrough){
            [self stopLocationAction:[LocationStorage sharedDefault].through];
        }
        
    }else{
        [[LocationStorage sharedDefault] startLocation:_subType];
        [self handlebtnLocationClicked:nil];
    }
    
    self.btnType = !_btnType;
    
    [[LocationHelper sharedDefault] startLocation];
    
   
}

#pragma mark - 重新定位按钮事件
- (IBAction)handlebtnLocationClicked:(id)sender {
    
    _tf_roadSection.text  = nil;
    _tf_address.text      = nil;
    
    _param.longitude      = nil;
    _param.latitude       = nil;
    _param.roadId         = nil;
    _param.roadName       = nil;
    _param.address        = nil;
    
    self.isCanCommit =  [self juegeCanCommit];
    
}

#pragma mark - 手动定位按钮事件

- (IBAction)handlebtnPersonLocationClicked:(id)sender {
    
    PersonLocationVC *t_personLocationVc = [PersonLocationVC new];
    if (_subType == ParkTypeCarInfoAdd) {
        CarInfoAddVC* t_vc = (CarInfoAddVC *)[ShareFun findViewController:self withClass:[CarInfoAddVC class]];
        [t_vc.navigationController pushViewController:t_personLocationVc animated:YES];
    }else{
        IllegalParkVC *t_vc = (IllegalParkVC *)[ShareFun findViewController:self withClass:[IllegalParkVC class]];
        [t_vc.navigationController pushViewController:t_personLocationVc animated:YES];
    }
    WS(weakSelf);
    t_personLocationVc.block = ^(LocationStorageModel *model) {
        SW(strongSelf, weakSelf);
        [strongSelf stopLocationAction:model];

    };

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
        strongSelf.param.roadName = model.getRoadName;
        
        // 判断是否可以提交
        strongSelf.isCanCommit =  [strongSelf juegeCanCommit];
        
        //当为闯禁令的时候，需要去请求是否有一次闯禁令数据，因为请求是需要地址的，所以这里需要进行监听
        if (strongSelf.delegate && [strongSelf.delegate respondsToSelector:@selector(listentCarNumber)]) {
           
            [strongSelf.delegate listentCarNumber];
        }
        
    };
    
    if (_subType == ParkTypeCarInfoAdd) {
        CarInfoAddVC* t_vc = (CarInfoAddVC *)[ShareFun findViewController:self withClass:[CarInfoAddVC class]];
        [t_vc.navigationController pushViewController:t_searchLocationvc animated:YES];
    }else{
        IllegalParkVC *t_vc = (IllegalParkVC *)[ShareFun findViewController:self withClass:[IllegalParkVC class]];
        [t_vc.navigationController pushViewController:t_searchLocationvc animated:YES];
    }
    
}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    
    
    if (self.btnType == 1) {
        
        _tf_roadSection.text = [LocationHelper sharedDefault].streetName;
        _tf_address.text     = [LocationHelper sharedDefault].address;
        _param.roadName      = [LocationHelper sharedDefault].streetName;
        _param.address       = [LocationHelper sharedDefault].address;
        
        [self getRoadId];
        
    }

    _param.longitude     = @([LocationHelper sharedDefault].longitude);
    _param.latitude      = @([LocationHelper sharedDefault].latitude);
    
    self.isCanCommit =  [self juegeCanCommit];
    
    //当为闯禁令的时候，需要去请求是否有一次闯禁令数据，因为请求是需要地址的，所以这里需要进行监听
    if (self.delegate && [self.delegate respondsToSelector:@selector(listentCarNumber)]) {
        [self.delegate listentCarNumber];
    }
    
}

#pragma mark - 关闭定位之后所做的赋值操作

- (void)stopLocationAction:(LocationStorageModel *)model{
    
    _tf_roadSection.text = model.streetName;
    _tf_address.text     = model.address;
    
//    _param.longitude     = model.longitude;
//    _param.latitude      = model.latitude;
    _param.roadName      = model.streetName;
    _param.address       = model.address;
    [self getRoadId];
    
    self.isCanCommit =  [self juegeCanCommit];
    
    //当为闯禁令的时候，需要去请求是否有一次闯禁令数据，因为请求是需要地址的，所以这里需要进行监听
    if (self.delegate && [self.delegate respondsToSelector:@selector(listentCarNumber)]) {
        [self.delegate listentCarNumber];
    }
    
}

#pragma mark  - 存储停止定位位置

- (LocationStorageModel *)configurationLocationStorageModel{

    LocationStorageModel * model = [[LocationStorageModel alloc] init];
    model.streetName    = _param.roadName;
    model.address       = _param.address;
    
    return model;
    
    
}

#pragma mark - 添加监听Textfield的变化，用于给参数实时赋值

- (void)addChangeForEventEditingChanged:(UITextField *)textField{
    [textField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
}

#pragma mark - 实时监听UITextField内容的变化

-(void)passConTextChange:(id)sender{
    
    
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    NSInteger length =  textField.text.length;

    if (textField == _tf_carNumber) {
        _param.carNo = length > 0 ? _tf_carNumber.text : nil;
        
        if (_length == length) {
            return;
        }
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(listentCarNumber)]) {
            [self.delegate listentCarNumber];
        }
    }
    
    if (textField == _tf_address) {
        _param.address = length > 0 ? _tf_address.text : nil;
    }
    
    if (textField == _tf_addressRemarks) {
        _param.addressRemark = length > 0 ? _tf_addressRemarks.text : nil;
        
    }
    
    self.length = length;
    
    self.param.longitude = @118.1776085069444 ;
    self.param.latitude = @24.4915185546875;
   
    self.isCanCommit = [self juegeCanCommit];
    
}




#pragma mark - 判断是否可以提交

-(BOOL)juegeCanCommit{
    
    LxDBObjectAsJson(self.param);
    if (_param.address.length >0 && _param.roadId && _param.carNo.length > 0 && _param.latitude && _param.longitude){
        return YES;
    }else{
        return NO;
    }
    
}

#pragma mark  - public

#pragma mark - 拍照识别车牌照片之后做的处理

- (void)takePhotoToDiscernmentWithCarNumber:(NSString *)carNummber withCarcolor:(NSString *)carColor{

    _tf_carNumber.text  = carNummber;
    _param.carNo        = carNummber;
    if (carColor) {
        _param.carColor = carColor;
    }
    
    self.isCanCommit = [self juegeCanCommit];
}

#pragma mark - 提交之后headView存储地址的处理

- (void)strogeLocationBeforeCommit{
    
    if (_subType == ParkTypePark) {
        [[LocationStorage sharedDefault] setPark:[self configurationLocationStorageModel]];
        
    }else if (_subType == ParkTypeReversePark){
        [[LocationStorage sharedDefault] setTowardError:[self configurationLocationStorageModel]];
       
    }else if (_subType == ParkTypeLockPark){
        [[LocationStorage sharedDefault] setLockCar:[self configurationLocationStorageModel]];
       
    }else if (_subType == ParkTypeCarInfoAdd){
        [[LocationStorage sharedDefault] setInforInput:[self configurationLocationStorageModel]];
       
    }else if (_subType == ParkTypeThrough){
        [[LocationStorage sharedDefault] setThrough:[self configurationLocationStorageModel]];
       
    }
    
}

#pragma mark - 提交之后headView所做的处理

- (void)handleBeforeCommit{
    
    _tf_roadSection.text = nil;
    _tf_address.text     = nil;
    _tf_carNumber.text   = nil;
   

    if (_subType == ParkTypePark) {
        if (_btnType != 1) {
            [self stopLocationAction:[LocationStorage sharedDefault].park];
        }
        
    }else if (_subType == ParkTypeReversePark){
        
        if (_btnType != 1 ) {
            [self stopLocationAction:[LocationStorage sharedDefault].towardError];
        }
        
    }else if (_subType == ParkTypeLockPark){
        
        if (_btnType != 1) {
            [self stopLocationAction:[LocationStorage sharedDefault].lockCar];
        }
        
    }else if (_subType == ParkTypeCarInfoAdd){
        
        if (_btnType != 1 ) {
            [self stopLocationAction:[LocationStorage sharedDefault].inforInput];
        }
    }else if (_subType == ParkTypeThrough){
        
        if (_btnType != 1) {
            [self stopLocationAction:[LocationStorage sharedDefault].through];
        }
    }
    
    [[LocationHelper sharedDefault] startLocation];
    
    if (_tf_addressRemarks.text.length > 0) {
        _param.addressRemark = _tf_addressRemarks.text;
    }

    _param.isManualPos = @(!_btnType);
    
    self.isCanCommit = [self juegeCanCommit];
    
    
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

#pragma mark -

- (void)takeCarNumberDown{
    [self.tf_carNumber resignFirstResponder];
    
}


#pragma mark - dealloc

- (void)dealloc{

    [[NSNotificationCenter defaultCenter] removeObserver:self];
    LxPrintf(@"IllegalParkAddHeadView dealloc");

}

@end

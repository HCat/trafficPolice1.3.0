//
//  IllegalAddHeadView.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/15.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalAddHeadView.h"
#import "IllegalAddVC.h"
#import "SearchLocationVC.h"
#import "ParkCameraVC.h"
#import "PersonLocationVC.h"
#import "AlertView.h"
#import "UserModel.h"

@interface IllegalAddHeadView()

@property (weak, nonatomic) IBOutlet UITextField * tf_carNo;                //车牌号
@property (weak, nonatomic) IBOutlet UITextField * tf_roadSection;

@property (weak, nonatomic) IBOutlet UITextField * tf_address;              //所在位置
@property (weak, nonatomic) IBOutlet UITextField * tf_remark;              //备注

@property (weak, nonatomic) IBOutlet UIButton *btn_identify;                //识别

@property (weak, nonatomic) IBOutlet UIButton *btn_switchLocation; //定位开关
@property (weak, nonatomic) IBOutlet UIButton *btn_personLocation; //手动定位
@property (nonatomic,assign) BOOL btnType; //1:代表开  0:代表关
@property (nonatomic,strong) RACDisposable * disposable;

@property(nonatomic,strong) NSArray *codes;

@end


@implementation IllegalAddHeadView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        //添加对定位的监听
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(locationChange) name:NOTIFICATION_CHANGELOCATION_SUCCESS object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(carNoChange) name:@"识别车牌成功" object:nil];
        
    }
    return self;
}

- (void)awakeFromNib {
    
    @weakify(self);
    [super awakeFromNib];
    
    _tf_roadSection.attributedPlaceholder = [ShareFun highlightInString:@"请选择路段(必选)" withSubString:@"(必选)"];
    
    _tf_address.attributedPlaceholder     = [ShareFun highlightInString:@"请输入所在位置(必填)" withSubString:@"(必填)"];
    
    _tf_carNo.attributedPlaceholder = [ShareFun highlightInString:@"请填入车牌(必填)" withSubString:@"(必填)"];
    
    //配置点击UITextField

//    [self setUpCommonUITextField:self.tf_carNo];
//    [self setUpCommonUITextField:self.tf_address];
//    [self setUpCommonUITextField:self.tf_remark];
    
    _btn_personLocation.enabled = YES;
    [_btn_personLocation setBackgroundColor:DefaultBtnColor];
    
    [self.tf_address.rac_textSignal subscribeNext:^(NSString *  _Nullable x) {
        @strongify(self);
        self.param.address = x;
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
    self.btnType = [LocationStorage sharedDefault].isIllegal;
    //不管是手动定位还是自动定位都需要经纬度
    if (_btnType == NO) {
        
        LocationStorageModel * model = [LocationStorage sharedDefault].illegal;
        _param.roadName      = model.streetName;
        _tf_roadSection.text = model.streetName;
        _tf_address.text     = model.address;
        _param.address       = model.address;
        [self getRoadId];

    }
    
    [[LocationHelper sharedDefault] startLocation];
    
    
}

#pragma mark - setting && geting

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

- (NSArray *)codes{
    
    _codes = [ShareValue sharedDefault].roadModels;
    
    return _codes;
    
}

- (void)setParam:(IllegalSaveParam *)param{
    
    _param = param;
    
    @weakify(self);
    
    [RACObserve(self.param, roadName) subscribeNext:^(NSString * _Nullable x) {
         @strongify(self);
         if (x && x.length > 0) {
             self.tf_roadSection.text = x;
         }
    }];
    
    self.disposable = [RACObserve(self.param, roadName)  subscribeNext:^(NSString * _Nullable x) {
           @strongify(self);
           if (x) {
               
               if (([[UserModel getUserModel].orgCode isEqualToString:@"000000"] || [[UserModel getUserModel].orgCode isEqualToString:@"SSJJ"] ) && [[UserModel getUserModel].secRoadStatus isEqualToNumber:@1] ) {
                   
                   IllegalRoadView *view = [IllegalRoadView initCustomView];
                                 view.block = ^(CommonGetRoadModel * model) {
                                     @strongify(self);
                                     
                                     self.param.roadId = model.getRoadId;
                                     self.param.roadName = model.getRoadName;
                                     
                                  
                                 };
                    view.arr_content = self.codes;
                    view.roadName = self.param.roadName;
                    IllegalAddVC* t_vc = (IllegalAddVC *)[ShareFun findViewController:self withClass:[IllegalAddVC class]];
                    [AlertView showWindowWithIllegalRoadViewWith:view inView:t_vc.view];
                   
               }
              

               [self.disposable dispose];
           }
       
    }];
    

    _tf_roadSection.text = _param.roadName;
    _tf_address.text     = _param.address;
    _tf_carNo.text   = _param.carNo;
    
    if (_btnType != 1) {
        LocationStorageModel * model = [LocationStorage sharedDefault].illegal;
        _param.roadName      = model.streetName;
        _tf_roadSection.text = model.streetName;
        _tf_address.text     = model.address;
        _param.address       = model.address;
        [self getRoadId];
    }
    
    
    //这里设置代理是为了解决刷新时候textfield的代理消失问题
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

#pragma mark - buttonMethods

#pragma mark - 识别车牌号按钮事件

- (IBAction)handleBtnCarNumberClicked:(id)sender {
    
    @weakify(self);
    
    IllegalAddVC * t_vc = (IllegalAddVC *)[ShareFun findViewController:self withClass:[IllegalAddVC class]];
    
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

#pragma mark - 选择路段按钮事件
- (IBAction)handlebtnChoiceLocationClicked:(id)sender {
    
    @weakify(self);
    
    SearchLocationVC *t_searchLocationvc = [SearchLocationVC new];
    t_searchLocationvc.searchType = SearchLocationTypeIllegal;
    t_searchLocationvc.arr_content = self.codes;
    t_searchLocationvc.arr_temp = self.codes;
    t_searchLocationvc.search_text = self.param.roadName;
    
    t_searchLocationvc.getRoadBlock = ^(CommonGetRoadModel *model) {
        @strongify(self);
        self.param.roadId = model.getRoadId;
        self.param.roadName = model.getRoadName;
    
    };
    
    IllegalAddVC* t_vc = (IllegalAddVC *)[ShareFun findViewController:self withClass:[IllegalAddVC class]];
    [t_vc.navigationController pushViewController:t_searchLocationvc animated:YES];
    
}

#pragma mark - 切换定位开关

- (IBAction)handleBtnSwitchLocationClicked:(id)sender {
    
    if (_btnType) {
        [[LocationStorage sharedDefault] setIsIllegal:NO];
        
        LocationStorageModel * model = [LocationStorage sharedDefault].illegal;
        _param.roadName      = model.streetName;
        _tf_address.text     = model.address;
        _param.address       = model.address;
        [self getRoadId];
        
    }else{
        
        [[LocationStorage sharedDefault] setIsIllegal:YES];
        
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
    IllegalAddVC * t_vc = (IllegalAddVC *)[ShareFun findViewController:self withClass:[IllegalAddVC class]];
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

#pragma mark - Notication 重新定位之后的通知

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

- (void)carNoChange{
    _tf_carNo.text = self.param.carNo;
}


#pragma mark - 配置UITextField

- (void)setUpCommonUITextField:(UITextField *)textField{
    
    textField.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 3, 0)];
    //设置显示模式为永远显示(默认不显示)
    textField.leftViewMode = UITextFieldViewModeAlways;
    
}


- (void)dealloc{
    LxPrintf(@"IllegalAddHeadView dealloc");
}

@end

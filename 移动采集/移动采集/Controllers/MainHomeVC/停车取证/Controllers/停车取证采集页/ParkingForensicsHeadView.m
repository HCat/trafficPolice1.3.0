//
//  ParkingForensicsHeadView.m
//  移动采集
//
//  Created by hcat on 2019/7/29.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingForensicsHeadView.h"
#import "FSTextView.h"
#import "SearchLocationVC.h"
#import "PersonLocationVC.h"
#import "ParkingForensicsVC.h"
#import "LRCameraVC.h"


@interface ParkingForensicsHeadView()

@property (weak, nonatomic) IBOutlet UITextField * tf_carNumber;            //车牌号
@property (weak, nonatomic) IBOutlet UITextField * tf_roadSection;          //选择路段
@property (weak, nonatomic) IBOutlet UITextField * tf_address;              //所在位置
@property (weak, nonatomic) IBOutlet FSTextView  * tf_addressRemarks;       //地址备注

@property (weak, nonatomic) IBOutlet UIButton *btn_shibie;         //车牌号识别
@property (weak, nonatomic) IBOutlet UIButton *btn_switchLocation; //定位开关
@property (weak, nonatomic) IBOutlet UIButton *btn_personLocation; //手动定位

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_addressMark_height;



@property(nonatomic,strong) NSArray *codes;

@end


@implementation ParkingForensicsHeadView

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
    @weakify(self);
    _tf_carNumber.attributedPlaceholder   = [ShareFun highlightInString:@"请输入车牌号(必填)" withSubString:@"(必填)"] ;
    
    _tf_roadSection.attributedPlaceholder = [ShareFun highlightInString:@"请选择路段(必选)" withSubString:@"(必选)"];
    
    _tf_address.attributedPlaceholder     = [ShareFun highlightInString:@"请输入所在位置(必填)" withSubString:@"(必填)"];
    [_tf_addressRemarks setDelegate:(id<UITextViewDelegate> _Nullable)self];
    
    //配置点击UITextField
    [self setUpClickUITextField:self.tf_roadSection];
    [self setUpCommonUITextField:self.tf_address];
    
    
    [self.tf_addressRemarks.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.param.addressRemark = x;
    }];
    
   
    
    self.btnType = [LocationStorage sharedDefault].isForensics;
    
    
    [RACObserve(self, btnType) subscribeNext:^(NSNumber * _Nullable x) {
        @strongify(self);
        if ([x boolValue]) {
            [[LocationStorage sharedDefault] setIsForensics:YES];
            
            self.tf_roadSection.text  = nil;
            self.tf_address.text      = nil;
            
            self.param.roadName       = nil;
            self.param.address        = nil;
            
            self.param.longitude      = nil;
            self.param.latitude       = nil;
            self.param.roadId         = nil;
            
        }else{
            [[LocationStorage sharedDefault] setIsForensics:NO];
            [self stopLocationAction:[LocationStorage sharedDefault].forensics];
            
        }
        
        [[LocationHelper sharedDefault] startLocation];
        
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


#pragma mark - buttonMethods

#pragma mark - 添加违章类型事件

- (IBAction)handleBtnCarNumberClicked:(id)sender {
    
    @weakify(self);
    
    ParkingForensicsVC * t_vc = (ParkingForensicsVC *)[ShareFun findViewController:self withClass:[ParkingForensicsVC class]];
    
    LRCameraVC *home = [[LRCameraVC alloc] init];
    home.type = 1;
    home.fininshCaptureBlock = ^(LRCameraVC *camera) {
        
        if (camera) {
            
            @strongify(self);
            
            if (camera.type == 1) {
                
                if (camera.commonIdentifyResponse) {
                    
                    self.param.taketime = [ShareFun getCurrentTime];
                    self.param.carNo        = camera.commonIdentifyResponse.carNo;
                    if (camera.carColor) {
                        self.param.carColor = camera.carColor;
                    }
                    self.param.cutImageUrl = camera.commonIdentifyResponse.cutImageUrl;
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
    
    self.btnType = !_btnType;
    
}

#pragma mark - 手动定位按钮事件

- (IBAction)handlebtnPersonLocationClicked:(id)sender {
    
    PersonLocationVC *t_personLocationVc = [PersonLocationVC new];
    ParkingForensicsVC * t_vc = (ParkingForensicsVC *)[ShareFun findViewController:self withClass:[ParkingForensicsVC class]];
    [t_vc.navigationController pushViewController:t_personLocationVc animated:YES];
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
        strongSelf.param.roadName = model.getRoadName;
        strongSelf.param.roadId = model.getRoadId;
        
    };
    
    ParkingForensicsVC * t_vc = (ParkingForensicsVC *)[ShareFun findViewController:self withClass:[ParkingForensicsVC class]];
    [t_vc.navigationController pushViewController:t_searchLocationvc animated:YES];
    
}

#pragma mark - 重新定位之后的通知

-(void)locationChange{
    
    if (self.btnType == 1) {
        
        _tf_roadSection.text = [LocationHelper sharedDefault].streetName;
        _tf_address.text     = [LocationHelper sharedDefault].address;
        
        _param.roadName = [LocationHelper sharedDefault].streetName;
        _param.address = [LocationHelper sharedDefault].address;
        
        [self getRoadId];
        
    }
    
    _param.longitude     = @([LocationHelper sharedDefault].longitude);
    _param.latitude      = @([LocationHelper sharedDefault].latitude);
    
}

#pragma mark - 关闭定位之后所做的赋值操作

- (void)stopLocationAction:(LocationStorageModel *)model{
    
    _tf_roadSection.text = model.streetName;
    _tf_address.text     = model.address;
    
    _param.roadName = model.streetName;
    _param.address = model.address;
    
    [self getRoadId];
    
}

#pragma mark  - 存储停止定位位置

- (LocationStorageModel *)configurationLocationStorageModel{
    
    LocationStorageModel * model = [[LocationStorageModel alloc] init];
    model.streetName    = _param.roadName;
    model.address       = _param.address;
    
    return model;
    
}

#pragma mark - 提交之后headView存储地址的处理

- (void)strogeLocationBeforeCommit{
    
    [[LocationStorage sharedDefault] setForensics:[self configurationLocationStorageModel]];
    
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
    
    if (textField == _tf_roadSection) {
        [self handlebtnChoiceLocationClicked:nil];
        return NO;
    }
    
    return YES;
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    float height;
    if ([text isEqual:@""]) {
        
        if (![textView.text isEqualToString:@""]) {
            
            height = [ self heightForTextView:textView WithText:[textView.text substringToIndex:[textView.text length] - 1]];
            
        }else{
            
            height = [ self heightForTextView:textView WithText:textView.text];
        }
    }else{
        
        height = [self heightForTextView:textView WithText:[NSString stringWithFormat:@"%@%@",textView.text,text]];
    }
    
    @weakify(self);
    [UIView animateWithDuration:0.5 animations:^{
        @strongify(self);
        if (textView == self.tf_addressRemarks) {
            self.layout_addressMark_height.constant = height;
            [self layoutIfNeeded];
        }
        
    } completion:nil];
    
    
    
    return YES;
}

//计算评论框文字的高度
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    //    float padding = 10.0;
    CGSize constraint = CGSizeMake(textView.contentSize.width, CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}

- (void)setParam:(ParkingForensicsParam *)param{
    
    _param = param;
    @weakify(self);
    [RACObserve(self.param, carNo) subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        if (x && x.length > 0) {
            self.tf_carNumber.text = x;
        }
        
    }];
    
}

@end

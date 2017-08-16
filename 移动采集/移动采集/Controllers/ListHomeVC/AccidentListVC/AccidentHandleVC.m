//
//  AccidentHandleVC.m
//  移动采集
//
//  Created by hcat on 2017/8/10.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentHandleVC.h"
#import "AccidentDetailVC.h"
#import "AccidentAddRemarkVC.h"
#import "AccidentProcessVC.h"

#import "AccidentAPI.h"
#import <PureLayout.h>

@interface AccidentHandleVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_change;
@property (weak, nonatomic) IBOutlet UIButton *btn_tip;
@property (weak, nonatomic) IBOutlet UIButton *btn_handle;
@property (weak, nonatomic) IBOutlet UIView *v_content;
@property (weak, nonatomic) IBOutlet UIView *v_bottom;

@property (strong,nonatomic) AccidentDetailVC *accidentDetailVC; //事故详情
@property (nonatomic,strong) RemarkModel *remarkModel; //备注
@property (nonatomic,assign) NSInteger remarkCount;    //备注条数

@property (nonatomic,strong) AccidentSaveParam *param;

@end

@implementation AccidentHandleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_accidentType == AccidentTypeAccident) {
        self.title = @"事故详情";
    }else if (_accidentType == AccidentTypeFastAccident){
        self.title = @"快处详情";
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewRemark:) name:NOTIFICATION_ADDREMARK_SUCCESS object:nil];

    self.remarkCount = 0;

    [self setupConfigButtons];
    [self setupAccidentDetailView];
    [self requestRemarkList];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}

#pragma mark - set && get 

- (void)setRemarkCount:(NSInteger)remarkCount{

    _remarkCount = remarkCount;
    _accidentDetailVC.remarkCount = _remarkCount;
    
}

- (void)setRemarkModel:(RemarkModel *)remarkModel{

    _remarkModel = remarkModel;
    _accidentDetailVC.remarkModel = _remarkModel;

}

- (AccidentSaveParam *)param{

    AccidentSaveParam *param = [AccidentSaveParam new];
    
    
    AccidentModel *accidentModel        = _accidentDetailVC.model.accident;
    AccidentVoModel *accidentVoModel    = _accidentDetailVC.model.accidentVo;
    
    param.accidentId    = _accidentId;
    param.happenTimeStr = [ShareFun timeWithTimeInterval:accidentModel.happenTime];
    param.roadId        = accidentModel.roadId;
    param.address       = accidentModel.address;
    param.causesType    = accidentModel.causesType;
    param.weather       = accidentModel.weather;
    param.injuredNum    = accidentModel.injuredNum;
    param.roadType      = accidentModel.roadType;
    
    //甲方
    param.ptaName               = accidentModel.ptaName;
    param.ptaIdNo               = accidentModel.ptaIdNo;
    param.ptaVehicleId          = accidentModel.ptaVehicleId;
    param.ptaCarNo              = accidentModel.ptaCarNo;
    param.ptaPhone              = accidentModel.ptaPhone;
    param.ptaInsuranceCompanyId = accidentModel.ptaInsuranceCompanyId;
    param.ptaResponsibilityId   = accidentModel.ptaResponsibilityId;
    param.ptaDirect             = accidentModel.ptaDirect;
    param.ptaBehaviourId        = accidentModel.ptaBehaviourId;
    param.ptaDescribe           = accidentModel.ptaDescribe;
    
    param.ptaIsZkCl             = accidentVoModel.ptaIsZkCl;
    param.ptaIsZkXsz            = accidentVoModel.ptaIsZkXsz;
    param.ptaIsZkJsz            = accidentVoModel.ptaIsZkJsz;
    param.ptaIsZkSfz            = accidentVoModel.ptaIsZkSfz;
    
    //乙方
    param.ptbName               = accidentModel.ptbName;
    param.ptbIdNo               = accidentModel.ptbIdNo;
    param.ptbVehicleId          = accidentModel.ptbVehicleId;
    param.ptbCarNo              = accidentModel.ptbCarNo;
    param.ptbPhone              = accidentModel.ptbPhone;
    param.ptbInsuranceCompanyId = accidentModel.ptbInsuranceCompanyId;
    param.ptbResponsibilityId   = accidentModel.ptbResponsibilityId;
    param.ptbDirect             = accidentModel.ptbDirect;
    param.ptbBehaviourId        = accidentModel.ptbBehaviourId;
    param.ptbDescribe           = accidentModel.ptbDescribe;
    
    param.ptbIsZkCl             = accidentVoModel.ptbIsZkCl;
    param.ptbIsZkXsz            = accidentVoModel.ptbIsZkXsz;
    param.ptbIsZkJsz            = accidentVoModel.ptbIsZkJsz;
    param.ptbIsZkSfz            = accidentVoModel.ptbIsZkSfz;
    
    //丙方
    param.ptcName               = accidentModel.ptcName;
    param.ptcIdNo               = accidentModel.ptcIdNo;
    param.ptcVehicleId          = accidentModel.ptcVehicleId;
    param.ptcCarNo              = accidentModel.ptcCarNo;
    param.ptcPhone              = accidentModel.ptcPhone;
    param.ptcInsuranceCompanyId = accidentModel.ptcInsuranceCompanyId;
    param.ptcResponsibilityId   = accidentModel.ptcResponsibilityId;
    param.ptcDirect             = accidentModel.ptcDirect;
    param.ptcBehaviourId        = accidentModel.ptcBehaviourId;
    param.ptcDescribe           = accidentModel.ptcDescribe;
    
    param.ptcIsZkCl     =   accidentVoModel.ptcIsZkCl;
    param.ptcIsZkXsz    =   accidentVoModel.ptcIsZkXsz;
    param.ptcIsZkJsz    =   accidentVoModel.ptcIsZkJsz;
    param.ptcIsZkSfz    =   accidentVoModel.ptcIsZkSfz;
    
    
    
    param.state             =   accidentModel.state;
    param.casualties        =   accidentModel.casualties;
    param.causes            =   accidentModel.causes;
    param.mediationRecord   =   accidentModel.mediationRecord;
    param.memo              =   accidentModel.memo;
    

    return param;
}


#pragma mark - 请求备注列表

- (void)requestRemarkList{

    WS(weakSelf);
    AccidentRemarkListManger *manger = [AccidentRemarkListManger new];
    manger.accidentId = _accidentId;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            strongSelf.remarkCount = manger.list.count;
        
            if (manger.list.count > 0) {
                
                LxDBObjectAsJson(manger.list);
                strongSelf.remarkModel = manger.list.firstObject;
            
            }
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        
    }];
    
}

#pragma mark - 配置按钮高亮背景色

- (void)setupConfigButtons{
    UIImage *image = [ShareFun imageWithColor:DefaultNavColor size:CGSizeMake(SCREEN_WIDTH/3, 44)];
    [_btn_change setBackgroundImage:image forState:UIControlStateHighlighted];
    [_btn_tip setBackgroundImage:image forState:UIControlStateHighlighted];
    [_btn_handle setBackgroundImage:image forState:UIControlStateHighlighted];
    
    _v_bottom.layer.shadowColor = UIColorFromRGB(0x444444).CGColor;//shadowColor阴影颜色
    _v_bottom.layer.shadowOffset = CGSizeMake(1,-2);
    _v_bottom.layer.shadowOpacity = 0.1;
    _v_bottom.layer.shadowRadius = 10;
}

#pragma mark - 配置事故详情页面

- (void)setupAccidentDetailView{
    self.accidentDetailVC = [[AccidentDetailVC alloc] init];
    _accidentDetailVC.accidentType = _accidentType;
    _accidentDetailVC.accidentId = _accidentId;
    [self addChildViewController:_accidentDetailVC];
    
    [_v_content addSubview:_accidentDetailVC.view];
    [_accidentDetailVC.view configureForAutoLayout];
    [_accidentDetailVC.view autoPinEdgesToSuperviewEdges];
    [_accidentDetailVC didMoveToParentViewController:self];
}

#pragma mark - 修改按钮事件

- (IBAction)handleBtnChangeClicked:(id)sender {
    
    
}

#pragma mark - 备注按钮事件
- (IBAction)handleBtnTipClicked:(id)sender {
    
    AccidentAddRemarkVC *t_vc = [AccidentAddRemarkVC new];
    t_vc.accidentId = _accidentId;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

#pragma mark - 处理按钮事件
- (IBAction)handleBtnHandleClicked:(id)sender {
    
    AccidentProcessVC *t_vc = [AccidentProcessVC new];
    t_vc.accidentType = _accidentType;
    t_vc.param = self.param;
    [self.navigationController pushViewController:t_vc animated:YES];
}

#pragma mark - 通知事件

- (void)receiveNewRemark:(NSNotification *)notification{

    RemarkModel *t_model = notification.object;

    self.remarkModel = t_model;
    
    self.remarkCount = _remarkCount + 1;
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"AccidentHandleVC dealloc");

}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

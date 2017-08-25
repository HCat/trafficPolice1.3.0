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
#import "FastAccidentProcessVC.h"
#import "AccidentChangeVC.h"

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
@property (nonatomic,copy) NSArray<AccidentPicListModel *> *picList;

@end

@implementation AccidentHandleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (_accidentType == AccidentTypeAccident) {
        self.title = @"事故详情";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAccidentDetail:) name:NOTIFICATION_ACCIDENT_SUCCESS object:nil];
    }else if (_accidentType == AccidentTypeFastAccident){
        self.title = @"快处详情";
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resetAccidentDetail:) name:NOTIFICATION_FASTACCIDENT_SUCCESS object:nil];
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

    _param = [AccidentSaveParam new];
    
    
    AccidentModel *accidentModel        = _accidentDetailVC.model.accident;
    AccidentVoModel *accidentVoModel    = _accidentDetailVC.model.accidentVo;
    
    _param.accidentId    = _accidentId;
    _param.happenTimeStr = [ShareFun timeWithTimeInterval:accidentModel.happenTime];
    _param.roadId        = accidentModel.roadId;
    _param.address       = accidentModel.address;
    _param.causesType    = accidentModel.causesType;
    _param.weather       = accidentModel.weather;
    _param.injuredNum    = accidentModel.injuredNum;
    _param.roadType      = accidentModel.roadType;
    
    //甲方
    _param.ptaName               = accidentModel.ptaName;
    _param.ptaIdNo               = accidentModel.ptaIdNo;
    _param.ptaVehicleId          = accidentModel.ptaVehicleId;
    _param.ptaCarNo              = accidentModel.ptaCarNo;
    _param.ptaPhone              = accidentModel.ptaPhone;
    _param.ptaInsuranceCompanyId = accidentModel.ptaInsuranceCompanyId;
    _param.ptaResponsibilityId   = accidentModel.ptaResponsibilityId;
    _param.ptaDirect             = accidentModel.ptaDirect;
    _param.ptaBehaviourId        = accidentModel.ptaBehaviourId;
    _param.ptaDescribe           = accidentModel.ptaDescribe;
    
    _param.ptaIsZkCl             = accidentVoModel.ptaIsZkCl;
    _param.ptaIsZkXsz            = accidentVoModel.ptaIsZkXsz;
    _param.ptaIsZkJsz            = accidentVoModel.ptaIsZkJsz;
    _param.ptaIsZkSfz            = accidentVoModel.ptaIsZkSfz;
    
    //乙方
    _param.ptbName               = accidentModel.ptbName;
    _param.ptbIdNo               = accidentModel.ptbIdNo;
    _param.ptbVehicleId          = accidentModel.ptbVehicleId;
    _param.ptbCarNo              = accidentModel.ptbCarNo;
    _param.ptbPhone              = accidentModel.ptbPhone;
    _param.ptbInsuranceCompanyId = accidentModel.ptbInsuranceCompanyId;
    _param.ptbResponsibilityId   = accidentModel.ptbResponsibilityId;
    _param.ptbDirect             = accidentModel.ptbDirect;
    _param.ptbBehaviourId        = accidentModel.ptbBehaviourId;
    _param.ptbDescribe           = accidentModel.ptbDescribe;
    
    _param.ptbIsZkCl             = accidentVoModel.ptbIsZkCl;
    _param.ptbIsZkXsz            = accidentVoModel.ptbIsZkXsz;
    _param.ptbIsZkJsz            = accidentVoModel.ptbIsZkJsz;
    _param.ptbIsZkSfz            = accidentVoModel.ptbIsZkSfz;
    
    //丙方
    _param.ptcName               = accidentModel.ptcName;
    _param.ptcIdNo               = accidentModel.ptcIdNo;
    _param.ptcVehicleId          = accidentModel.ptcVehicleId;
    _param.ptcCarNo              = accidentModel.ptcCarNo;
    _param.ptcPhone              = accidentModel.ptcPhone;
    _param.ptcInsuranceCompanyId = accidentModel.ptcInsuranceCompanyId;
    _param.ptcResponsibilityId   = accidentModel.ptcResponsibilityId;
    _param.ptcDirect             = accidentModel.ptcDirect;
    _param.ptcBehaviourId        = accidentModel.ptcBehaviourId;
    _param.ptcDescribe           = accidentModel.ptcDescribe;
    
    _param.ptcIsZkCl     =   accidentVoModel.ptcIsZkCl;
    _param.ptcIsZkXsz    =   accidentVoModel.ptcIsZkXsz;
    _param.ptcIsZkJsz    =   accidentVoModel.ptcIsZkJsz;
    _param.ptcIsZkSfz    =   accidentVoModel.ptcIsZkSfz;
    
    
    
    _param.state             =   accidentModel.state;
    _param.casualties        =   accidentModel.casualties;
    _param.causes            =   accidentModel.causes;
    _param.mediationRecord   =   accidentModel.mediationRecord;
    _param.memo              =   accidentModel.memo;
    

    return _param;
}

- (NSArray <AccidentPicListModel *>*)picList{

    _picList = [_accidentDetailVC.model.picList copy];
    return _picList;
    
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
    
    AccidentChangeVC *t_vc = [AccidentChangeVC new];
    t_vc.accidentType = _accidentType;
    t_vc.param = self.param;
    t_vc.picList = self.picList;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

#pragma mark - 备注按钮事件
- (IBAction)handleBtnTipClicked:(id)sender {
    
    AccidentAddRemarkVC *t_vc = [AccidentAddRemarkVC new];
    t_vc.accidentId = _accidentId;
    [self.navigationController pushViewController:t_vc animated:YES];
    
}

#pragma mark - 处理按钮事件
- (IBAction)handleBtnHandleClicked:(id)sender {
    
    if (_accidentType == AccidentTypeAccident) {
        AccidentProcessVC *t_vc = [AccidentProcessVC new];
        t_vc.param = self.param;
        [self.navigationController pushViewController:t_vc animated:YES];
    }else if (_accidentType == AccidentTypeFastAccident){
        FastAccidentProcessVC *t_vc = [FastAccidentProcessVC new];
        t_vc.param = self.param;
        [self.navigationController pushViewController:t_vc animated:YES];
    }
   
}

#pragma mark - 通知事件

#pragma mark - 接收到新的备注通知
- (void)receiveNewRemark:(NSNotification *)notification{

    RemarkModel *t_model = notification.object;

    self.remarkModel = t_model;
    
    self.remarkCount = _remarkCount + 1;
    
}

#pragma mark - 接收到事故详情修改通知

- (void)resetAccidentDetail:(NSNotification *)notification{
    
    if (_accidentDetailVC) {
        [_accidentDetailVC removeFromParentViewController];
        [_accidentDetailVC.view removeFromSuperview];
    }
    
    [self setupAccidentDetailView];
    
    _accidentDetailVC.remarkModel = _remarkModel;
    _accidentDetailVC.remarkCount = _remarkCount;
}



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    if (_accidentType == AccidentTypeAccident) {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ACCIDENT_SUCCESS object:nil];
    }else if (_accidentType == AccidentTypeFastAccident){
        [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_FASTACCIDENT_SUCCESS object:nil];
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_ADDREMARK_SUCCESS object:nil];
    
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

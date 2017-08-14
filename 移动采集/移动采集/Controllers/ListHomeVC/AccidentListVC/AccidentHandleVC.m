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

#import "AccidentAPI.h"
#import <PureLayout.h>

@interface AccidentHandleVC ()

@property (weak, nonatomic) IBOutlet UIButton *btn_change;
@property (weak, nonatomic) IBOutlet UIButton *btn_tip;
@property (weak, nonatomic) IBOutlet UIButton *btn_handle;
@property (weak, nonatomic) IBOutlet UIView *v_content;
@property (weak, nonatomic) IBOutlet UIView *v_bottom;

@property (strong,nonatomic) AccidentDetailVC *accidentDetailVC;
@property (nonatomic,strong) RemarkModel *remarkModel;

@end

@implementation AccidentHandleVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"事故详情";
    
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

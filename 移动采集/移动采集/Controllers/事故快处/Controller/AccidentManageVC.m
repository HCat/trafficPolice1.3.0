//
//  AccidentManageVC.m
//  移动采集
//
//  Created by hcat on 2018/7/9.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentManageVC.h"
#import "AccidentUpImageCell.h"
#import "AccidentInfoCell.h"
#import "AccidentPeopleCell.h"
#import "AccidentCallPoliceCell.h"
#import "AccidentUpCell.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "AccidentAPI.h"
#import "FastAccidentAPI.h"
#import "NetWorkHelper.h"
#import "AccidentUpFactory.h"

#import "UserModel.h"

@interface AccidentManageVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) AccidentInfoCell *infoCell;       //事故信息Cell
@property (strong, nonatomic) AccidentPeopleCell *peopleCell;   //事故当事人信息Cell
@property (strong, nonatomic) AccidentCallPoliceCell * callCell;    //报警人信息
@property (strong, nonatomic) NSMutableArray *arr_photo;        //即将上传的照片信息
@property (strong, nonatomic) NSMutableArray *lastSelectAssets;
@property (nonatomic,strong)  AccidentUpFactory *partyFactory;   //事故录入信息的管理类

@property (nonatomic,assign) BOOL isUpLoading;          //用于判断是否是上传

@end

@implementation AccidentManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (_accidentType == AccidentTypeFastAccident) {
//        self.title = @"快处录入";
//    }else if (_accidentType == AccidentTypeAccident){
//        self.title = @"事故录入";
//    }
    
    self.isUpLoading = NO;
    
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    
    [_tableView registerNib:[UINib nibWithNibName:@"AccidentUpImageCell" bundle:nil] forCellReuseIdentifier:@"AccidentUpImageCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"AccidentInfoCell" bundle:nil] forCellReuseIdentifier:@"AccidentInfoCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"AccidentCallPoliceCell" bundle:nil] forCellReuseIdentifier:@"AccidentCallPoliceCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"AccidentPeopleCell" bundle:nil] forCellReuseIdentifier:@"AccidentPeopleCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"AccidentUpCell" bundle:nil] forCellReuseIdentifier:@"AccidentUpCellID"];
    

    self.arr_photo = [NSMutableArray array];
    self.lastSelectAssets = [NSMutableArray array];
    
    self.partyFactory = [[AccidentUpFactory alloc] init];
    
    [[ShareValue sharedDefault] accidentCodes];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        [[ShareValue sharedDefault] accidentCodes];
    };
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (self.accidentType == AccidentTypeAccident) {
        return 5;
    }else{
        return 4;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    
    if (indexPath.row == 0) {
        
        WS(weakSelf);
        height = [tableView fd_heightForCellWithIdentifier:@"AccidentUpImageCellID"  configuration:^(AccidentUpImageCell *cell) {
            SW(strongSelf,weakSelf);
            if (strongSelf.arr_photo) {
                cell.arr_photo = strongSelf.arr_photo;
                
            }
        }];
        
    }else if (indexPath.row ==1){
        if (_infoCell == nil) {
            self.infoCell = [tableView dequeueReusableCellWithIdentifier:@"AccidentInfoCellID"];
            
        }
        height = [_infoCell heightOfCell];
    
    }else if (indexPath.row ==2){
        
        if (self.accidentType == AccidentTypeAccident) {
            height = 150.f;
        }else{
            if (_peopleCell == nil) {
                self.peopleCell = [tableView dequeueReusableCellWithIdentifier:@"AccidentPeopleCellID"];
                
            }
            _peopleCell.accidentType = _accidentType;
            height = [_peopleCell heightOfCell] + 97.f;
            LxPrintf(@"heighttting ==== %f",height);
        }
        
    }else if (indexPath.row == 3){
        
        if (self.accidentType == AccidentTypeAccident) {
            if (_peopleCell == nil) {
                self.peopleCell = [tableView dequeueReusableCellWithIdentifier:@"AccidentPeopleCellID"];
                
            }
            _peopleCell.accidentType = _accidentType;
            height = [_peopleCell heightOfCell] + 97.f;
            LxPrintf(@"heighttting ==== %f",height);
        }else{
            height = 75.f;
        }
        
        
    }else if (indexPath.row == 4){
        if (self.accidentType == AccidentTypeAccident) {
            height = 75.f;
        }
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
    
        AccidentUpImageCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentUpImageCellID"];
        
        cell.arr_photo = self.arr_photo;
        cell.lastSelectAssets = self.lastSelectAssets;
       
        return  cell;
    }else if (indexPath.row ==1){
        if (_infoCell == nil) {
            self.infoCell = [tableView dequeueReusableCellWithIdentifier:@"AccidentInfoCellID"];
            
        }
        _infoCell.accidentType = _accidentType;
        _infoCell.partyFactory = self.partyFactory;
        
        return  _infoCell;
        
    }else if (indexPath.row == 2){
        
        if (self.accidentType == AccidentTypeAccident) {
            
            if (_callCell == nil) {
                self.callCell = [tableView dequeueReusableCellWithIdentifier:@"AccidentCallPoliceCellID"];
                _callCell.accidentType = _accidentType;
                _callCell.partyFactory = self.partyFactory;
            }
            
            return _callCell;
        }else{
            if (_peopleCell == nil) {
                self.peopleCell = [tableView dequeueReusableCellWithIdentifier:@"AccidentPeopleCellID"];
            }
            _peopleCell.accidentType = _accidentType;
            _peopleCell.peopleArray = self.partyFactory.peopleMarray;
            
            return _peopleCell;
        }
        
        
    }else if (indexPath.row == 3){
        
        if (self.accidentType == AccidentTypeAccident) {
            if (_peopleCell == nil) {
                self.peopleCell = [tableView dequeueReusableCellWithIdentifier:@"AccidentPeopleCellID"];
            }
            _peopleCell.accidentType = _accidentType;
            _peopleCell.peopleArray = self.partyFactory.peopleMarray;
            
            return _peopleCell;
        }else{
            AccidentUpCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentUpCellID"];
            [cell setDelegate:(id<AccidentUpCellDelegate>)self];
            return cell;
        }
        
    }else if (indexPath.row == 4){
        
        if (self.accidentType == AccidentTypeAccident) {
            AccidentUpCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentUpCellID"];
            [cell setDelegate:(id<AccidentUpCellDelegate>)self];
            return cell;
        }
    
    }
    
    
    return nil;
    
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}

#pragma mark - scrollViewDelegate
//用于滚动到顶部的时候使得tableView不能再继续下拉
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    if (scrollView == _tableView){
    
        if (scrollView.contentOffset.y < 0) {
            CGPoint position = CGPointMake(0, 0);
            [scrollView setContentOffset:position animated:NO];
            return;
        }
    }
}


#pragma mark - 提交操作

- (void)handleUpAction{
    
    if ([_partyFactory validateNumber] == NO){
        return;
    }
    
    if (self.isUpLoading == YES) {
        return;
    }
    
    //如果roadId不为0，则不需要传roadName
    if (![_partyFactory.param.roadId isEqualToNumber:@0]) {
        _partyFactory.param.roadName = nil;
    }
    
    //配置上传照片
    [_partyFactory configParamInImageArray:_arr_photo];
    
    //配置当事人信息
    [_partyFactory configParamInPeopleInfo];
    
    //配置证件照片列表
    [_partyFactory configParamInCertFilesAndCertRemarks];
    
    LxDBObjectAsJson(_partyFactory.param);
    
    [NetworkStatusMonitor StartWithBlock:^(NSInteger NetworkStatus) {
        
        [NetworkStatusMonitor StopMonitor];
        if (NetworkStatus != 10 && NetworkStatus != 1) {
            [ShareFun showTipLable:@"当前非4G网络,传输速度受影响"];
            return;
        }
        
    }];
    
    [self submitAccidentData];
    
}

- (void)submitAccidentData{
    
    WS(weakSelf);
    
    if (_accidentType == AccidentTypeAccident) {
        
        AccidentUpManger *manger = [[AccidentUpManger alloc] init];
        manger.param = self.partyFactory.param;
        [manger configLoadingTitle:@"提交"];
        manger.v_showHud = [UIApplication sharedApplication].delegate.window;
        
        self.isUpLoading = YES;
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            strongSelf.isUpLoading = NO;
            
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                if ([strongSelf.partyFactory.param.roadId isEqualToNumber:@0]) {
                    
                    [ShareValue sharedDefault].accidentCodes = nil;
                    [[ShareValue sharedDefault] accidentCodes];
                    [ShareValue sharedDefault].roadModels    = nil;
                    [[ShareValue sharedDefault] roadModels];
                    
                }
                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            strongSelf.isUpLoading = NO;
            
        }];
        
    }else if (_accidentType == AccidentTypeFastAccident){
        
        FastAccidentUpManger *manger = [[FastAccidentUpManger alloc] init];
        manger.param = self.partyFactory.param;
        [manger configLoadingTitle:@"提交"];
        
        self.isUpLoading = YES;
        
        [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            strongSelf.isUpLoading = NO;
            if (manger.responseModel.code == CODE_SUCCESS) {
                
                if ([strongSelf.partyFactory.param.roadId isEqualToNumber:@0]) {
                    
                    [ShareValue sharedDefault].accidentCodes = nil;
                    [[ShareValue sharedDefault] accidentCodes];
                    [ShareValue sharedDefault].roadModels = nil;
                    [[ShareValue sharedDefault] roadModels];
                    
                }
                
                [strongSelf.navigationController popViewControllerAnimated:YES];
                
            }
        } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
            
            SW(strongSelf, weakSelf);
            strongSelf.isUpLoading = NO;

        }];
    }
    
    
}

- (void)handleBeforeCommit{
    
    self.arr_photo = [NSMutableArray array];
    self.lastSelectAssets = [NSMutableArray array];
    self.partyFactory = [[AccidentUpFactory alloc] init];
    [_infoCell handleBeforeCommit];
    
    [self.tableView reloadData];
    
}

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"AccidentManageVC dealloc");
    
}


@end

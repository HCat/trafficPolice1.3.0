//
//  VehicleUpVC.m
//  移动采集
//
//  Created by hcat on 2018/5/15.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "VehicleUpVC.h"
#import "VehicleUpBasicInfoCell.h"
#import "VehicleUpImageCell.h"
#import "VehicleUpMoreCell.h"
#import "ZLPhotoActionSheet.h"
#import "ZLPhotoModel.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "VehicleAPI.h"
#import "SRAlertView.h"

@interface VehicleUpVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *arr_photos;
@property (nonatomic, strong) NSMutableArray<UIImage *> *lastSelectPhotos;
@property (nonatomic, strong) NSMutableArray<PHAsset *> *lastSelectAssets;
@property (nonatomic, strong) NSMutableArray<NSString *> *arr_illegalType;
@property (nonatomic, strong) NSMutableArray<NSNumber *> *arr_tagIndexs;
@property (nonatomic, assign) BOOL isCanCommit;
@property (nonatomic, strong) NSMutableDictionary *heightDic;

@end

@implementation VehicleUpVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"重点车辆上报";
    self.arr_photos = [NSMutableArray array];
    self.lastSelectPhotos = [NSMutableArray array];
    self.lastSelectAssets = [NSMutableArray array];
    self.arr_illegalType = [NSMutableArray array];
    self.arr_tagIndexs = [NSMutableArray array];
    self.heightDic = [NSMutableDictionary dictionary];
    self.isCanCommit = NO;
    [_tableView registerNib:[UINib nibWithNibName:@"VehicleUpMoreCell" bundle:nil] forCellReuseIdentifier:@"VehicleUpMoreCellID"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(judegeCommit) name:NOTIFICATION_JUDEGECOMMIT object:nil];
    
    [self.param addObserver:self forKeyPath:@"illegalType" options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld) context:nil];
    
    
    [self requestCommonRoad];
    [self requestVehicleCodeType];
    
}


#pragma mark - 返回按钮事件

-(void)handleBtnBackClicked{
    
    if (_param.plateNo || _param.driver || _param.idCardNum || _param.illegalType || _param.remark || _arr_photos.count > 0 ) {
        
        WS(weakSelf);
        
        SRAlertView *alertView = [[SRAlertView alloc] initWithTitle:@"温馨提示"
                                                            message:@"当前已编辑，是否退出编辑"
                                                    leftActionTitle:@"取消"
                                                   rightActionTitle:@"退出"
                                                     animationStyle:AlertViewAnimationNone
                                                       selectAction:^(AlertViewActionType actionType) {
                                                           if(actionType == AlertViewActionTypeRight) {
                                                               [weakSelf.navigationController popViewControllerAnimated:YES];
                                                           }
                                                       }];
        alertView.blurCurrentBackgroundView = NO;
        [alertView show];
        
        
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        
    }
    
}




#pragma mark - 获取请求数据

- (void)requestVehicleCodeType{
    
    WS(weakSelf);
    VehicleGetCodeTypeManger *manger = [[VehicleGetCodeTypeManger alloc] init];
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        
        for (VehicleCodeInfo *model in manger.list) {
            [strongSelf.arr_illegalType addObject:model.configName];
        }
        NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
        [strongSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
      
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}

//获取道路ID
- (void)requestCommonRoad{
    
    WS(weakSelf);
    CommonGetRoadManger *manger = [[CommonGetRoadManger alloc] init];
    manger.isLog = NO;
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            [ShareValue sharedDefault].roadModels = manger.commonGetRoadResponse;
            
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
            VehicleUpBasicInfoCell *cell = (VehicleUpBasicInfoCell *)[strongSelf.tableView cellForRowAtIndexPath:indexPath];
            if (cell) {
                [cell getRoadId];
            }

        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
    }];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return 270;
    }else if (indexPath.row ==1){
        return 160;
        
    }else if (indexPath.row == 2){
        
        WS(weakSelf);
        self.tableView.rowHeight = UITableViewAutomaticDimension;
        self.tableView.estimatedRowHeight = 80;
        CGFloat height = [_tableView fd_heightForCellWithIdentifier:@"VehicleUpMoreCellID" cacheByIndexPath:indexPath configuration:^(VehicleUpMoreCell *cell) {
            SW(strongSelf, weakSelf);
            cell.tags = strongSelf.arr_illegalType;
        }];
        NSString* key = [NSString stringWithFormat:@"%ld",indexPath.row];
        [self.heightDic setValue:@(height) forKey:key];
        
        return height;
    }

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
   
    if (indexPath.row == 0) {
        VehicleUpBasicInfoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleUpBasicInfoCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"VehicleUpBasicInfoCell" bundle:nil] forCellReuseIdentifier:@"VehicleUpBasicInfoCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleUpBasicInfoCellID"];
            cell.param = _param;
            [cell startLocation];
        }
        cell.param = _param;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 1){
        VehicleUpImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleUpImageCellID"];
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:@"VehicleUpImageCell" bundle:nil] forCellReuseIdentifier:@"VehicleUpImageCellID"];
            cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleUpImageCellID"];
        }
        cell.arr_images = _arr_photos;
        cell.lastSelectAssets = _lastSelectAssets;
        cell.lastSelectPhotos = _lastSelectPhotos;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }else if (indexPath.row == 2){
        
        WS(weakSelf);
        VehicleUpMoreCell *cell = [tableView dequeueReusableCellWithIdentifier:@"VehicleUpMoreCellID"];
        cell.fd_enforceFrameLayout = NO;
        cell.param = _param;
        cell.isCanCommit = self.isCanCommit;
        cell.tags = self.arr_illegalType;
        cell.tagIndexs = _arr_tagIndexs;
        cell.remark = _param.remark;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.upBlock = ^(){
            SW(strongSelf, weakSelf);
            [strongSelf handleBtnUpClicked];
        };
        return cell;
       
    }
    
    return nil;
    
}

-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    NSString* key = [NSString stringWithFormat:@"%ld",indexPath.row];
    NSNumber* heigt = self.heightDic[key];
    if (heigt == nil) {
        
        heigt = @(410);
    }
    
    return heigt.floatValue;
    
}

#pragma mark - 配置图片文件信息

- (void)configParamInFiles{
    
    NSMutableArray *t_arr = [NSMutableArray array];
    for (UIImage *t_image in _arr_photos) {
        ImageFileInfo *t_imageFileInfo = [[ImageFileInfo alloc] initWithImage:t_image withName:key_files];
        [t_arr addObject:t_imageFileInfo];
    }
    _param.files = t_arr;
    
}

#pragma mark - 上传按钮点击事件

- (void)handleBtnUpClicked{
    
    if (_param.plateNo) {
        
        if([ShareFun validateCarNumber:_param.plateNo] == NO){
            [LRShowHUD showError:@"车牌号格式错误" duration:1.f];
            return;
        }
        
    }
    
    if (_param.idCardNum) {
        
        if([ShareFun validateIDCardNumber:self.param.idCardNum] == NO){
            [LRShowHUD showError:@"身份证格式错误" duration:1.f];
            return;
        }
    }
    
    [NetworkStatusMonitor StartWithBlock:^(NSInteger NetworkStatus) {
        
        //大类 : 0没有网络 1为WIFI网络 2/6/7为2G网络  3/4/5/8/9/11/12为3G网络
        //10为4G网络
        [NetworkStatusMonitor StopMonitor];
        if (NetworkStatus != 10 && NetworkStatus != 1) {
            [ShareFun showTipLable:@"当前非4G网络,传输速度受影响"];
            return;
        }
        
    }];
    
    
    [self configParamInFiles];
    
    LxDBObjectAsJson(_param);
    
    WS(weakSelf);
    
    VehicleCarlUpManger *manger = [[VehicleCarlUpManger alloc] init];
    manger.param = _param;
    [manger configLoadingTitle:@"提交"];
    manger.isNoShowFail = YES;
    
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
    
        [[LocationStorage sharedDefault] setVehicle:[strongSelf configurationLocationStorageModel]];
        
        
        if (manger.responseModel.code == CODE_SUCCESS) {
            
            [strongSelf.navigationController popViewControllerAnimated:YES];
            
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        if ([request.error.localizedDescription isEqualToString:@"请求超时。"]) {
            [LRShowHUD showError:@"请重新提交!" duration:1.5f];
        }
    }];
    
    
}

#pragma mark  - 存储停止定位位置

- (LocationStorageModel *)configurationLocationStorageModel{
    
    LocationStorageModel * model = [[LocationStorageModel alloc] init];
    model.streetName    = _param.road;
    model.address       = _param.position;
    
    return model;
    
    
}

#pragma mark - NSNotificationCenter

- (void)judegeCommit{
    
    LxDBObjectAsJson(self.param);
    
    if (_param.plateNo.length >0 && _param.driver.length > 0 && _param.idCardNum.length > 0 && _param.road.length > 0 && _param.position.length > 0 && _param.illegalType.length > 0){
        self.isCanCommit = YES;
    }else{
        self.isCanCommit = NO;
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}

#pragma mark - KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary*)change context:(void *)context{
    
    if ([keyPath isEqualToString:@"illegalType"] && object == _param){
       
        [self judegeCommit];
       
    }
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

#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    [self.param removeObserver:self forKeyPath:@"illegalType"];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    LxPrintf(@"VehicleUpVC dealloc");
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

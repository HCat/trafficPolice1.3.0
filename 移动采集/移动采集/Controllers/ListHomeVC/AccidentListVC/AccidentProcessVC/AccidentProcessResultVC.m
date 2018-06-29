//
//  AccidentProcessResultVC.m
//  移动采集
//
//  Created by hcat on 2017/8/30.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "AccidentProcessResultVC.h"
#import "AccidentAPI.h"
#import "FastAccidentAPI.h"

#import "UITableView+Lr_Placeholder.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "ProcessResultCell.h"
#import "NetWorkHelper.h"

@interface AccidentProcessResultVC ()

@property (weak, nonatomic) IBOutlet UITableView *tb_content;
@property (nonatomic,strong,readwrite) AccidentDetailModel * model;
@property (nonatomic,strong) NSArray *arr_content;


@end

@implementation AccidentProcessResultVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor clearColor];
    if (_accidentType == AccidentTypeAccident) {
        self.arr_content = [[NSArray alloc] initWithObjects:@"伤亡情况：",@"事故成因：",@"中队调解记录：",@"备注记录与领导记录：", nil];
    }else if (_accidentType == AccidentTypeFastAccident){
        self.arr_content = [[NSArray alloc] initWithObjects:@"事故责任认定建议：",@"备注：", nil];
    }
    
    _tb_content.isNeedPlaceholderView = YES;
    _tb_content.firstReload = YES;
    
    [_tb_content registerNib:[UINib nibWithNibName:@"ProcessResultCell" bundle:nil] forCellReuseIdentifier:@"ProcessResultCellID"];
    
    if (_accidentType == AccidentTypeAccident) {
        [self loadAccidentDetail];
    }else if (_accidentType == AccidentTypeFastAccident){
        [self loadAccidentFastDetail];
    }
    
    WS(weakSelf);
    //点击重新加载之后的处理
    [_tb_content setReloadBlock:^{
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        if (strongSelf.accidentType == AccidentTypeAccident) {
            [strongSelf loadAccidentDetail];
        }else if (strongSelf.accidentType == AccidentTypeFastAccident){
            [strongSelf loadAccidentFastDetail];
        }
        
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);
    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        
        SW(strongSelf, weakSelf);
        strongSelf.tb_content.isNetAvailable = NO;
        if (strongSelf.accidentType == AccidentTypeAccident) {
            [strongSelf loadAccidentDetail];
        }else if (strongSelf.accidentType == AccidentTypeFastAccident){
            [strongSelf loadAccidentFastDetail];
        }
        
    };
    
}



#pragma mark - 数据请求部分

- (void)loadAccidentDetail{
    
    WS(weakSelf);
    AccidentDetailManger *manger = [[AccidentDetailManger alloc] init];
    manger.accidentId = _accidentId;
    
    LRShowHUD *hud = [LRShowHUD showWhiteLoadingWithText:@"加载中..." inView:self.view config:nil];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.accidentDetailModel;
            [strongSelf.tb_content reloadData];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            strongSelf.model = nil;
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
        
    }];
    
}

- (void)loadAccidentFastDetail{
    
    WS(weakSelf);
    FastAccidentDetailManger *manger = [[FastAccidentDetailManger alloc] init];
    manger.fastaccidentId = _accidentId;
    
    LRShowHUD *hud = [LRShowHUD showWhiteLoadingWithText:@"加载中..." inView:self.view config:nil];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf, weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {
            strongSelf.model = manger.fastAccidentDetailModel;
            [strongSelf.tb_content reloadData];
        }
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        [hud hide];
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            strongSelf.model = nil;
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
        
    }];
    
}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSInteger count = 0;
    
    if (_model) {
        count += self.arr_content.count;
    }
    
    return count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    WS(weakSelf);
    return [tableView fd_heightForCellWithIdentifier:@"ProcessResultCellID" cacheByIndexPath:indexPath configuration:^(ProcessResultCell *cell) {
        SW(strongSelf, weakSelf);
        cell.title = strongSelf.arr_content[indexPath.row];
        
        if (strongSelf.accidentType == AccidentTypeAccident) {
            
            switch (indexPath.row) {
                case 0:
                    cell.content = strongSelf.model.accident.casualties;
                    break;
                case 1:
                    cell.content = strongSelf.model.accident.causes;
                    break;
                case 2:
                    cell.content = strongSelf.model.accident.mediationRecord;
                    break;
                case 3:
                    cell.content = strongSelf.model.accident.memo;
                    break;
                default:
                    break;
            }
        
        }else if (strongSelf.accidentType == AccidentTypeFastAccident){
            
            switch (indexPath.row) {
                case 0:
                    cell.content = strongSelf.model.accident.responsibility;
                    break;
                case 1:
                    cell.content = strongSelf.model.accident.memo;
                    break;
                default:
                    break;
            }
        
        }
        
    }];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {


    ProcessResultCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ProcessResultCellID"];
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.title = _arr_content[indexPath.row];
    
    if (_accidentType == AccidentTypeAccident) {
        
        switch (indexPath.row) {
            case 0:
                cell.content = _model.accident.casualties;
                break;
            case 1:
                cell.content = _model.accident.causes;
                break;
            case 2:
                cell.content = _model.accident.mediationRecord;
                break;
            case 3:
                cell.content = _model.accident.memo;
                break;
            default:
                break;
        }
        
    }else if (_accidentType == AccidentTypeFastAccident){
        
        switch (indexPath.row) {
            case 0:
                cell.content = _model.accident.responsibility;
                break;
            case 1:
                cell.content = _model.accident.memo;
                break;
            default:
                break;
        }
        
    }
    return cell;
    

}



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    LxPrintf(@"AccidentProcessResultVC dealloc");

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

//
//  JointEnforceVC.m
//  移动采集
//
//  Created by hcat on 2017/11/29.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "JointEnforceVC.h"
#import "UITableView+FDTemplateLayoutCell.h"

#import "JointImageCell.h"
#import "JointVideoCell.h"
#import "JointTextCell.h"

#import "JointLawAPI.h"

@interface JointEnforceVC ()

@property(nonatomic,weak) IBOutlet UIView *v_bottom;
@property(weak,nonatomic) IBOutlet UIButton *btn_bottom;
@property(nonatomic,weak) IBOutlet UITableView *tableView;

@property(nonatomic,strong) JointLawSaveParam *param;   //上传的参数
@property (nonatomic,strong) NSMutableArray <JointLawImageModel *> *imageList;//要上传图片数据

@end

@implementation JointEnforceVC

- (void)viewDidLoad {
    
    self.title = @"联合执法";
    [super viewDidLoad];

    self.imageList = [NSMutableArray array];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(imageDoneNotification:) name:NOTIFICATION_RELOADJOINTLAWIMAGE object:nil];
    
    //重新定位下
    [[LocationHelper sharedDefault] startLocation];
    
    _v_bottom.layer.shadowColor = UIColorFromRGB(0x444444).CGColor;//shadowColor阴影颜色
    _v_bottom.layer.shadowOffset = CGSizeMake(0,-2);
    _v_bottom.layer.shadowOpacity = 0.1;
    _v_bottom.layer.shadowRadius = 2;
    
    [_tableView registerNib:[UINib nibWithNibName:@"JointImageCell" bundle:nil] forCellReuseIdentifier:@"JointImageCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"JointVideoCell" bundle:nil] forCellReuseIdentifier:@"JointVideoCellID"];
    [_tableView registerNib:[UINib nibWithNibName:@"JointTextCell" bundle:nil] forCellReuseIdentifier:@"JointTextCellID"];
    
}

#pragma mark - 配置UI部分




#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        return [tableView fd_heightForCellWithIdentifier:@"JointImageCellID" cacheByIndexPath:indexPath configuration:^(JointImageCell *cell) {
            
        }];
    }else if (indexPath.row == 1){
        return [tableView fd_heightForCellWithIdentifier:@"JointVideoCellID" cacheByIndexPath:indexPath configuration:^(JointVideoCell *cell) {
            
        }];
        
    }else{
        
        return 785;
        
    }
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        JointImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JointImageCellID"];
        cell.fd_enforceFrameLayout = NO;
        cell.imageList = _imageList;
         return cell;
        
    }else if (indexPath.row == 1){
        JointVideoCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JointVideoCellID"];
        cell.fd_enforceFrameLayout = NO;
        
        return cell;
    }else{
        JointTextCell *cell = [tableView dequeueReusableCellWithIdentifier:@"JointTextCellID"];
        cell.param = _param;
        
        return cell;
    }
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

#pragma mark - noticaiton

- (void)imageDoneNotification:(NSNotification *)notification{
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:0 inSection:0];
    [_tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"JointEnforceVC dealloc");
}

@end

//
//  SpecialVehicleDetailVC.m
//  移动采集
//
//  Created by hcat on 2018/9/10.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "SpecialVehicleDetailVC.h"
#import "SpecialCarAPI.h"
#import "NetWorkHelper.h"
#import <UIImageView+WebCache.h>

@interface SpecialVehicleDetailVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;

@property (weak, nonatomic) IBOutlet UILabel *lb_group;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_address;
@property (weak, nonatomic) IBOutlet UILabel *lb_equipment;
@property (weak, nonatomic) IBOutlet UIImageView *imgv_carImage;

@end

@implementation SpecialVehicleDetailVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    [self updateUI];
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    

}


#pragma mark - updateUI

- (void)updateUI{
    _lb_carNumber.text = [ShareFun takeStringNoNull:_model.carno];
    _lb_group.text = [ShareFun takeStringNoNull:_model.groupName];
    _lb_time.text = [ShareFun takeStringNoNull:[ShareFun timeWithTimeInterval:_model.happenTime]];
    _lb_address.text = [ShareFun takeStringNoNull:_model.address];
    _lb_equipment.text = [ShareFun takeStringNoNull:_model.devno];
    if (_model.originalPic && _model.originalPic.length > 0) {
         [_imgv_carImage sd_setImageWithURL:[NSURL URLWithString:_model.originalPic] placeholderImage:[UIImage imageNamed:@"icon_imageLoading.png"]];
    }else{
        _imgv_carImage.hidden = YES;
    }
   
}



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"SpecialVehicleDetailVC dealloc");
    
}

@end

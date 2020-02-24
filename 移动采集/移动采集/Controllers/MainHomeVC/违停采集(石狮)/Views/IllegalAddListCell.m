//
//  IllegalAddListCell.m
//  移动采集
//
//  Created by hcat-89 on 2020/2/19.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalAddListCell.h"
#import "IllegalReportAbnormalVC.h"
#import "IllegalAddListVC.h"

@interface IllegalAddListCell ()

@property (weak, nonatomic) IBOutlet UILabel *lb_roadName;

@property (weak, nonatomic) IBOutlet UILabel *lb_carNumber;

@property (weak, nonatomic) IBOutlet UILabel *lb_time;

@property (weak, nonatomic) IBOutlet UILabel *lb_people;

@property (weak, nonatomic) IBOutlet UILabel *lb_statues;
@property (weak, nonatomic) IBOutlet UIImageView *image_statues;

@property (weak, nonatomic) IBOutlet UILabel *lb_unStatues; //未生效

@property (weak, nonatomic) IBOutlet UIButton *btn_more;  //更多内容按钮

@property (weak, nonatomic) IBOutlet UIView *view_more; //更多功能视图

@property (weak, nonatomic) IBOutlet UIButton *btn_upAbnormal;  //上报异常按钮
@property (weak, nonatomic) IBOutlet UIButton *btn_notice;      //通知按钮

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_carNo_leading;


@end


@implementation IllegalAddListCell

- (void)awakeFromNib {
    
    self.image_statues.layer.cornerRadius = 3.f;
    self.view_more.hidden = YES;
    
    @weakify(self);
    [super awakeFromNib];
    
    [RACObserve(self, model) subscribeNext:^(IllegalParkListModel * _Nullable x) {
        @strongify(self);
        
        self.lb_roadName.text = x.address;
        self.lb_carNumber.text = [ShareFun takeStringNoNull:x.carNo];
        self.lb_time.text = [ShareFun timeWithTimeInterval:x.collectTime];
        self.lb_people.text = [ShareFun takeStringNoNull:x.operatorName];
        if ([x.state isEqualToNumber:@0]) {
            //未生效。
            self.image_statues.hidden  = YES;
            self.lb_statues.hidden = YES;
            self.layout_carNo_leading.constant = 15.f;
            [self layoutIfNeeded];
            self.btn_more.hidden = YES;
            self.lb_unStatues.hidden = NO;
            self.lb_unStatues.text = @"未生效";
        }else if ([x.state isEqualToNumber:@1]){
            //已生效。可以进行上报异常
            self.image_statues.hidden  = YES;
            self.lb_statues.hidden = YES;
            self.layout_carNo_leading.constant = 15.f;
            [self layoutIfNeeded];
            self.btn_more.hidden = NO;
            self.lb_unStatues.hidden = YES;
            self.lb_unStatues.text = @"已生效";
            [self.btn_upAbnormal setTitle:@"上报异常" forState:UIControlStateNormal];
        }else if ([x.state isEqualToNumber:@8]){
            //异常处理中
            self.image_statues.hidden  = NO;
            self.lb_statues.hidden = NO;
            self.lb_statues.text = @"上报异常";
            self.layout_carNo_leading.constant = 91.f;
            [self layoutIfNeeded];
            self.btn_more.hidden = NO;
            self.lb_unStatues.hidden = YES;
            self.lb_unStatues.text = @"已生效";
            [self.btn_upAbnormal setTitle:@"确认异常" forState:UIControlStateNormal];
        }else if ([x.state isEqualToNumber:@9]){
            self.image_statues.hidden  = NO;
            self.lb_statues.hidden = NO;
            self.lb_statues.text = @"确认异常";
            self.layout_carNo_leading.constant = 91.f;
            [self layoutIfNeeded];
            self.btn_more.hidden = YES;
            self.lb_unStatues.hidden = YES;
            self.lb_unStatues.text = @"已生效";
        }
        
    }];
    
    
    [[self.btn_more rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        self.view_more.hidden = !self.view_more.hidden;
        
    }];
    
    [[self.btn_upAbnormal rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        if ([self.model.state isEqualToNumber:@1]){
            
            IllegalReportAbnormalViewModel * viewModel = [[IllegalReportAbnormalViewModel alloc] init];
            viewModel.illegalPark = self.model;
            viewModel.param.illegalId = self.model.illegalParkId;
            
            [viewModel.subject subscribeNext:^(id  _Nullable x) {
                @strongify(self);
                UITableView * tableView = [ShareFun getTableView:self];
                [tableView reloadData];
                
            }];
            
            IllegalReportAbnormalVC * vc = [[IllegalReportAbnormalVC alloc] initWithViewModel:viewModel];
            IllegalAddListVC * t_vc = (IllegalAddListVC *)[ShareFun findViewController:self withClass:[IllegalAddListVC class]];
            [t_vc.navigationController pushViewController:vc animated:YES];
            
        }else if ([self.model.state isEqualToNumber:@8]){
            
            if ([self.permission boolValue] == NO) {
                [LRShowHUD showWarning:@"您无权限确认" duration:1.5f];
                return;
            }
            
            IllegalMakeSureAbnormalManger * manger = [[IllegalMakeSureAbnormalManger alloc] init];
            manger.illegalParkId = self.model.illegalParkId;;
            [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                @strongify(self);
                if (manger.responseModel.code == CODE_SUCCESS) {
                    
                    self.model.state = @9;
                    self.model.stateName = @"异常";
                    
                    UITableView * tableView = [ShareFun getTableView:self];
                    [tableView reloadData];
                    
                }else{
                    [LRShowHUD showError:@"确认异常失败" duration:1.5f];
                }
            } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                [LRShowHUD showError:@"确认异常失败" duration:1.5f];
            }];
            
        }
        
    }];
    
    [[self.btn_notice rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        
        
    }];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end

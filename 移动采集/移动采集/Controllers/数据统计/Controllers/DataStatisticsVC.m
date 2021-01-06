//
//  DataStatisticsVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/11/11.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "DataStatisticsVC.h"
#import "PieChart.h"
#import "BottomPickerView.h"
#import "BottomView.h"
#import "DataStatisticsListVC.h"

@interface DataStatisticsVC ()

@property (weak, nonatomic) IBOutlet UILabel *lb_thirty;

@property (weak, nonatomic) IBOutlet UILabel *lb_sixty;

@property (weak, nonatomic) IBOutlet UILabel *lb_ninety;

@property (weak, nonatomic) IBOutlet UIButton *btn_select;

@property (weak, nonatomic) IBOutlet UIView *v_goucheng;

@property (weak, nonatomic) IBOutlet UIButton *btn_one;
@property (weak, nonatomic) IBOutlet UIButton *btn_two;
@property (weak, nonatomic) IBOutlet UIButton *btn_three;



@property (nonatomic, strong) PieChart * pieChart;
@property (nonatomic, strong) PieData * pie;


@property(nonatomic, strong) DataStatisticsViewModel * viewModel;

@end

@implementation DataStatisticsVC

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.viewModel = [[DataStatisticsViewModel alloc] init];
        
    }
    
    return self;
    
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    @weakify(self);
    
    self.viewModel.accidentState = @0;
    
    self.btn_select.layer.cornerRadius = 29/2.f;
    self.btn_select.layer.borderWidth = 1.0f;
    self.btn_select.layer.borderColor = UIColorFromRGB(0x999999).CGColor;
    
    [[self.btn_select rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        NSArray *items = @[@"未结案",@"已结案"];
        BottomPickerView *t_view = [BottomPickerView initCustomView];
        [t_view setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 207)];
        t_view.pickerTitle = @"事故类型";
        t_view.items = items;
        t_view.selectedBtnBlock = ^(NSArray *items, NSInteger index) {
            @strongify(self);
            self.viewModel.accidentState = @(index);
            [self.viewModel.command_list execute:nil];
            [self.btn_select setTitle:items[index] forState:UIControlStateNormal];
            [BottomView dismissWindow];
        };
        
        [BottomView showWindowWithBottomView:t_view];
        
        
        
    }];
    
    
    [[self.btn_one rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        
        DataStatisticsListViewModel * viewModel = [[DataStatisticsListViewModel alloc] init];
        viewModel.accidentState = self.viewModel.accidentState;
        viewModel.timeType = @"1";
        DataStatisticsListVC * vc = [[DataStatisticsListVC alloc] initWithViewModel:viewModel];
        vc.title = @"本月采集";
        [self.navigationController pushViewController:vc animated:YES];
        
    }];
    
    
    [[self.btn_two rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        DataStatisticsListViewModel * viewModel = [[DataStatisticsListViewModel alloc] init];
        viewModel.accidentState = self.viewModel.accidentState;
        viewModel.timeType = @"2";
        DataStatisticsListVC * vc = [[DataStatisticsListVC alloc] initWithViewModel:viewModel];
        vc.title = @"上个月采集";
        [self.navigationController pushViewController:vc animated:YES];
    
    }];
    
    
    [[self.btn_three rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        DataStatisticsListViewModel * viewModel = [[DataStatisticsListViewModel alloc] init];
        viewModel.accidentState = self.viewModel.accidentState;
        viewModel.timeType = @"3";
        DataStatisticsListVC * vc = [[DataStatisticsListVC alloc] initWithViewModel:viewModel];
        vc.title = @"2个月前采集";
        [self.navigationController pushViewController:vc animated:YES];
    
    }];
    
    
    
    
    
    [self.viewModel.command_list.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        
        if ([x isKindOfClass:[DataStatisticsReponse class]]) {
    
            
            DataStatisticsReponse * t_data = (DataStatisticsReponse *)x;
            
            //电量构成
            if (self.pieChart) {
                [self.pieChart removeFromSuperview];
            }
            
            self.lb_thirty.text = [NSString stringWithFormat:@"%d",[t_data.thirty intValue]];
            self.lb_sixty.text = [NSString stringWithFormat:@"%d",[t_data.sixty intValue]];
            self.lb_ninety.text = [NSString stringWithFormat:@"%d",[t_data.ninety intValue]];
          
            NSArray * pieColors = @[UIColorFromRGB(0x4BD287), UIColorFromRGB(0xFDA731), UIColorFromRGB(0x3396FC)];
             
            NSArray * dataAry = @[t_data.thirty, t_data.sixty, t_data.ninety];
             
            PieData * pie = [[PieData alloc] init];
            pie.radiusRange = GGRadiusRangeMake(GG_SIZE_CONVERT(65), GG_SIZE_CONVERT(90));
            pie.showOutLableType = OutSideNormal;
            //pie.pieStartTransform = 1.5;
            pie.roseType = RoseNormal;
            pie.dataAry = dataAry;
            
            self.pie = pie;
             
            [pie setPieColorsForIndex:^UIColor *(NSInteger index, CGFloat ratio) {
                return pieColors[index];
            }];

            PieDataSet * pieDataSet = [[PieDataSet alloc] init];
            pieDataSet.pieAry = @[pie];
            pieDataSet.showCenterLable = NO;
             
            [pieDataSet.centerLable.lable setAttrbuteStringValueBlock:^NSAttributedString *(CGFloat value) {
                NSString * text = @" ";
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text];
                [attributedText addAttribute:NSFontAttributeName value:[UIFont fontWithName:@"PingFangSC-Regular" size:12] range:NSMakeRange(0, text.length)];
                [attributedText addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x666666) range:NSMakeRange(0, text.length)];
                
                return attributedText;
             
            }];
             
            self.pieChart = [[PieChart alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH- 216, SCREEN_WIDTH- 216)];
            
            self.pieChart.pieDataSet = pieDataSet;
            [self.pieChart drawPieChart];
            [self.pieChart startAnimationsWithType:RotationAnimation duration:.5f];
            self.pieChart.center = CGPointMake((SCREEN_WIDTH- 216)/2, (SCREEN_WIDTH- 216)/2);
            [self.v_goucheng addSubview:self.pieChart];
            
            
        }
    
    }];
    
    
    [self.viewModel.command_list execute:nil];
    
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

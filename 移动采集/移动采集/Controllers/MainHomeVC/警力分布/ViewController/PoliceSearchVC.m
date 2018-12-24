//
//  PoliceSearchVC.m
//  移动采集
//
//  Created by hcat on 2018/12/20.
//  Copyright © 2018 Hcat. All rights reserved.
//

#import "PoliceSearchVC.h"
#import "PoliceSearchCell.h"
#import "SearchTagHelper.h"
#import "PoliceDistributeVC.h"

@interface PoliceSearchVC ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_navHeight;
@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UIButton *btn_cancel;
@property (weak, nonatomic) IBOutlet UIButton *btn_type;

@property (weak, nonatomic) IBOutlet UIView *v_type;
@property (weak, nonatomic) IBOutlet UIButton *btn_police;
@property (weak, nonatomic) IBOutlet UILabel *lb_police;
@property (weak, nonatomic) IBOutlet UIImageView *img_police;


@property (weak, nonatomic) IBOutlet UIButton *btn_location;
@property (weak, nonatomic) IBOutlet UILabel *lb_location;
@property (weak, nonatomic) IBOutlet UIImageView *img_location;

@property (weak, nonatomic) IBOutlet UIButton *btn_car;
@property (weak, nonatomic) IBOutlet UILabel *lb_car;
@property (weak, nonatomic) IBOutlet UIImageView *img_car;


@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) PoliceSearchViewModel * viewModel;

@end

@implementation PoliceSearchVC


- (instancetype) initWithViewModel:(PoliceSearchViewModel *)viewModel{
    
    if (self = [super init]) {
        self.viewModel = viewModel;
    
    }
    
    return self;
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self configUI];
    
    @weakify(self);
    
    [[self.btn_cancel rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self.navigationController popViewControllerAnimated:YES];
    }];
    
    [[self.btn_type rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.v_type.hidden = NO;
        
    }];
    
    [[self.btn_police rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.type = @1;
        self.v_type.hidden = YES;
    }];
    
    [[self.btn_location rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.type = @3;
        self.v_type.hidden = YES;
    }];
    
    [[self.btn_car rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.viewModel.type = @2;
        self.v_type.hidden = YES;
    }];
    
    [self.viewModel.searchCommand.executionSignals.switchToLatest subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [self.viewModel.searchSubject subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        [self.tableView reloadData];
    }];
    
    [RACObserve(self.viewModel, type) subscribeNext:^(NSNumber *  _Nullable x) {
        @strongify(self);
        if ([x integerValue] == 1) {
            //警员
            [self.btn_type setTitle:@"警员" forState:UIControlStateNormal];
            self.lb_police.textColor = DefaultColor;
            self.lb_location.textColor = UIColorFromRGB(0x666666);
            self.lb_car.textColor = UIColorFromRGB(0x666666);
            self.img_police.hidden = NO;
            self.img_location.hidden = YES;
            self.img_car.hidden = YES;
    
        }else if ([x integerValue] == 3){
            //位置
            [self.btn_type setTitle:@"位置" forState:UIControlStateNormal];
            self.lb_police.textColor = UIColorFromRGB(0x666666);
            self.lb_location.textColor = DefaultColor;
            self.lb_car.textColor = UIColorFromRGB(0x666666);
            self.img_police.hidden = NO;
            self.img_location.hidden = YES;
            self.img_car.hidden = YES;
            
        }else if ([x integerValue] == 2){
            [self.btn_type setTitle:@"警车" forState:UIControlStateNormal];
            self.lb_police.textColor = UIColorFromRGB(0x666666);
            self.lb_location.textColor = UIColorFromRGB(0x666666);
            self.lb_car.textColor = DefaultColor;
            self.img_police.hidden = YES;
            self.img_location.hidden = YES;
            self.img_car.hidden = NO;
            
        }
        
        if (self.viewModel.keywords.length > 0) {
            [self.viewModel.searchCommand execute:nil];
        }
    
    }];
    
    [RACObserve(self.viewModel, keywords) subscribeNext:^(id  _Nullable x) {
        @strongify(self);
        self.tf_search.text = x;
    }];
    
    
    [self.tf_search.rac_textSignal subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        self.viewModel.keywords = x;
    }];
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [super viewWillAppear:animated];
    
}


#pragma mark - configUI

- (void)configUI{

    if (IS_IPHONE_X_MORE){
        _layout_navHeight.constant = _layout_navHeight.constant + 24;
    }
    
    self.v_type.hidden = YES;
    
    [_tableView registerNib:[UINib nibWithNibName:@"PoliceSearchCell" bundle:nil] forCellReuseIdentifier:@"PoliceSearchCellID"];
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    _tableView.estimatedRowHeight = 44.0;
    _tableView.rowHeight = UITableViewAutomaticDimension;
    
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.viewModel.arr_data.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    PoliceSearchCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PoliceSearchCellID" forIndexPath:indexPath];
    cell.viewModel = self.viewModel.arr_data[indexPath.row];
    [cell layoutIfNeeded];
    return cell;
    
    return nil;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    RACTuple *tuple = nil;
    
    PoliceSearchCellViewModel *cellViewModel = self.viewModel.arr_data[indexPath.row];
    if ([cellViewModel.type isEqualToNumber:@1]) {
        
        tuple = RACTuplePack(cellViewModel.policeModel.latitude,cellViewModel.policeModel.longitude);
    }else if ([cellViewModel.type isEqualToNumber:@2]){
        tuple = RACTuplePack(cellViewModel.carModel.latitude,cellViewModel.carModel.longitude);
    }else if ([cellViewModel.type isEqualToNumber:@3]){
        tuple = RACTuplePack(@(cellViewModel.poi.location.latitude),@(cellViewModel.poi.location.longitude));
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_POLICE_SEARCH object:tuple];
    
    for(UIViewController *controller in self.navigationController.viewControllers) {
        
        if([controller isKindOfClass:[PoliceDistributeVC class]]) {
            
            [self.navigationController popToViewController:controller animated:YES];
            
        }
        
    }
    
   
}

#pragma mark - textFeildDelegate

-(BOOL) textFieldShouldReturn:(UITextField*) textField
{
    [textField resignFirstResponder];
    if (textField.text.length > 0) {
        [SearchTagHelper SaveSearchText:textField.text];
        [self.viewModel.searchCommand execute:nil];
    }
    
    return YES;
    
}




#pragma mark - dealloc

- (void)dealloc{
    NSLog(@"PoliceSearchVC dealloc");
    
}

@end

//
//  AccidentPeopleVC.m
//  移动采集
//
//  Created by hcat on 2018/7/20.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentPeopleVC.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "AccidentPeopleChangeCell.h"
#import "UINavigationBar+BarItem.h"

@interface AccidentPeopleVC ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,assign) BOOL isShowMoreInfo;

@end

@implementation AccidentPeopleVC

@synthesize model = _model;

- (instancetype)init{
    
    if (self = [super init]) {
        self.index = 0;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShowMoreInfo = YES;
    [_tableView registerNib:[UINib nibWithNibName:@"AccidentPeopleChangeCell" bundle:nil] forCellReuseIdentifier:@"AccidentPeopleChangeCellID"];

}

#pragma mark - set && get

- (void)setModel:(AccidentPeopleMapModel *)t_model{
    
    _model = t_model;
    
    self.title = @"修改当事人";
}

- (AccidentPeopleMapModel *)model{
    
    if (_model == nil) {
        self.title = @"添加当事人";
        _model = [[AccidentPeopleMapModel alloc] init];
        _model.sorting = @(_index);
    }
    
    return _model;
}

- (void)setArrayCount:(NSInteger)arrayCount{
    
    if (arrayCount > 2) {
        [self showRightBarButtonItemWithImage:@"nav_accident_delete" target:self action:@selector(handleBtnDeleteClicked:)];
    }
    
}

#pragma mark - UITableViewDelegate


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    
    if (indexPath.row == 0) {
        
        WS(weakSelf);
        height = [tableView fd_heightForCellWithIdentifier:@"AccidentPeopleChangeCellID"  configuration:^(AccidentPeopleChangeCell *cell) {
            SW(strongSelf,weakSelf);
            cell.isShowMoreInfo = strongSelf.isShowMoreInfo;
            cell.accidentType = strongSelf.accidentType;
        }];
        
    }
    
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AccidentPeopleChangeCell * cell = [tableView dequeueReusableCellWithIdentifier:@"AccidentPeopleChangeCellID"];
    cell.isShowMoreInfo = self.isShowMoreInfo;
    cell.accidentType = self.accidentType;
    WS(weakSelf);
    cell.block = ^(BOOL isShowMoreInfo) {
        SW(strongSelf, weakSelf);
        strongSelf.isShowMoreInfo = isShowMoreInfo;
    };
    cell.model = self.model;
    
    return  cell;
    
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


#pragma mark - buttonAction

- (IBAction)handleBtnMakeSureClicked:(id)sender {
    
    //当默认未设置index的时候表示修改
    if (self.index == 0) {
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCIDENTPEOPLE_MAKESURE object:nil];
    }else{
        //当index有值的时候表示新增
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCIDENTPEOPLE_MAKESURE object:self.model];
        
    }

    [self.navigationController popViewControllerAnimated:YES];
}



- (void)handleBtnDeleteClicked:(id)sender{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_ACCIDENTPEOPLE_DELETE object:self.model];
    [self.navigationController popViewControllerAnimated:YES];
    
}


#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    LxPrintf(@"AccidentPeopleVC dealloc");
    
}
@end

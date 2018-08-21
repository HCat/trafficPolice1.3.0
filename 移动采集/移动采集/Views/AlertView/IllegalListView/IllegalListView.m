//
//  IllegalListView.m
//  移动采集
//
//  Created by hcat on 2018/8/15.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalListView.h"
#import "IllegalListCell.h"
#import "AlertView.h"

@interface IllegalListView()


@property (weak, nonatomic) IBOutlet UILabel *lb_deckCarNo;
@property (weak, nonatomic) IBOutlet UIButton *btn_caiji;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *layout_tableViewTop;


@end

@implementation IllegalListView

+ (IllegalListView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"IllegalListView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
   
}

- (void)setIllegalList:(NSArray<IllegalListModel *> *)illegalList{
    
    _illegalList = illegalList;
    
}

- (void)setDeckCarNo:(NSString *)deckCarNo{
    
    _deckCarNo = deckCarNo;
    
    if (_deckCarNo && _deckCarNo.length > 0) {
        self.layout_tableViewTop.constant = 27.f;
        self.lb_deckCarNo.hidden = NO;
        self.lb_deckCarNo.text = _deckCarNo;
        
    }else{
        self.layout_tableViewTop.constant = 0.f;
        self.lb_deckCarNo.hidden = YES;
        
    }
    
    [self layoutSubviews];
    
}

- (void)setBtnTitleString:(NSString *)btnTitleString{
    _btnTitleString = btnTitleString;
    
    [self.btn_caiji setTitle:_btnTitleString forState:UIControlStateNormal];
    
    
}

#pragma mark - UITableViewDelegate && Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _illegalList.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IllegalListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalListCellID"];
    
    if (cell == nil) {
        [_tableView registerNib:[UINib nibWithNibName:@"IllegalListCell" bundle:nil] forCellReuseIdentifier:@"IllegalListCellID"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalListCellID"];
    }
    if (_illegalList) {
        cell.model = _illegalList[indexPath.row];
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    IllegalListModel * model = _illegalList[indexPath.row];
    if (self.selectedBlock) {
        self.selectedBlock(model.illegalId);
    }
    
}




- (IBAction)handleBtnQuitClicked:(id)sender {
    
    if (self.block) {
        self.block(ParkAlertActionTypeLeft);
    }
    
    AlertView * alertView = (AlertView *)self.superview;
    [alertView handleBtnDismissClick:nil];
    
}

- (IBAction)handleBtnCollectClicked:(id)sender {
    
    if (self.block) {
        self.block(ParkAlertActionTypeRight);
    }
    
    AlertView * alertView = (AlertView *)self.superview;
    
    [alertView handleBtnDismissClick:nil];
    
}


@end

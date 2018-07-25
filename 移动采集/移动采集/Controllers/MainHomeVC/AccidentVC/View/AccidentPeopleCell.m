//
//  AccidentPeopleCell.m
//  移动采集
//
//  Created by hcat on 2018/7/12.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentPeopleCell.h"
#import "LRSliderView.h"
#import "AccidentPeopleView.h"
#import <UITableView+YYAdd.h>
#import "AccidentManageVC.h"
#import "AccidentPeopleVC.h"

@interface AccidentPeopleCell()<LRSliderViewDelegate>

@property (weak, nonatomic) IBOutlet LRSliderView *sliderView;

@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *viewsArray;

@property (weak, nonatomic) IBOutlet UIButton *addButton;

@end


@implementation AccidentPeopleCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.sliderView.delegate = self;
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAccidentMakeSureNotification:) name:NOTIFICATION_ACCIDENTPEOPLE_MAKESURE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAccidentDeleteNotification:) name:NOTIFICATION_ACCIDENTPEOPLE_DELETE object:nil];
    self.titleArray = [NSMutableArray arrayWithArray:@[@"1号", @"2号", @"3号", @"4号",@"5号"]];
    self.viewsArray = [NSMutableArray array];
}

#pragma mark -set&&get

- (void)setPeopleArray:(NSMutableArray *)peopleArray{
    
    _peopleArray = peopleArray;
    
    if (_peopleArray.count >= 5) {
        self.addButton.hidden = YES;
    }else{
        self.addButton.hidden = NO;
    }
    
    if (_peopleArray && _peopleArray.count > 0) {
        
        if (self.viewsArray.count > 0) {
            [self.viewsArray removeAllObjects];
        }
        
        WS(weakSelf);
        for (int i = 0; i < _peopleArray.count; i++) {
            AccidentPeopleMapModel *t_model = _peopleArray[i];
            t_model.sorting = @(i + 1);
            AccidentPeopleView *t_view = [AccidentPeopleView initCustomView];
            t_view.index = i;
            
            t_view.block = ^(NSInteger index) {
                SW(strongSelf, weakSelf);
                AccidentManageVC *vc = (AccidentManageVC *)[ShareFun findViewController:self withClass:[AccidentManageVC class]];
                AccidentPeopleVC  *peopleVC = [[AccidentPeopleVC alloc] init];
                peopleVC.accidentType = strongSelf.accidentType;
                peopleVC.model = strongSelf.peopleArray[index];
                peopleVC.arrayCount = strongSelf.peopleArray.count;
                [vc.navigationController pushViewController:peopleVC animated:YES];
            };
            t_view.accidentType = self.accidentType;
            t_view.model = t_model;
            [self.viewsArray addObject:t_view];
        }
        
        [self.sliderView reloadData];
    }
    
}

#pragma mark - LRSliderViewDelegate


- (NSInteger)numberOfItemsInSliderView:(LRSliderView *)sliderView{
    return _peopleArray.count;
    
}

- (UIView *)sliderView:(LRSliderView *)sliderView viewForItemAtIndex:(NSInteger)index{
    
    return self.viewsArray[index];
    
}

- (NSString *)sliderView:(LRSliderView *)sliderView titleForItemAtIndex:(NSInteger)index{
    
    return self.titleArray[index];
    
}

//当视图滚动到指定页面之后需要做的操作
- (void)sliderViewScrolledtoPageAtIndex:(NSInteger)index{
    
    [[ShareFun getTableView:self] beginUpdates];
    [[ShareFun getTableView:self] endUpdates];

    [self.sliderView reloadData];
}


#pragma mark -

- (CGFloat)heightOfCell{
    
    if (self.sliderView.currentIndex >= self.viewsArray.count) {
        [self.sliderView scrollToIndex:self.viewsArray.count - 1 animated:YES];
        
    }
    AccidentPeopleView *t_view = self.viewsArray[self.sliderView.currentIndex];

    return t_view.height;
   

}


#pragma mark - buttonAction

- (IBAction)handleBtnAddPeopleClicked:(id)sender {
    
    AccidentManageVC *vc = (AccidentManageVC *)[ShareFun findViewController:self withClass:[AccidentManageVC class]];
    
    AccidentPeopleVC  *peopleVC = [[AccidentPeopleVC alloc] init];
    peopleVC.accidentType = _accidentType;
    peopleVC.index = self.peopleArray.count + 1;
    
    [vc.navigationController pushViewController:peopleVC animated:YES];
    
}


#pragma mark - notification

- (void)handleAccidentMakeSureNotification:(NSNotification *)sender{
    
    AccidentPeopleMapModel *t_model = (AccidentPeopleMapModel *)sender.object;
    
    if (t_model) {
        [self.peopleArray addObject:t_model];
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [[ShareFun getTableView:self] reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
    [self sliderViewScrolledtoPageAtIndex:self.sliderView.currentIndex];

}

- (void)handleAccidentDeleteNotification:(NSNotification *)sender{
    
    AccidentPeopleMapModel *t_model = (AccidentPeopleMapModel *)sender.object;
    
    if (t_model) {
        [self.peopleArray removeObject:t_model];
    }
    
    NSIndexPath *indexPath=[NSIndexPath indexPathForRow:2 inSection:0];
    [[ShareFun getTableView:self] reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
    
}


#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"AccidentPeopleCell dealloc");
    
}

@end

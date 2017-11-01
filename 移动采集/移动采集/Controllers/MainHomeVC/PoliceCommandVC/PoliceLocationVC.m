//
//  PoliceLocationVC.m
//  移动采集
//
//  Created by hcat on 2017/9/13.
//  Copyright © 2017年 Hcat. All rights reserved.
//

#import "PoliceLocationVC.h"
#import "CommonMenuView.h"
#import "UITableView+Lr_Placeholder.h"

#import <AMapFoundationKit/AMapFoundationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>

#import "PoliceLocationCell.h"

@interface PoliceLocationVC ()<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;

@property (nonatomic,strong) UIButton * btn_right;
@property (nonatomic,strong) NSNumber * range;

@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSMutableArray *arr_content;


@end

@implementation PoliceLocationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索地址";
    
    self.range = @3;
    self.arr_content = [NSMutableArray array];
    
    [self showRightBarButtonItemWithTitle:[NSString stringWithFormat:@"%ldkm",[self.range integerValue]] BgImageName:@"nav_rightShow" target:self action:@selector(showPopMenuTableView:)];
    
    [self initPopMenuTableView];
    
    
    _tableView.isNeedPlaceholderView = YES;
    _tableView.str_placeholder = @"暂无搜索内容";
    _tableView.firstReload = YES;
    _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [_tableView setSeparatorInset:UIEdgeInsetsZero];
    [_tableView setLayoutMargins:UIEdgeInsetsZero];
    
    [_tf_search addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
 
    self.search = [[AMapSearchAPI alloc] init];
    self.search.delegate = self;
    
}

#pragma mark - 加载新数据

- (void)loadData{

    AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
    request.keywords = _tf_search.text;
    request.city                = [LocationHelper sharedDefault].city;
    request.cityLimit           = YES;
    //request.requireSubPOIs      = YES;
    
    [self.search AMapPOIKeywordsSearch:request];
    

}
#pragma mark - 导航栏右边按钮

- (void)showRightBarButtonItemWithTitle:(NSString *)title BgImageName:(NSString *)imageName target:(id)target action:(SEL)action {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
    /// Set line break mode
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    /// Set text alignment
    //paragraphStyle.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{ NSFontAttributeName: [UIFont systemFontOfSize:12],
                                  //NSForegroundColorAttributeName:_textColor ? _textColor : textColor,
                                  NSParagraphStyleAttributeName: paragraphStyle };
    
    CGSize size = [title boundingRectWithSize:CGSizeMake(100, 28) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attributes context:nil].size;
    
    CGRect buttonFrame = CGRectMake(0, 0, size.width + 20.0f, 28);
    self.btn_right = [UIButton buttonWithType:UIButtonTypeCustom];
    _btn_right.contentMode = UIViewContentModeScaleToFill;
    _btn_right.backgroundColor = [UIColor clearColor];
    _btn_right.frame = buttonFrame;
    [_btn_right setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btn_right.titleLabel setFont:[UIFont systemFontOfSize:15]];
    [_btn_right setTitle:title forState:UIControlStateNormal];
    if(imageName.length > 0)
    {
        [_btn_right setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        [_btn_right setTitleEdgeInsets:UIEdgeInsetsMake(0, -25, 0, 0)];
        [_btn_right setImageEdgeInsets:UIEdgeInsetsMake(0, 35, 0, 0)];
    
    }
    [_btn_right addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:_btn_right];
}

#pragma mark - 初始化弹出框

- (void)initPopMenuTableView{

    NSDictionary *dict1 = @{@"imageName" : @"",
                            @"itemName" : @"1km"
                            };
    NSDictionary *dict2 = @{@"imageName" : @"",
                            @"itemName" : @"3km"
                            };
    NSDictionary *dict3 = @{@"imageName" : @"",
                            @"itemName" : @"5km"
                            };
    NSArray *dataArray = @[dict1,dict2,dict3];
    
    WS(weakSelf);
   
    [CommonMenuView createMenuWithFrame:CGRectZero target:self dataArray:dataArray itemsClickBlock:^(NSString *str, NSInteger tag) {
        SW(strongSelf, weakSelf);
        LxDBAnyVar(str);
        if ([str isEqualToString:@"1km"]) {
            strongSelf.range = @1;
           
        }else if ([str isEqualToString:@"3km"]){
            strongSelf.range = @3;
        }else if ([str isEqualToString:@"5km"]){
            strongSelf.range = @5;
        }
        
        [strongSelf.btn_right  setTitle:str forState:UIControlStateNormal];
        
        [CommonMenuView hidden];
        strongSelf.btn_right.selected = NO;
        
    } backViewTap:^{
        weakSelf.btn_right.selected = NO; // 这里的目的是，让rightButton点击，可再次pop出menu
    }];


}


- (void)showPopMenuTableView:(id)sender{
    
    if (self.btn_right.selected == NO) {
        [CommonMenuView showMenuAtPoint:CGPointMake(self.navigationController.view.frame.size.width - 30, 50)];
        self.btn_right.selected = NO;
    }else{
        [CommonMenuView hidden];
        self.btn_right.selected = YES;
    }
   
}


#pragma mark - 搜索按钮事件

- (IBAction)handleBtnSearchClicked:(id)sender {
    if (_tf_search.text.length == 0) {
        [LRShowHUD showError:@"请输入地址" duration:1.5f];
    }
    
    [self loadData];
    
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_content.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 75;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString * cellIdentifier = @"PoliceLocationCellID";
    PoliceLocationCell * cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil){
        [_tableView registerNib:[UINib nibWithNibName:@"PoliceLocationCell" bundle:nil] forCellReuseIdentifier:@"PoliceLocationCellID"];
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    }
    
    AMapPOI *poi = _arr_content[indexPath.row];
    
    cell.poi = poi;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell setSeparatorInset:UIEdgeInsetsZero];
    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    AMapPOI *poi = _arr_content[indexPath.row];
    
    if (poi) {
        if (self.block) {
            self.block(@(poi.location.latitude), @(poi.location.longitude), _range);
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    
}


#pragma mark - UITextFieldDelegate

-(void)passConTextChange:(id)sender{
    
    UITextField* textField = (UITextField*)sender;
    LxDBAnyVar(textField.text);
    if (textField == _tf_search) {
        [self loadData];
    }
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)theTextField {
    [theTextField resignFirstResponder];

    if (_tf_search.text.length == 0) {
        [LRShowHUD showError:@"请输入地址" duration:1.5f];
        return YES;
    }
    [self loadData];
    return YES;
}


#pragma mark - AMapSearchDelegate
- (void)AMapSearchRequest:(id)request didFailWithError:(NSError *)error
{
    self.arr_content = [NSMutableArray array];
    [self.tableView reloadData];
    [LRShowHUD showError:@"搜索请求失败" duration:1.5f];
    
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response
{
   
    self.arr_content = [response.pois mutableCopy];
    [self.tableView reloadData];
    
}



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{

    [CommonMenuView clearMenu];
    
    LxPrintf(@"PoliceLocationVC dealloc");
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

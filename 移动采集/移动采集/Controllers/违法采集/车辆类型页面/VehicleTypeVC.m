//
//  VehicleTypeVC.m
//  移动采集
//
//  Created by 黄芦荣 on 2021/9/8.
//  Copyright © 2021 Hcat. All rights reserved.
//

#import "VehicleTypeVC.h"
#import "NetWorkHelper.h"
#import "UITableView+Lr_Placeholder.h"


@interface VehicleTypeVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf_search;
@property (weak, nonatomic) IBOutlet UITableView *tb_content;

@property (nonatomic, strong) NSMutableArray * arr_pingyin;

@end

@implementation VehicleTypeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"车辆类型";
    
    self.tb_content.isNeedPlaceholderView = YES;
    self.tb_content.firstReload = YES;
    
    self.arr_pingyin = @[].mutableCopy;
    
    //隐藏多余行的分割线
    self.tb_content.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
//    [self.tb_content setSeparatorInset:UIEdgeInsetsZero];
//    [self.tb_content setLayoutMargins:UIEdgeInsetsZero];
    _tf_search.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 15, 0)];
    //设置显示模式为永远显示(默认不显示)
    _tf_search.leftViewMode = UITextFieldViewModeAlways;

    if (_arr_content == nil) {
        
        [self getVehicleType];
        
    }
    
    WS(weakSelf);
    self.tb_content.reloadBlock = ^{
        
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_content) {
            strongSelf.arr_content = nil;
        }
        strongSelf.tb_content.isNetAvailable = NO;
        
        [self getVehicleType];
        
    };
    
    [_tf_search addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
    
    _tf_search.text = self.search_text;
    [self passConTextChange:_tf_search];
    
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    WS(weakSelf);

    [NetWorkHelper sharedDefault].networkReconnectionBlock = ^{
        SW(strongSelf, weakSelf);
        if (strongSelf.arr_content) {
            strongSelf.arr_content = nil;
        }
        strongSelf.tb_content.isNetAvailable = NO;
        
        [strongSelf getVehicleType];
    };

}




#pragma mark - 获取道路通用值

- (void)getVehicleType{

    WS(weakSelf);
    
    CommonGetVehicleManger *manger = [[CommonGetVehicleManger alloc] init];
    manger.isNeedLoadHud = YES;
    manger.loadingMessage = @"请求中...";

    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf,weakSelf);
        if (manger.responseModel.code == CODE_SUCCESS) {

            strongSelf.arr_content = manger.commonGetVehicleResponse;
            strongSelf.arr_temp =  manger.commonGetVehicleResponse;
            
            for (int i = 0; i < strongSelf.arr_temp.count; i++) {
                
                CommonGetVehicleModel *model = strongSelf.arr_temp[i];
                NSString *pinyin = [self transformToPinyin:model.vehicleName];
                NSLog(@"pinyin--%@",pinyin);
                model.vehicleName_pingyin = pinyin;
        
            }
            
            [strongSelf.tb_content reloadData];
        }
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
        SW(strongSelf,weakSelf);
        Reachability *reach = [Reachability reachabilityWithHostname:@"www.baidu.com"];
        NetworkStatus status = [reach currentReachabilityStatus];
        if (status == NotReachable) {
            strongSelf.tb_content.isNetAvailable = YES;
            [strongSelf.tb_content reloadData];
        }
        
    }];
    
}


#pragma mark - buttonMethods

- (IBAction)handleBtnCancalClicked:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.arr_content) {
        return self.arr_content.count;
    }else{
        return 0;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SearchLocationID"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:@"SearchLocationID"];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    CommonGetVehicleModel *model = _arr_content[indexPath.row];
    cell.textLabel.text = model.vehicleName;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
//    [cell setSeparatorInset:UIEdgeInsetsZero];
//    [cell setLayoutMargins:UIEdgeInsetsZero];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CommonGetVehicleModel *model = _arr_content[indexPath.row];
    if (self.vehicleTypeBlock) {
        self.vehicleTypeBlock(model);
    }

    [self.navigationController popViewControllerAnimated:YES];
    
}





#pragma mark - 实时监听UITextField内容的变化

-(void)passConTextChange:(id)sender{
    UITextField* textField = (UITextField*)sender;
    if (!_arr_temp || _arr_temp.count == 0) {
        return;
    }
    
    if (textField.text.length == 0) {
        self.arr_content = _arr_temp;
        [_tb_content reloadData];
        return;
    }
    
    NSMutableArray *arr = [NSMutableArray array];
    WS(weakSelf);

    [_arr_temp enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        SW(strongSelf, weakSelf);
        CommonGetVehicleModel *model = (CommonGetVehicleModel *)obj;
        
        if ([model.vehicleName_pingyin rangeOfString:textField.text options:NSCaseInsensitiveSearch].length >0 ) {
            //把搜索结果存放self.resultArray数组
            [arr addObject:model];
        }
        
       
    }];
    self.arr_content = [NSArray arrayWithArray:arr];
    [self.tb_content reloadData];
}







#pragma mark--获取汉字转成拼音字符串 通讯录模糊搜索 支持拼音检索 首字母 全拼 汉字 搜索
- (NSString *)transformToPinyin:(NSString *)aString{
    //转成了可变字符串
    NSMutableString *str = [NSMutableString stringWithString:aString];
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformMandarinLatin,NO);
    //再转换为不带声调的拼音
    CFStringTransform((CFMutableStringRef)str,NULL, kCFStringTransformStripDiacritics,NO);
    NSArray *pinyinArray = [str componentsSeparatedByString:@" "];
    NSMutableString *allString = [NSMutableString new];
    
    int count = 0;
    
    for (int  i = 0; i < pinyinArray.count; i++)
    {
        
        for(int i = 0; i < pinyinArray.count;i++)
        {
            if (i == count) {
                [allString appendString:@"#"];//区分第几个字母
            }
            [allString appendFormat:@"%@",pinyinArray[i]];
            
        }
        [allString appendString:@","];
        count ++;
        
    }
    
    NSMutableString *initialStr = [NSMutableString new];//拼音首字母
    
    for (NSString *s in pinyinArray)
    {
        if (s.length > 0)
        {
            
            [initialStr appendString:  [s substringToIndex:1]];
        }
    }
    
    [allString appendFormat:@"#%@",initialStr];
    [allString appendFormat:@",#%@",aString];
    
    return allString;
}



#pragma mark - dealloc

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc{
    
    [NetWorkHelper sharedDefault].networkReconnectionBlock = nil;
    LxPrintf(@"VehicleTypeVC dealloc");
    
}



@end

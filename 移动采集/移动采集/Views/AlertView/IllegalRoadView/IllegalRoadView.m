//
//  IllegalRoadView.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/5/29.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "IllegalRoadView.h"
#import "IllegalRoadCell.h"
#import "AlertView.h"

@interface IllegalRoadView ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end




@implementation IllegalRoadView

+ (IllegalRoadView *)initCustomView{
    NSArray* nibView =  [[NSBundle mainBundle] loadNibNamed:@"IllegalRoadView" owner:self options:nil];
    return [nibView objectAtIndex:0];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self.tableView setDelegate:(id<UITableViewDelegate> _Nullable)self];
    [self.tableView setDataSource:(id<UITableViewDataSource> _Nullable)self];
    
    @weakify(self);
    [RACObserve(self, roadName) subscribeNext:^(NSString * _Nullable x) {
        @strongify(self);
        
        NSMutableArray *arr = [NSMutableArray array];
        [self.arr_content enumerateObjectsWithOptions:NSEnumerationReverse usingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            @strongify(self);
            CommonGetRoadModel *model = (CommonGetRoadModel *)obj;
            
            if ([model.roadName_pingyin rangeOfString:x options:NSCaseInsensitiveSearch].length >0 ) {
                //把搜索结果存放self.resultArray数组
                [arr addObject:model];
            }
                
               
        }];
        self.arr_content = [NSArray arrayWithArray:arr];
        [self.tableView reloadData];
        
        
    }];
   
}

- (void)setArr_content:(NSArray<CommonGetRoadModel *> *)arr_content{
    
    _arr_content = arr_content;
    
    
    for (int i = 0; i < _arr_content.count; i++) {
            CommonGetRoadModel *model = _arr_content[i];
            NSString *pinyin = [self transformToPinyin:model.getRoadName];
            NSLog(@"pinyin--%@",pinyin);
            model.roadName_pingyin = pinyin;
    }
    
}


#pragma mark - UITableViewDelegate && Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_content.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 44;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IllegalRoadCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalRoadCellID"];
    
    if (cell == nil) {
        [_tableView registerNib:[UINib nibWithNibName:@"IllegalRoadCell" bundle:nil] forCellReuseIdentifier:@"IllegalRoadCellID"];
        cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalRoadCellID"];
    }
    
    CommonGetRoadModel *model = _arr_content[indexPath.row];
    cell.model = model;

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
    for (int i = 0; i < _arr_content.count; i++) {
        
        CommonGetRoadModel *model = _arr_content[i];
        
        if (i == indexPath.row) {
            model.isSelected = YES;
        }else{
            model.isSelected = NO;
        }
    }
    
    [self.tableView reloadData];
    
}


- (IBAction)handleBtnQuitClicked:(id)sender {
    
    for (int i = 0; i < _arr_content.count; i++) {
           
           CommonGetRoadModel *model = _arr_content[i];
           model.isSelected = NO;
       }
    
    AlertView * alertView = (AlertView *)self.superview;
    [alertView handleBtnDismissClick:nil];
    
}

- (IBAction)handleBtnCollectClicked:(id)sender {
    
    for (int i = 0; i < _arr_content.count; i++) {
        
        CommonGetRoadModel *model = _arr_content[i];
        
        if (model.isSelected) {
            if (self.block) {
                self.block(model);
            }
            break;
        }
        
    }

    for (int i = 0; i < _arr_content.count; i++) {
        
        CommonGetRoadModel *model = _arr_content[i];
        model.isSelected = NO;
    }
    
    AlertView * alertView = (AlertView *)self.superview;
    [alertView handleBtnDismissClick:nil];
    
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

- (void)dealloc{
    NSLog(@"IllegalRoadView dealloc");
}

@end

//
//  IllegalRecordVC.m
//  移动采集
//
//  Created by hcat on 2018/8/16.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalRecordVC.h"
#import "IllegalParkAPI.h"
#import "NetWorkHelper.h"
#import "IllegalRecordImageCell.h"
#import <UIImageView+WebCache.h>

@interface IllegalRecordVC ()

@property (weak, nonatomic) IBOutlet UILabel *timeLable;
@property (weak, nonatomic) IBOutlet UILabel *behaviorLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic,strong) NSArray *arr_img;
@property (nonatomic, strong) NSMutableDictionary *heightDict;

@end

@implementation IllegalRecordVC

- (void)viewDidLoad {
    [super viewDidLoad];
   
    self.title = @"违章详情";
    
    self.arr_img = [NSArray array];
    [_tableView registerNib:[UINib nibWithNibName:@"IllegalRecordImageCell" bundle:nil] forCellReuseIdentifier:@"IllegalRecordImageCellID"];
    
    WS(weakSelf);
    [[NetWorkHelper sharedDefault] setNetworkReconnectionBlock:^{
        SW(strongSelf, weakSelf);
        [strongSelf requestDataWith:strongSelf.illegalId];
        
    }];

}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self requestDataWith:_illegalId];
    
}


#pragma mark - requestMethods

- (void)requestDataWith:(NSNumber *)illegalId{
 
    WS(weakSelf);
    IllegalParkIllegalDetailManger *manger = [[IllegalParkIllegalDetailManger alloc] init];
    manger.illegalId = illegalId;
    [manger configLoadingTitle:@"请求"];
    [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
        
        SW(strongSelf, weakSelf);
        strongSelf.timeLable.text = [ShareFun timeWithTimeInterval:manger.illegalResponse.collectTime];
        strongSelf.addressLabel.text = [ShareFun takeStringNoNull:manger.illegalResponse.address];
        strongSelf.behaviorLabel.text = [ShareFun takeStringNoNull:manger.illegalResponse.illegalType];
        strongSelf.arr_img = manger.illegalResponse.pictureList;
        
        [strongSelf.tableView reloadData];
        
    } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
    
        
        
    }];
    
}

- (NSMutableDictionary *)heightDict {
    if (!_heightDict) {
        _heightDict = @{}.mutableCopy;
    }
    return _heightDict;
}

#pragma mark - UITableViewDelegate && UITableView

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _arr_img.count;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
   return [[self.heightDict objectForKey:@(indexPath.row)] floatValue];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    IllegalRecordImageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"IllegalRecordImageCellID"];
    if (_arr_img && _arr_img.count > 0) {
        IllegalImageModel *t_model = _arr_img[indexPath.row];
        [cell.imgvIllegal sd_setImageWithURL:[NSURL URLWithString:t_model.imgUrl] placeholderImage:nil options:SDWebImageRetryFailed completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            if (image.size.height) {
                /**  < 图片宽度 >  */
                CGFloat imageW = [UIScreen mainScreen].bounds.size.width - 2 * 10;
                /**  <根据比例 计算图片高度 >  */
                CGFloat ratio = image.size.height / image.size.width;
                /**  < 图片高度 + 间距 >  */
                CGFloat imageH = ratio * imageW + 10;
                /**  < 缓存图片高度 没有缓存则缓存 刷新indexPath >  */
                if (![[self.heightDict allKeys] containsObject:@(indexPath.row)]) {
                    [self.heightDict setObject:@(imageH) forKey:@(indexPath.row)];
                    [self.tableView beginUpdates];
                    [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
                    [self.tableView endUpdates];
                }
            }
        }];
        
    }
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - dealloc

- (void)dealloc{
    LxPrintf(@"IllegalRecordVC dealloc");
    
}

@end

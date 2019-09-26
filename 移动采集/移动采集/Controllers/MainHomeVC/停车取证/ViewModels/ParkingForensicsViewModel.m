//
//  ParkingForensicsViewModel.m
//  移动采集
//
//  Created by hcat on 2019/7/29.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "ParkingForensicsViewModel.h"


@interface ParkingForensicsViewModel ()

@property(nonatomic, strong) id first;
@property(nonatomic, strong) id secend;

@end

@implementation ParkingForensicsViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.param = [[ParkingForensicsParam alloc] init];
        
        self.arr_upImages =  [NSMutableArray array];
        [self.arr_upImages addObject:[NSNull null]];
        [self.arr_upImages addObject:[NSNull null]];
        self.first = self.arr_upImages[0];
        self.secend = self.arr_upImages[1];
        
        @weakify(self);
        [[RACSignal combineLatest:@[RACObserve(self.param, carNo), RACObserve(self, first), RACObserve(self, secend)] reduce:^id (NSString * carNo,id first,id secend){
            return @(carNo.length > 0 && ![first isKindOfClass:[NSNull class]] && ![secend isKindOfClass:[NSNull class]]);
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.isCanCommit = [x boolValue];
        }];
        
        
        self.command_commit = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ParkingForensicsManger * manger = [[ParkingForensicsManger alloc] init];
                manger.param = self.param;
                manger.param.fkParkplaceId = self.fkParkplaceId;
                if (self.param.absoluteUrl) {
                    manger.param.cutImageUrl = self.param.absoluteUrl;
                }
                LxDBObjectAsJson(manger.param);
                [manger configLoadingTitle:@"提交"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendNext:nil];
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"加载失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
        
        self.command_isFirst = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            
            @strongify(self);
            
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ParkingIsFirstParkManger * manger = [[ParkingIsFirstParkManger alloc] init];
                
                manger.carNo = input;

                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [subscriber sendNext:manger.isFristPark];
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"加载失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
    
    }
    
    return self;
    
}

#pragma mark - 管理上传图片

//替换图片到arr_upImages数组中
- (void)replaceUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark replaceIndex:(NSInteger)index{
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:remark forKey:@"remarks"];
    
    if (imageFileInfo) {
        imageFileInfo.name = key_files;
        [t_dic setObject:imageFileInfo             forKey:@"files"];
    }
    
    if (index == 1) {
        
        if (self.param.cutImageUrl) {
            [t_dic setObject:self.param.cutImageUrl forKey:@"cutImageUrl"];
        }
        
    }
   
    [t_dic setObject:@0 forKey:@"isMore"];
    [self.arr_upImages  replaceObjectAtIndex:index withObject:t_dic];
    
    self.first = self.arr_upImages[0];
    self.secend = self.arr_upImages[1];
    
}

//添加图片到arr_upImages数组中
- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark{
    
    imageFileInfo.name = key_files;
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageFileInfo forKey:@"files"];
    [t_dic setObject:remark forKey:@"remarks"];
    [t_dic setObject:@1 forKey:@"isMore"];
    [self.arr_upImages addObject:t_dic];
    
}

- (void)configParamInFilesAndRemarksAndTimes{
    
    if (self.arr_upImages && self.arr_upImages.count > 0) {
        
        LxDBObjectAsJson(self.arr_upImages);
        
        NSMutableArray *t_arr_files     = [NSMutableArray array];
        NSMutableArray *t_arr_remarks   = [NSMutableArray array];
        
        for (int i = 0; i < _arr_upImages.count; i++) {
            
            if([_arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]){
                
                NSMutableDictionary *t_dic  = _arr_upImages[i];
                ImageFileInfo *imageInfo    = [t_dic objectForKey:@"files"];
//                NSString * t_remark = [t_dic objectForKey:@"remarks"];
//                [t_arr_remarks addObject:t_remark];
                
                if (imageInfo) {
                    [t_arr_files     addObject:imageInfo];
                    [t_arr_remarks addObject:@"0"];
                }
                
                
                
            }
            
        }
        
        if (t_arr_files.count > 0) {
            _param.files = t_arr_files;
        }
        
        if (t_arr_remarks.count > 0) {
            _param.remarks = [t_arr_remarks componentsJoinedByString:@","];;
        }
        
    }
    
}



@end

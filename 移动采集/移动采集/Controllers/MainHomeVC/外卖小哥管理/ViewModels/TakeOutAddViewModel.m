//
//  TakeOutAddViewModel.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutAddViewModel.h"

@interface TakeOutAddViewModel ()

@property(nonatomic, strong) id first;
@property(nonatomic, strong) id secend;

@end


@implementation TakeOutAddViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.param = [[TakeOutSaveParam alloc] init];
        
        self.arr_upImages =  [NSMutableArray array];
        [self.arr_upImages addObject:[NSNull null]];
        [self.arr_upImages addObject:[NSNull null]];
        self.first = self.arr_upImages[0];
        self.secend = self.arr_upImages[1];
        
        @weakify(self);
        [[RACSignal combineLatest:@[RACObserve(self.param, illegalType), RACObserve(self, first), RACObserve(self, secend)] reduce:^id (NSString * illegalType,id first,id secend){
            return @(illegalType.length > 0 && ![first isKindOfClass:[NSNull class]] && ![secend isKindOfClass:[NSNull class]]);
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.isCanCommit = [x boolValue];
        }];
        
        
        self.command_commit = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                TakeOutSaveManger * manger = [[TakeOutSaveManger alloc] init];
                self.param.driver = self.deliveryId;
                self.param.reportType = @3014;
                manger.param = self.param;
                [manger configLoadingTitle:@"提交"];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:nil];
                    }
                    
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"加载失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
        
        
        self.command_commonRoad = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                @strongify(self);
                CommonGetRoadManger *manger = [[CommonGetRoadManger alloc] init];
                manger.isLog = NO;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [ShareValue sharedDefault].roadModels = manger.commonGetRoadResponse;
                        [subscriber sendNext:nil];
                    }
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
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
    
    imageFileInfo.name = key_files;
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageFileInfo forKey:@"files"];
    [t_dic setObject:remark forKey:@"remarks"];
    [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
    [t_dic setObject:@0 forKey:@"isMore"];
    [self.arr_upImages  replaceObjectAtIndex:index withObject:t_dic];
    
    if (index == 0) {
        self.first = t_dic;
    }else{
        self.secend = t_dic;
    }
    
}

//添加图片到arr_upImages数组中
- (void)addUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo{
    
    imageFileInfo.name = key_files;
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:imageFileInfo forKey:@"files"];
    [t_dic setObject:imageFileInfo.fileName forKey:@"remarks"];
    [t_dic setObject:[ShareFun getCurrentTime] forKey:@"taketimes"];
    [t_dic setObject:@1 forKey:@"isMore"];
    [self.arr_upImages addObject:t_dic];
    
}

- (void)configParamInFilesAndRemarksAndTimes{
    
    if (self.arr_upImages && self.arr_upImages.count > 0) {
        
        LxDBObjectAsJson(self.arr_upImages);
        
        NSMutableArray *t_arr_files     = [NSMutableArray array];
    
        for (int i = 0; i < _arr_upImages.count; i++) {
            
            if([_arr_upImages[i] isKindOfClass:[NSMutableDictionary class]]){
                
                NSMutableDictionary *t_dic  = _arr_upImages[i];
                ImageFileInfo *imageInfo    = [t_dic objectForKey:@"files"];
                
                if (imageInfo) {
                    [t_arr_files     addObject:imageInfo];
                }
                
            }
            
        }
        
        if (t_arr_files.count > 0) {
            _param.files = t_arr_files;
        }
        
    }
    
}



@end

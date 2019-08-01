//
//  TakeOutAddViewModel.m
//  移动采集
//
//  Created by hcat on 2019/5/10.
//  Copyright © 2019 Hcat. All rights reserved.
//

#import "TakeOutAddViewModel.h"

@interface TakeOutAddViewModel ()

@end


@implementation TakeOutAddViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.param = [[TakeOutSaveParam alloc] init];
        
        self.arr_upImages =  [NSMutableArray array];
      
        @weakify(self);
        [[RACSignal combineLatest:@[RACObserve(self.param, illegalType), RACObserve(self.param, companyNo)] reduce:^id (NSString * illegalType,NSString * companyNo){
            return @(illegalType.length > 0 && companyNo.length > 0);
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.isCanCommit = [x boolValue];
        }];
    
    }
    
    return self;
    
}


- (RACCommand *)command_commit{
    
    if (_command_commit == nil) {
        
        @weakify(self);
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
        
    }
    
    return _command_commit;
    
}


- (RACCommand *)command_illegalList{
    
    if (_command_illegalList == nil) {
        
        @weakify(self);
        self.command_illegalList = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                TakeOutTypeListManger * manger = [[TakeOutTypeListManger alloc] init];
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        self.deliveryIllegalList = manger.list;
                        [subscriber sendNext:@"加载成功"];
                        
                        
                    }else{
                        [subscriber sendNext:@"加载失败"];
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
        
    }
    
    return _command_illegalList;
    
}


#pragma mark - 管理上传图片

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

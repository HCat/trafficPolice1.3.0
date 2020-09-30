//
//  ThroughManageViewModel.m
//  移动采集
//
//  Created by 黄芦荣 on 2020/9/10.
//  Copyright © 2020 Hcat. All rights reserved.
//

#import "ThroughManageViewModel.h"
#import "CommonAPI.h"


@implementation ThroughManageViewModel

- (instancetype)init{
    
    if (self = [super init]) {
        
        self.param = [[ThroughManageSaveParam alloc] init];
        self.arr_upImages =  [NSMutableArray array];
        [self.arr_upImages addObject:[NSNull null]];
        [self.arr_upImages addObject:[NSNull null]];
        self.first = self.arr_upImages[0];
        self.secend = self.arr_upImages[1];
        
        @weakify(self);
        [[RACSignal combineLatest:@[RACObserve(self.param, roadId), RACObserve(self, first),RACObserve(self, secend),RACObserve(self.param, address),RACObserve(self.param, longitude),RACObserve(self.param, latitude),RACObserve(self.param, carNo),RACObserve(self.param, userName),RACObserve(self.param, identNo)] reduce:^id (NSNumber * roadId,id first,id secend,NSString * address,NSNumber * longitude,NSNumber * latitude,NSString * carNo,NSString * userName,NSString * identNo){
            return @(roadId && ![first isKindOfClass:[NSNull class]]&& ![secend isKindOfClass:[NSNull class]] && address.length > 0 && longitude && latitude && carNo.length > 0&& userName.length > 0&& identNo.length > 0);
        }] subscribeNext:^(id x) {
            @strongify(self);
            self.isCanCommit = [x boolValue];

        }];
        
        [[RACSignal combineLatest:@[[RACObserve(self.param, roadId) distinctUntilChanged], [RACObserve(self.param, carNo) distinctUntilChanged]] reduce:^id (NSNumber * roadId,NSString * carNo){
            return @(roadId && carNo && carNo.length > 6);
        }] subscribeNext:^(id x) {
            @strongify(self);
            if ([x boolValue]) {
                [self.command_carNoSecond execute:nil];
            }
        
        }];
        
        [[RACObserve(self.param, carNo) distinctUntilChanged] subscribeNext:^(NSString *  x) {
            @strongify(self);
            
            if (x && x.length > 6) {
                [self.command_carCount execute:nil];
            }
        }];
        
        [[RACObserve(self.param, identNo) distinctUntilChanged] subscribeNext:^(NSString *  x) {
            @strongify(self);
            
            if (x && x.length > 17) {
                [self.command_identNoCount execute:nil];
            }
        }];
        
    }
    
    return self;
    
}


- (RACCommand *)command_commit{
    
    @weakify(self);
    if (_command_commit == nil) {
        _command_commit = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ThroughManageSaveManger *manger = [[ThroughManageSaveManger alloc] init];
                self.param.type = @5010;
                manger.param = self.param;
                LxDBObjectAsJson(manger.param);
                [manger configLoadingTitle:@"提交"];
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_THROUGHMANAGE_SUCCESS object:nil];
                        [subscriber sendNext:@"提交成功"];
                    }else{
                        [subscriber sendNext:@"提交失败"];
                    }
                
                    [subscriber sendCompleted];
                    
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    [subscriber sendNext:@"提交失败"];
                    [subscriber sendCompleted];
                }];
                
                return nil;
            }];
            
            return t_signal;
        }];
    }
    
    return _command_commit;

}



- (RACCommand *)command_carNoSecond{
    
    if (_command_carNoSecond == nil) {
        
        @weakify(self);
        _command_carNoSecond = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                /*code:0 超过90秒有一次采集记录，返回一次采集ID、采集时间，提示“同路段该车于yyyy-MM-dd已被拍照采集”，跳转至二次采集页面
                 code:110 提示“同路段当天已有违章行为，请不要重复采集！”
                 code:13 提示“同路段该车1分30秒内有采集记录，是否重新采集？”
                 code:999 无采集记录,不用任何提示
                 code:1 提示24小时到48小时内违章的提醒，如果无违章则为套牌提醒
                 */
                
                ThroughManageCarNoSecManger * manger = [[ThroughManageCarNoSecManger alloc] init];
                manger.carNo = self.param.carNo;
                manger.roadId = self.param.roadId;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    RACTuple * tuple = RACTuplePack(@(manger.responseModel.code),manger.illegalReponse,manger.responseModel.msg);
                    
                    [subscriber sendNext:tuple];
                    
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
    
    return _command_carNoSecond;
    
}


- (RACCommand *)command_identifyCarNo{
    
    if (_command_identifyCarNo == nil) {
        
        @weakify(self);
        _command_identifyCarNo = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ImageFileInfo * imageInfo = (ImageFileInfo * )input;
                imageInfo.name = key_file;
                CommonIdentifyManger *manger = [[CommonIdentifyManger alloc] init];
                [manger configLoadingTitle:@"识别"];
                manger.isNeedShowHud = NO;
                
                manger.imageInfo = imageInfo;
                manger.type = 1;
                
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    @strongify(self);
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        
                        if (manger.commonIdentifyResponse) {
                            
                            if (manger.commonIdentifyResponse.carNo && manger.commonIdentifyResponse.carNo.length > 0) {
                                if (manger.commonIdentifyResponse.carNo && manger.commonIdentifyResponse.carNo.length > 0) {
                                    self.param.carNo = manger.commonIdentifyResponse.carNo;
                                    self.param.carColor = manger.commonIdentifyResponse.color;
                                    self.param.cutImageUrl = manger.commonIdentifyResponse.cutImageUrl;
                                    [subscriber sendNext:manger.commonIdentifyResponse.carNo];
                                    
                                }
                               
                            }
                            
                            if (manger.commonIdentifyResponse.cutImageUrl.length == 0 || !manger.commonIdentifyResponse.cutImageUrl) {
                                [LRShowHUD showCarError:@"车牌辅助识别不成功" duration:1.5];
                                [subscriber sendNext:@"识别失败"];
                            }
                            
                        }
                    }else{
                        [LRShowHUD showCarError:@"车牌辅助识别不成功" duration:1.5];
                        [subscriber sendNext:@"识别失败"];
                    }
                    [subscriber sendCompleted];
                } failure:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    [LRShowHUD showCarError:@"车牌辅助识别不成功" duration:1.5];
                    [subscriber sendNext:@"识别失败"];
                    [subscriber sendCompleted];
                }];
                

                return nil;
            }];
            
            return t_signal;
        }];
        
    }
    
    return _command_identifyCarNo;
    
}


- (RACCommand *)command_carCount{
    
    if (_command_carCount == nil) {
        
        @weakify(self);
        _command_carCount = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
                
                ThroughManageCountCollectManger * manger = [[ThroughManageCountCollectManger alloc] init];
                manger.carNo = self.param.carNo;
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:manger.carNoNumber];
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
    
    return _command_carCount;
    
}


- (RACCommand *)command_identNoCount{
    
    if (_command_identNoCount == nil) {
        
        @weakify(self);
        _command_identNoCount = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
            @strongify(self);
            RACSignal * t_signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            
                ThroughManageCountIdentNoManger * manger = [[ThroughManageCountIdentNoManger alloc] init];
                manger.identNo = self.param.identNo;
                manger.isNoShowFail = YES;
                [manger startWithCompletionBlockWithSuccess:^(__kindof YTKBaseRequest * _Nonnull request) {
                    
                    if (manger.responseModel.code == CODE_SUCCESS) {
                        [subscriber sendNext:manger.identNoNumber];
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
    
    return _command_identNoCount;
    
}

#pragma mark - 管理上传图片

//替换图片到arr_upImages数组中
- (void)replaceUpImageItemToUpImagesWithImageInfo:(ImageFileInfo *)imageFileInfo remark:(NSString *)remark replaceIndex:(NSInteger)index{
    
    NSMutableDictionary *t_dic = [NSMutableDictionary dictionary];
    [t_dic setObject:remark forKey:@"remarks"];
    
    if (imageFileInfo) {
        imageFileInfo.name = key_files;
        [t_dic setObject:imageFileInfo             forKey:@"files"];
    }else{
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
                NSString * t_str = [t_dic objectForKey:@"remarks"];
                
                if (imageInfo) {
                    imageInfo.name = @"files";
                    [t_arr_files    addObject:imageInfo];
                    [t_arr_remarks  addObject:t_str];
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


#pragma mark  - 存储停止定位位置

- (void)handleBeforeCommit{
    
    //更新手动存储位置数据
    LocationStorageModel * model = [[LocationStorageModel alloc] init];
    model.streetName    = _param.roadName;
    model.address       = _param.address;
    [[LocationStorage sharedDefault] setThroughManage:model];

    if ([self.param.roadId isEqualToNumber:@0]) {
        [ShareValue sharedDefault].roadModels = nil;
        [[ShareValue sharedDefault] roadModels];
    }
    
    
    self.param = [[ThroughManageSaveParam alloc] init];
    [_arr_upImages removeAllObjects];
    [_arr_upImages addObject:[NSNull null]];
    [_arr_upImages addObject:[NSNull null]];
    self.first = self.arr_upImages[0];
    self.secend = self.arr_upImages[1];
    
    @weakify(self);
    [[RACSignal combineLatest:@[RACObserve(self.param, roadId), RACObserve(self, first),RACObserve(self, secend),RACObserve(self.param, address),RACObserve(self.param, longitude),RACObserve(self.param, latitude),RACObserve(self.param, carNo),RACObserve(self.param, userName),RACObserve(self.param, identNo)] reduce:^id (NSNumber * roadId,id first,id secend,NSString * address,NSNumber * longitude,NSNumber * latitude,NSString * carNo,NSString * userName,NSString * identNo){
        return @(roadId && ![first isKindOfClass:[NSNull class]]&& ![secend isKindOfClass:[NSNull class]] && address.length > 0 && longitude && latitude && carNo.length > 0&& userName.length > 0&& identNo.length > 0);
    }] subscribeNext:^(id x) {
        @strongify(self);
        self.isCanCommit = [x boolValue];

    }];
    
    [[RACSignal combineLatest:@[[RACObserve(self.param, roadId) distinctUntilChanged], [RACObserve(self.param, carNo) distinctUntilChanged]] reduce:^id (NSNumber * roadId,NSString * carNo){
        return @(roadId && carNo && carNo.length > 6);
    }] subscribeNext:^(id x) {
        @strongify(self);
        if ([x boolValue]) {
            [self.command_carNoSecond execute:nil];
        }
    
    }];
    
    [[RACObserve(self.param, carNo) distinctUntilChanged] subscribeNext:^(NSString *  x) {
        @strongify(self);
        
        if (x && x.length > 6) {
            [self.command_carCount execute:nil];
        }
    }];
    
    [[RACObserve(self.param, identNo) distinctUntilChanged] subscribeNext:^(NSString *  x) {
        @strongify(self);
        
        if (x && x.length > 17) {
            [self.command_identNoCount execute:nil];
        }
    }];
    
}


#pragma mark - 通过所在路段的名字获取得到roadId

#pragma mark - set && get

- (NSArray *)codes{
    
    _codes = [ShareValue sharedDefault].roadModels;
    
    return _codes;
    
}

- (void)getRoadId{

    if (self.codes && self.codes.count > 0) {
        for(CommonGetRoadModel *model in self.codes){
            if ([model.getRoadName isEqualToString:self.param.roadName]) {
                _param.roadId = model.getRoadId;
                break;
            }
        }
    }
    
    if (!_param.roadId) {
         _param.roadId = @0;
    }
    
}





@end

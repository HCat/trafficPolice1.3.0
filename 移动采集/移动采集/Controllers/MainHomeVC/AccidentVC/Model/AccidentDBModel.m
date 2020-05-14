//
//  AccidentDBModel.m
//  移动采集
//
//  Created by hcat on 2018/10/19.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "AccidentDBModel.h"
#import "ImageFileInfo.h"

@implementation AccidentDBModel

//重载、初始化单例、使用的LKDBHelper
+ (LKDBHelper *)getUsingLKDBHelper {
    
    static LKDBHelper* db;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSArray *documentArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
        NSString *document = [documentArray objectAtIndex:0];
        
        NSString* DBPath = [document stringByAppendingPathComponent:@"DB/trafficPolice.db"];
        NSLog(@"%@", DBPath);
        db = [[LKDBHelper alloc] initWithDBPath:DBPath];
    });
    return db;
}


- (instancetype)initWithAccidentUpParam:(AccidentUpParam *) param{
    
    if (self = [super init]) {
        
        self.ownId = [ShareValue sharedDefault].phone;
        self.commitTime = [ShareFun getCurrentTimeInterval];
        self.commitTimeString = [ShareFun timeWithTimeInterval:self.commitTime dateFormat:@"yyyy-MM-dd"];
        self.accidentId = param.accidentId;
        self.happenTimeStr = param.happenTimeStr;
        self.roadId = param.roadId;
        self.roadName = param.roadName;
        self.address = param.address;
        self.causesType = param.causesType;
        self.weather = param.weather;
        self.injuredNum = param.injuredNum;
        self.roadType = param.roadType;
        self.accidentInfoStr = param.accidentInfoStr;
        self.files = param.files;
        self.certFiles = param.certFiles;
        self.certRemarks = param.certRemarks;
      
    }
    
    return self;
    
}


- (AccidentUpParam *)mapAccidentUpParam{
    
    AccidentUpParam * param = [[AccidentUpParam alloc] init];
    
    param.accidentId = self.accidentId;
    param.happenTimeStr = self.happenTimeStr;
    param.roadId = self.roadId;
    param.roadName = self.roadName;
    param.address = self.address;
    param.causesType = self.causesType;
    param.weather = self.weather;
    param.injuredNum = self.injuredNum;
    param.roadType = self.roadType;
    param.accidentInfoStr = self.accidentInfoStr;
    param.files = self.files;
    param.certFiles = self.certFiles;
    param.certRemarks = self.certRemarks;
    
    NSDate* date = [NSDate dateWithTimeIntervalSince1970:[self.commitTime doubleValue]/1000];
    NSDate* date2 = [NSDate dateWithTimeIntervalSinceNow:0];
    
    NSTimeInterval seconds = [date2 timeIntervalSinceDate:date];
    param.offtime = @([@(seconds) integerValue]);
    

    return param;
    
}

- (AccidentDetailsModel *)mapAccidentDetailModel{
    
    AccidentDetailsModel *detailModel = [[AccidentDetailsModel alloc] init];
    
    AccidentInfoModel * infoModel = [[AccidentInfoModel alloc] init];
    
    infoModel.happenTime = [ShareFun timeSwitchTimestamp:self.happenTimeStr];
    infoModel.roadId = self.roadId;
    infoModel.address = self.address;
    infoModel.causesType = self.causesType;
    infoModel.weather = self.weather;
    infoModel.injuredNum = self.injuredNum;
    infoModel.roadType = self.roadType;
    
    NSMutableArray * t_arr_files = @[].mutableCopy;
    
    for (int i = 0 ; i < [self.files count]; i++) {
        
        ImageFileInfo * imageInfo = self.self.files[i];
        
        AccidentPicListModel * model = [[AccidentPicListModel alloc] init];
        model.picImage = imageInfo.image;
        [t_arr_files addObject:model];
        
    };
    
    detailModel.accident = infoModel;
    detailModel.picList = t_arr_files;
    detailModel.accidentList = [NSArray modelArrayWithClass:[AccidentPeopleModel class] json:self.accidentInfoStr];
    
    return detailModel;
  
}


+(Class)__filesClass{
    return [ImageFileInfo class];
}

+(Class)__certFilesClass{
    return [ImageFileInfo class];
}


#pragma mark - public

- (void)save{
    
    NSInteger rowcount = [AccidentDBModel rowCountWithWhereFormat:@"rowid =%ld",self.rowid];
    if (rowcount>0) {
        [AccidentDBModel updateToDB:self where:[NSString stringWithFormat:@"rowid =%ld",self.rowid]];
    }else{
        [self saveToDB];
    }
    
}

- (void)deleteDB{
    
    for (ImageFileInfo * image in _files) {
        [image deleteDB];
    }
    
    for (ImageFileInfo * image in _certFiles) {
        [image deleteDB];
    }

    [AccidentDBModel deleteWithWhere:[NSString stringWithFormat:@"rowid =%ld",self.rowid]];
    
}


+(NSArray *)localArrayFormType:(NSNumber *)type{
    NSString *sql = @"";
    
    sql = [sql stringByAppendingFormat:@"ownId =%@ and type =%@",[ShareValue sharedDefault].phone,type];
    
    return [AccidentDBModel searchWithWhere:sql orderBy:@"commitTime asc" offset:0 count:0];
}

//表名
+ (NSString *)getTableName {
    return NSStringFromClass(self);
}

//是否将父实体类的属性也映射到sqlite库表
+ (BOOL)isContainParent {
    return NO;
}


#pragma mark - LKDBDelegate

+ (void)dbDidAlterTable:(LKDBHelper *)helper tableName:(NSString *)tableName addColumns:(NSArray *)columns {
    
    LxPrintf(@"表名:%@",tableName);
    LxDBObjectAsJson(columns);
}


+ (BOOL)dbWillInsert:(NSObject *)entity {
    LxPrintf(@"将要插入 : %@",NSStringFromClass(self));
    return YES;
}

+ (void)dbDidInserted:(NSObject *)entity result:(BOOL)result {
    LxPrintf(@"已经插入 : %@",NSStringFromClass(self));
}

+ (BOOL)dbWillUpdate:(NSObject*)entity {
    LxPrintf(@"将要更新 : %@",NSStringFromClass(self));
    return YES;
}

+ (void)dbDidUpdated:(NSObject*)entity result:(BOOL)result {
    LxPrintf(@"已经更新 : %@",NSStringFromClass(self));
}

+ (BOOL)dbWillDelete:(NSObject*)entity {
    LxPrintf(@"将要删除 : %@",NSStringFromClass(self));
    
    return YES;
}

+ (void)dbDidDeleted:(NSObject*)entity result:(BOOL)result {
    LxPrintf(@"已经删除 : %@",NSStringFromClass(self));
}


@end

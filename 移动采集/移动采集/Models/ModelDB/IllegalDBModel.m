//
//  IllegalDBModel.m
//  移动采集
//
//  Created by hcat on 2018/9/28.
//  Copyright © 2018年 Hcat. All rights reserved.
//

#import "IllegalDBModel.h"
#import <LKDBHelper.h>
#import "ImageFileInfo.h"

@implementation IllegalDBModel

- (instancetype)initWithIllegalParkParam:(IllegalParkSaveParam *) param{
    
    if (self = [super init]) {
        
        self.illegalId = [ShareFun getCurrentTimeInterval];
        self.ownId = [ShareValue sharedDefault].phone;
        self.commitTime = [ShareFun getCurrentTimeInterval];
        
        self.roadId =  param.roadId;
        self.roadName = param.roadName;
        self.address =  param.address;
        self.addressRemark = param.addressRemark;
        self.carNo =  param.carNo;
        self.carColor = param.carColor;
        self.longitude = param.longitude;
        self.latitude = param.latitude;
        
        self.files = param.files;
        self.remarks = param.remarks;
        self.taketimes = param.taketimes;
        
    
        self.cutImageUrl = param.cutImageUrl;
        self.taketime = param.taketime;
        self.isManualPos = param.isManualPos;
        self.type = param.type;
        
        
        
    }
    
    return self;
    
}


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

//在类 初始化的时候
+ (void)initialize {
    
    //如果getTableMapping 返回 nil, 会取全部属性， 如果有不想要的属性，可以使用
    //    [self removePropertyWithColumnName:@"age"];
    //    [self removePropertyWithColumnNameArray:@[@"age", @"name"]];
    
    //修改列名
    //    [self setTableColumnName:@"MyAge" bindingPropertyName:@"age"];
    
    //手动设置关联外键变量名
    //    [self setUserCalculateForCN:@""];
}


+(Class)__filesClass{
    return [ImageFileInfo class];
}



#pragma mark - public


- (void)save{
    
    NSInteger rowcount = [IllegalDBModel rowCountWithWhereFormat:@"illegalId=%@",_illegalId];
    if (rowcount>0) {
        [IllegalDBModel updateToDB:self where:[NSString stringWithFormat:@"illegalId=%@",_illegalId]];
    }else{
        [self saveToDB];
    }

}

- (void)deleteDB{
    
    [IllegalDBModel deleteWithWhere:[NSString stringWithFormat:@"ownId =%@ and illegalId =%@",[ShareValue sharedDefault].phone,_illegalId]];
    
}


+(NSArray *)localArrayFormType:(NSNumber *)type{
    NSString *sql = @"";
    
    sql = [sql stringByAppendingFormat:@"ownId =%@ and type =%@",[ShareValue sharedDefault].phone,type];
    
    return [IllegalDBModel searchWithWhere:sql orderBy:@"commitTime desc" offset:0 count:0];
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




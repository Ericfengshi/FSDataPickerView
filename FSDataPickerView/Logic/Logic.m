//
//  Logic.m
//  FSDataPickerView
//
//  Created by fengs on 14-12-28.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "Logic.h"

@implementation Logic
@synthesize dbPath = _dbPath;
static Logic *sharedInstance = nil;

- (id)init {
    self = [super init];
    if (self) {
        self.dbPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:@"db.sqlite"]; 
    }
    return self;
}

+ (Logic *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super alloc] init];
    }
    return sharedInstance;
}

+ (void)finish {
    if (sharedInstance) {
        [sharedInstance release];
        sharedInstance = nil;
    }
}

#pragma mark -
#pragma mark - 行政区域
/**
 * 获取省份列表
 * @return NSMutableArray
 */
-(NSMutableArray*)getProvinceList{
    NSString *sql = @"select distinct PROVINCE_NAME as province from REGIONAL where ACTIVE='1'";
    
    NSString *orderSql = @" order by (select case PROVINCE_NAME when '北京市' then 1 when '天津市' then 2 when '河北省' then 3 when '山西省' then 4 when '内蒙古自治区' then 5 when '辽宁省' then 6 when '吉林省' then 7 when '黑龙江省' then 8 when '上海市' then 9 when '江苏省' then 10 when '浙江省' then 11 when '安徽省' then 12 when '福建省' then 13 when '江西省' then 14 when '山东省' then 15 when '河南省' then 16 when '湖北省' then 17 when '湖南省' then 18 when '广东省' then 19 when '广西壮族自治区' then 20 when '海南省' then 21 when '重庆市' then 22 when '四川省' then 23 when '贵州省' then 24 when '云南省' then 25 when '西藏自治区' then 26 when '陕西省' then 27 when '甘肃省' then 28 when '青海省' then 29 when '宁夏回族自治区' then 30 when '新疆维吾尔自治区' then 31 when '香港特别行政区' then 32 when '澳门特别行政区' then 33 when '台湾省' then 34 else '' end)";
    
    sql = [NSString stringWithFormat:@"%@%@",sql,orderSql];
    
    NSMutableArray *retVal = [NSMutableArray array];
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *province = [rs stringForColumn:@"province"];
            [retVal addObject:province];
        }
        [rs close];
    } else {
        NSLog(@"%s>数据库打开失败", __func__);
    }
    [db close];
    return retVal;
}

/**
 * 通过省份获取城市列表
 * @param province
 * @return NSMutableArray
 */
-(NSMutableArray*)getCityListByProvince:(NSString*)province{
    NSString *sql = @"select distinct CITY_NAME as city from REGIONAL where ACTIVE='1' and PROVINCE_NAME ='%@'";
    sql = [NSString stringWithFormat:sql,province];
    
    NSMutableArray *retVal = [NSMutableArray array];
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *city = [rs stringForColumn:@"city"];
            [retVal addObject:city];
        }
        [rs close];
    } else {
        NSLog(@"%s>数据库打开失败", __func__);
    }
    [db close];
    return retVal;
}

/**
 * 通过城市获取县城镇列表
 * @param city
 * @return NSMutableArray
 */
-(NSMutableArray*)getTownListByCity:(NSString*)city{
    NSString *sql = @"select distinct REGIONAL_NAME as town from REGIONAL where ACTIVE='1' and CITY_NAME ='%@' ";
    sql = [NSString stringWithFormat:sql,city];
    
    NSMutableArray *retVal = [NSMutableArray array];
    FMDatabase *db = [FMDatabase databaseWithPath:self.dbPath];
    if ([db open]) {
        FMResultSet *rs = [db executeQuery:sql];
        while ([rs next]) {
            NSString *town = [rs stringForColumn:@"town"];
            [retVal addObject:town];
        }
        [rs close];
    } else {
        NSLog(@"%s>数据库打开失败", __func__);
    }
    [db close];
    return retVal;
}


@end

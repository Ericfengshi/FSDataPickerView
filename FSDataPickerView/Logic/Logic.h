//
//  Logic.h
//  FSDataPickerView
//
//  Created by fengs on 14-12-28.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"

@interface Logic : NSObject{
    NSString *_dbPath;
}
@property (nonatomic,retain) NSString *dbPath;
-(id)init;
+ (Logic *)sharedInstance;
+ (void)finish;

#pragma mark -
#pragma mark - 行政区域
/**
 * 获取省份列表
 * @return NSMutableArray
 */
-(NSMutableArray*)getProvinceList;

/**
 * 通过省份获取城市列表
 * @param province
 * @return NSMutableArray
 */
-(NSMutableArray*)getCityListByProvince:(NSString*)province;

/**
 * 通过城市获取县城镇列表
 * @param city
 * @return NSMutableArray
 */
-(NSMutableArray*)getTownListByCity:(NSString*)city;
@end

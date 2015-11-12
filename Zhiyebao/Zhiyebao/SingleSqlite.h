//
//  SingleSqlite.h
//  Zhiyebao
//
//  Created by Apple on 14-6-10.
//
//




//保存历史搜索记录的数据库
#import <Foundation/Foundation.h>

@interface SingleSqlite : NSObject

+ (SingleSqlite*)shareSingleSqlite;

-(id)initWithSqliteSingle;

- (NSString*)sqlitePath;

- (BOOL)createSqlite;

- (void)insertHouse:(NSString*)houseId  houseIdentify:(NSString*)houseIdentify houseTitle:(NSString*)areaName;

- (void)deleteHouse:(NSString*)houseId;

- (NSArray*)getAllHouse;




@end


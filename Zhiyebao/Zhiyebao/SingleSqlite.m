//
//  SingleSqlite.m
//  Zhiyebao
//
//  Created by Apple on 14-6-10.
//
//
//
//  SingleSqlite.m
//  Zhiyebao
//
//  Created by Apple on 14-6-10.
//
//

#import "SingleSqlite.h"
#import "sqlite3.h"
#import "House.h"

@implementation SingleSqlite

static SingleSqlite* sqliteSingle= nil;


+ (SingleSqlite*)shareSingleSqlite
{
    if (sqliteSingle!=nil) {
        
        return sqliteSingle;
        
    } else {
        
        sqliteSingle = [[SingleSqlite alloc]initWithSqliteSingle];
    }
    return sqliteSingle;
    
}

-(id)initWithSqliteSingle
{
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
    
}

- (BOOL)createSqlite
{
    
    sqlite3* db;
    NSString* filePath = [self sqlitePath];
    if (sqlite3_open([filePath UTF8String], &db)!= SQLITE_OK ) {
        
        sqlite3_close(db);
        NSLog(@"打开表失败");
        
    } else {
        
        char* sqlite = "create table if not exists users(_id integer primary key ,houseId text, houseidentify text, houseTitle text)";
        sqlite3_exec(db, sqlite, nil, nil, nil);
        //  free(sqlite);
        sqlite3_close(db);
        return YES;
        
    }
    
    return NO;
    
}

- (NSString*)sqlitePath
{
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *path = [paths objectAtIndex:0];
    
    NSString* filePath = [path stringByAppendingPathComponent:@"Caches"];
    
    NSString* housePath = [filePath stringByAppendingPathComponent:@"house.sqlite"];
    
    return housePath;
    
}

- (void)insertHouse:(NSString*)houseId  houseIdentify:(NSString*)houseIdentify houseTitle:(NSString*)areaName
{
    //  INSERT INTO table_name (列1, 列2,...) VALUES (值1, 值2,....)
    NSString* filePath = [self sqlitePath];
    sqlite3* db;
    char* sqlitesql = malloc(1024);
    sqlite3_open([filePath UTF8String], &db);
    sprintf(sqlitesql, "INSERT INTO USERS (houseId,houseidentify,houseTitle) values('%s','%s','%s')",[houseId UTF8String],[houseIdentify UTF8String],[areaName UTF8String]);
    //   sqlite3_exec(db, sqlitesql, nil, nil, nil);
    if (sqlite3_exec(db, sqlitesql, nil, nil, nil)== SQLITE_OK) {
        
        NSLog(@"插入成功");
        
    }
    //free(sqlitesql);
    sqlite3_close(db);
}

- (void)deleteHouse:(NSString*)houseId
{
    // DELETE FROM 表名称 WHERE 列名称 = 值
    NSString* filePath = [self sqlitePath];
    sqlite3* db;
    sqlite3_open([filePath UTF8String], &db);
    char* strsql = malloc(1024);
    sprintf(strsql, "delete from users where houseId = '%s'",[houseId UTF8String]);
    if (sqlite3_exec(db, strsql, nil, nil, nil)== SQLITE_OK) {
        
        NSLog(@"删除成功");
        
    }
    // free(strsql);
    sqlite3_close(db);
}

- (NSArray*)getAllHouse
{
    NSString* filePath = [self sqlitePath];
    sqlite3* db;
    char* strsql;
    sqlite3_open([filePath UTF8String], &db);
    
    NSMutableArray* array=[NSMutableArray arrayWithCapacity:1];
    sqlite3_stmt* rc;
    strsql="select * from users";
    sqlite3_prepare_v2(db, strsql, -1, &rc, nil);
    while (sqlite3_step(rc)==SQLITE_ROW)
        
    {
        
        House* house=[[House alloc]init];
        house.houseID=[NSString stringWithFormat:@"%s",sqlite3_column_text(rc, 1)];
        
        char* const houseIdString = (char*)sqlite3_column_text(rc, 1);
        char* const houseIdentifierString = (char*)sqlite3_column_text(rc, 2);
        char* const titleString = (char*)sqlite3_column_text(rc, 3);
        
        house.houseID = [NSString stringWithCString:houseIdString encoding:NSUTF8StringEncoding];
        house.houseIdentifier=[NSString stringWithCString:houseIdentifierString encoding:NSUTF8StringEncoding];
        house.title=[NSString stringWithCString:titleString encoding:NSUTF8StringEncoding];
        [array addObject:house];
        
    }
    
    sqlite3_finalize(rc);
    //  free(strsql);
    sqlite3_close(db);
    return  array;
    
}

@end

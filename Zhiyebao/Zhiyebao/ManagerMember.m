//
//  ManagerMember.m
//  Zhiyebao
//
//  Created by Apple on 14-5-16.
//
//

#import "ManagerMember.h"
#import "WebAPI.h"
#import "Result.h"
#import "Member.h"
#import "House.h"

@implementation ManagerMember

//用户注册
+ (Result*)memberRegin:(NSString*)reginName reginPassword:(NSString*)password
{
    NSLog(@"memberRegin");
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:reginName forKey:@"loginName"];
    [params setObject:password forKey:@"loginPassword"];
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"register.html" params:params];
    
    
    Result* result = [webAPI post:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        
        
        return  nil;
        
        
    }];
    
    return result;
}

//用户登陆
+ (Result*)memberLogin:(NSString*)loginName loginPassword:(NSString*)password{
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:loginName forKey:@"loginName"];
    [params setObject:password forKey:@"loginPassword"];
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"login.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
      
        
        NSLog(@"responet = %@",responseObject);
        
        
        if ([responseObject objectForKey:@"status"])
        {
            
            Member* member = [[Member alloc]init];
            
            NSDictionary* currentDic = [responseObject objectForKey:@"status"];
            
            if ([currentDic objectForKey:@"loginUserInf"])
            {
                
                
                NSDictionary* dic = [currentDic objectForKey:@"loginUserInf"];
                
                
                if ([dic objectForKey:@"id"])
                {
                    
                    
                    member.memberID = [dic objectForKey:@"id"] ;
                    
                    
                }
                
                
            }
            
            return member;
            
            
        }
        
        
        return nil;
        
        
    }];
    
    return result;
    
    
}

//获取浏览记录
+ (Result*)getMyScanList:(NSString*)userId offset:(int)offset length:(int)length
{
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:[[NSNumber numberWithInt:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInt:length] stringValue] forKey:@"length"];
     NSLog(@"params %@", params);
    
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"myHistoryList.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        
        if ([responseObject objectForKey:@"list"]) {
            
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *houseArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                House *house = [[House alloc] init];
                
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"photo"] != [NSNull null]) {
                    house.houseID = [infoDict objectForKey:@"id"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    if ([infoDict objectForKey:@"photo"] && [infoDict objectForKey:@"photo"] != [NSNull null]) {
                        house.thumbImageURLString = [infoDict objectForKey:@"photo"];
                    }
                } else {
                    if ([infoDict objectForKey:@"photo"] && [infoDict objectForKey:@"photo"] != [NSNull null]) {
                        house.thumbImageURLString = [infoDict objectForKey:@"photo"];
                    }
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    house.title = [infoDict objectForKey:@"title"];
                }
                if ([infoDict objectForKey:@"apartment"] && [infoDict objectForKey:@"apartment"] != [NSNull null]) {
                    house.houseTypeTitle = [infoDict objectForKey:@"apartment"];
                }
                if ([infoDict objectForKey:@"price"] && [infoDict objectForKey:@"price"] != [NSNull null]) {
                    house.price = [infoDict objectForKey:@"price"];
                }
                if ([infoDict objectForKey:@"type"]) {
                    
                    house.houseType = [infoDict objectForKey:@"type"];
                    
                }
                if ([infoDict objectForKey:@"houseId"]) {
                    
                    house.houseID = [infoDict objectForKey:@"houseId"];
                    
                }
                
                [houseArray addObject:house];
            }
            return houseArray;
        }
        
        return  nil;
    }];
    
    
    return  result;
    
    
}

//添加浏览记录
+ (Result*)addScanHistoryList:(int)userId infomationId:(int)ID
{
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    [params setObject:[[NSNumber numberWithInt:userId] stringValue] forKey:@"userId"];
    [params setObject:[[ NSNumber numberWithInt:ID] stringValue] forKey:@"id"];
    
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"addHistory.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        return  nil;
    }];
    
    
    return  result;
    
}

//删除浏览记录
+ (Result*)deleteScanHistoryList:(NSString*)userId houseID:(int)houseId
{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:[[ NSNumber numberWithInt:houseId] stringValue] forKey:@"id"];
    
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"deleteHistory.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        return  nil;
    }];
    
    
    return  result;
    
}


//获取收藏信息列表
+ (Result*)getCollectHouseList:(int)userId offset:(int)offset length:(int)length
{
    NSLog(@"getCollectHouseList");
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:[[NSNumber numberWithInt:userId] stringValue] forKey:@"userId"];
    
    [params setObject:[[NSNumber numberWithInt:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInt:length] stringValue] forKey:@"length"];
    NSLog(@"params %@", params);
    
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"myCollectList.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        
        if ([responseObject objectForKey:@"list"]) {
            
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *houseArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                House *house = [[House alloc] init];
                
                if ([infoDict objectForKey:@"houseId"]) {
                    house.houseID = [infoDict objectForKey:@"houseId"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    if ([infoDict objectForKey:@"photo"] && [infoDict objectForKey:@"photo"] != [NSNull null]) {
                        house.thumbImageURLString = [infoDict objectForKey:@"photo"];
                    }
                } else {
                    if ([infoDict objectForKey:@"photo"] && [infoDict objectForKey:@"photo"] != [NSNull null]) {
                        house.thumbImageURLString = [infoDict objectForKey:@"photo"];
                    }
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    house.title = [infoDict objectForKey:@"title"];
                }
                if ([infoDict objectForKey:@"apartment"] && [infoDict objectForKey:@"apartment"] != [NSNull null]) {
                    house.houseTypeTitle = [infoDict objectForKey:@"apartment"];
                    
                    NSLog(@"house.houseTypeTitle = %@",house.houseTypeTitle);
                    
                }
                if ([infoDict objectForKey:@"price"] && [infoDict objectForKey:@"price"] != [NSNull null]) {
                    house.price = [infoDict objectForKey:@"price"];
                }
                if ([infoDict objectForKey:@"type"]) {
                    
                    house.houseType = [infoDict objectForKey:@"type"];
                    
                }
                
                
                [houseArray addObject:house];
            }
            return houseArray;
        }
        
        return  nil;
    }];
    
    
    return  result;
    
    
}

//收藏房子
+ (Result*)collectHouse:(int)userId houseId:(int)ID
{
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    [params setObject:[[NSNumber numberWithInt:userId] stringValue] forKey:@"userId"];
    [params setObject:[[ NSNumber numberWithInt:ID] stringValue] forKey:@"id"];
    
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"collect.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        
        
        return  nil;
    }];
    
    
    return  result;
    
    
    
    
}

//取消收藏房子
+ (Result*)cancelCollectHouse:(NSString*)userId houseId:(int)houseId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:userId forKey:@"userId"];
    [params setObject:[[NSNumber numberWithInt:houseId] stringValue] forKey:@"houseId"];
    NSLog(@"params %@", params);
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"unCollect.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        
        
        return  nil;
    }];
    
    
    return  result;
    
    
}

//获取会员收藏房子是否存在
+ (Result*)getIsCollectHouseExsited:(NSString*)loginName loginPassword:(NSString*)loginPassword
                            houseId:(int)houseId
{
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:loginName forKey:@"loginName"];
    [params setObject:loginPassword forKey:@"loginPassword"];
    [params setObject:[[NSNumber numberWithInt:houseId] stringValue] forKey:@"houseId"];
    NSLog(@"params %@", params);
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getIsCollectHouseExsited.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        NSLog(@"responseObject =  %@",responseObject);
        House* house = [[House alloc]init];

        if ([responseObject objectForKey:@"IsCollectHouseExsited"]) {
            
            
            
            house.isCollectHouseExsited = [[responseObject objectForKey:@"IsCollectHouseExsited"] intValue];
            
            
        }
        
           return  house;
    }];
    
    
         return  result;
    
}


//获取联系记录
+ (Result*)getMyContactList:(NSString*)userId offset:(int)offset length:(int)length{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:[[NSNumber numberWithInt:offset] stringValue] forKey:@"offset"];
    [params setObject:[[ NSNumber numberWithInt:length] stringValue] forKey:@"length"];
    
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"myContactList.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        
        if ([responseObject objectForKey:@"list"]) {
            
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *houseArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                House *house = [[House alloc] init];
                
                if ([infoDict objectForKey:@"id"]) {
                    house.houseID = [infoDict objectForKey:@"id"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    if ([infoDict objectForKey:@"photo"] && [infoDict objectForKey:@"photo"] != [NSNull null]) {
                        house.thumbImageURLString = [infoDict objectForKey:@"photo"];
                    }
                } else {
                    if ([infoDict objectForKey:@"photo"] && [infoDict objectForKey:@"photo"] != [NSNull null]) {
                        house.thumbImageURLString = [infoDict objectForKey:@"photo"];
                    }
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    house.title = [infoDict objectForKey:@"title"];
                    
                    
                    
                }
                if ([infoDict objectForKey:@"apartment"] && [infoDict objectForKey:@"apartment"] != [NSNull null]) {
                    house.houseTypeTitle = [infoDict objectForKey:@"apartment"];
                    
                    
                    
                }
                if ([infoDict objectForKey:@"price"] && [infoDict objectForKey:@"price"] != [NSNull null]) {
                    house.price = [infoDict objectForKey:@"price"];
                }
                if ([infoDict objectForKey:@"type"]) {
                    
                    house.houseType = [infoDict objectForKey:@"type"];
                    
                }
                if ([infoDict objectForKey:@"houseId"]) {
                    
                    house.houseID = [infoDict objectForKey:@"houseId"];
                    
                }
                
                [houseArray addObject:house];
            }
            return houseArray;
        }
        
        return  nil;
    }];
    
    
    return  result;
    
    
}

//添加联系记录
+ (Result*)addContactList:(int)userId infomationId:(int)ID
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSNumber numberWithInt:userId] stringValue] forKey:@"userId"];
    [params setObject:[[NSNumber numberWithInt:ID] stringValue] forKey:@"id"];
    NSLog(@"params %@", params);
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"addContact.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        
        
        return  nil;
    }];
    
    
    return  result;
    
}


//删除联系记录
+ (Result*)deleteContactList:(NSString*)userId houseId:(int)houseId
{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    [params setObject:userId forKey:@"userId"];
    [params setObject:[[ NSNumber numberWithInt:houseId] stringValue] forKey:@"id"];
    
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"deleteContact.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        return  nil;
    }];
    
    
    return  result;

 

}

//获取我刊登的房子的列表
+ (Result*)getMyPostHouseList:(int)userId offset:(int)offset length:(int)length
                         type:(NSString*)type isReleased:(int)isReleased
{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    [params setObject:[[NSNumber numberWithInt:userId] stringValue] forKey:@"userId"];
    [params setObject:[[NSNumber numberWithInt:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInt:length] stringValue] forKey:@"length"];
    [params setObject:type forKey:@"type"];
    [params setObject:[[NSNumber numberWithInt:isReleased] stringValue] forKey:@"isReleased"];
    NSLog(@"params %@", params);
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"myHouseList.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        NSLog(@"responseObject =  %@",responseObject);
        
        if ([responseObject objectForKey:@"list"]) {
            
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *houseArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                House *house = [[House alloc] init];
                
                if ([infoDict objectForKey:@"id"]) {
                    house.houseID = [infoDict objectForKey:@"id"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    if ([infoDict objectForKey:@"photo"] && [infoDict objectForKey:@"photo"] != [NSNull null]) {
                        house.thumbImageURLString = [infoDict objectForKey:@"photo"];
                    }
                    
                    
                    
                } else {
                    if ([infoDict objectForKey:@"photo"] && [infoDict objectForKey:@"photo"] != [NSNull null]) {
                        house.thumbImageURLString = [infoDict objectForKey:@"photo"];
                    }

                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    house.title = [infoDict objectForKey:@"title"];
                    
                    NSLog(@" = %@",[infoDict objectForKey:@"title"]);

                }
                if ([infoDict objectForKey:@"apartment"] && [infoDict objectForKey:@"apartment"] != [NSNull null]) {
                    house.houseTypeTitle = [infoDict objectForKey:@"apartment"];
                    
                    NSLog(@" = %@",[infoDict objectForKey:@"apartment"]);

                }
                if ([infoDict objectForKey:@"price"] && [infoDict objectForKey:@"price"] != [NSNull null]) {
                    house.price = [infoDict objectForKey:@"price"];
                    
                    NSLog(@" = %@",[infoDict objectForKey:@"price"]);
 
                    
                }
                
                [houseArray addObject:house];
            }
            return houseArray;
        }
        
        return  nil;
    }];
    
    
    return  result;
    
}

//刊登出租
+ (Result*)postRentHouse:(int)userId houseId:(NSString*)houseId title:(NSString *)title projectId:(int)projectId price:(NSString *)price areaId:(int)areaId apartmentId:(int)apartmentId building:(NSString *)building level:(NSString *)level proportion:(NSString *)proportion decorationYear:(NSString *)decorationYear decorationId:(int)decorationId rentYear:(NSNumber*)rentYear forwardId:(int)forwardId facilities:(NSArray *)facilities times:(NSDate *)times
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    

    [params setObject:[[NSNumber numberWithInt:userId] stringValue] forKey:@"userId"];
    [params setObject:houseId forKey:@"houseId"];

    [params setObject:title forKey:@"title"];
    [params setObject:[[NSNumber numberWithInt:projectId] stringValue] forKey:@"projectId"];
    [params setObject:price forKey:@"price"];
    [params setObject:[[NSNumber numberWithInt:areaId] stringValue] forKey:@"areaId"];
    [params setObject:[[NSNumber numberWithInt:apartmentId] stringValue] forKey:@"apartmentId"];
    [params setObject:building forKey:@"building"];
    [params setObject:level forKey:@"level"];
    [params setObject:proportion forKey:@"proportion"];
    [params setObject:decorationYear forKey:@"decorationYear"];
    [params setObject:[[NSNumber numberWithInt:decorationId] stringValue] forKey:@"decorationId"];
    [params setObject:[rentYear stringValue] forKey:@"rentYearId"];
    [params setObject:[[NSNumber numberWithInt:forwardId] stringValue] forKey:@"forwardId"];
    if ([facilities count] <= 0) {
        [params setObject:@"" forKey:@"facilities"];
    } else {
        [params setObject:[facilities componentsJoinedByString:@","] forKey:@"facilities"];
    }
//    [params setObject:times forKey:@"times"];
    [params setObject:[[NSString alloc] initWithFormat:@"%i", (NSUInteger)[times timeIntervalSince1970]] forKey:@"times"];
    NSLog(@"params %@", params);
    
    NSLog(@"time =  %@",[[NSString alloc] initWithFormat:@"%i", (NSUInteger)[times timeIntervalSince1970] ]);
    
    NSLog(@"params %@", params);

    
    WebAPI* webAPI = [[WebAPI alloc] initWithMethod:@"addRent.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        
        return  nil;
    }];
    
    
    return  result;
    
}

//刊登出售
+ (Result*)postSellHouse:(int)userId houseId:(NSString*)houseId
                   title:(NSString*)title projectId:(int)projectId
                   price:(NSString*)price areaId:(int)areaId apartmentId:(int)apartmentId
                building:(NSString*)building level:(NSString*)level proportion:(NSString*)proportion
          decorationYear:(NSString*)decorationYear decorationId:(int)decorationId rentYear:(NSString*)rentYear forwardId:(int)forwardId
              facilities:(NSArray*)facilities  purchaseYear:(NSString*)purchaseYear times:(NSDate*)times
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    
    [params setObject:[[NSNumber numberWithInt:userId] stringValue] forKey:@"userId"];
    [params setObject:houseId forKey:@"houseId"];

    [params setObject:title forKey:@"title"];
    [params setObject:[[NSNumber numberWithInt:projectId] stringValue] forKey:@"projectId"];
    [params setObject:price forKey:@"price"];
    [params setObject:[[NSNumber numberWithInt:areaId] stringValue] forKey:@"areaId"];
    [params setObject:[[NSNumber numberWithInt:apartmentId] stringValue] forKey:@"apartmentId"];
    [params setObject:building forKey:@"building"];
    [params setObject:level forKey:@"level"];
    [params setObject:proportion forKey:@"proportion"];
    [params setObject:decorationYear forKey:@"decorationYear"];
    [params setObject:[[NSNumber numberWithInt:decorationId] stringValue] forKey:@"decorationId"];
    [params setObject:rentYear forKey:@"rentYear"];
    [params setObject:[[NSNumber numberWithInt:forwardId] stringValue] forKey:@"forwardId"];
    //    [params setObject:facilities forKey:@"facilities"];
    if ([facilities count] <= 0) {
        [params setObject:@"" forKey:@"facilities"];
    } else {
        [params setObject:[facilities componentsJoinedByString:@","] forKey:@"facilities"];
    }
    //    [params setObject:times forKey:@"times"];
    [params setObject:[[NSString alloc] initWithFormat:@"%i", (NSUInteger)[times timeIntervalSince1970]] forKey:@"times"];
    NSLog(@"params %@", params);

    
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"addOversell.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        
        return  nil;
    }];
    
    
    return  result;
    
    
}

//取消刊登的房子既下架
+ (Result*)cancelReleaseHouse:(int)houseId isRelease:(int)isRelease
{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSNumber numberWithInt:houseId] stringValue] forKey:@"houseId"];
    [params setObject:[[NSNumber numberWithInt:isRelease] stringValue] forKey:@"isRelease"];

    NSLog(@"params %@", params);
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"setRelease.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        
        
        return  nil;
    }];
    
    
    return  result;
}
//修改发布房源的信息
+ (Result*)updateRentHouseInfomation:(int)userId houseId:(int)houseId
{


    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSNumber numberWithInt:houseId] stringValue] forKey:@"houseId"];
    [params setObject:[[NSNumber numberWithInt:userId] stringValue] forKey:@"userId"];

    NSLog(@"params %@", params);
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"editRent.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {

        NSLog(@"responseObject =  %@",responseObject);
        
         if ([responseObject objectForKey:@"Detail"]) {
            
        NSDictionary* currentDic = [responseObject objectForKey:@"Detail"];
            
            
           
                House* house = [[House alloc]init];
                
                if ([currentDic objectForKey:@"apartment"]) {
                    
                    NSLog(@"%@",[currentDic objectForKey:@"apartment"]);
                    
                    house.projectTitle = [currentDic objectForKey:@"apartment"];
                    
                }
                
                if ([currentDic objectForKey:@"areaName"]) {
                    
                    NSLog(@"%@",[currentDic objectForKey:@"areaName"]);

                    house.areaNameString = [currentDic objectForKey:@"areaName"];
                    
                }
                if ([currentDic objectForKey:@"building"]) {
                    
                    house.building = [currentDic objectForKey:@"building"];
                    
                }
                
                if ([currentDic objectForKey:@"level"]) {
                    
                    house.level = [currentDic objectForKey:@"level"];
                    
                }
                if ([currentDic objectForKey:@"forward"]) {
                    
                    house.forward = [currentDic objectForKey:@"forward"];
                    
                }
                if ([currentDic objectForKey:@"price"]) {
                    
                    house.price = [currentDic objectForKey:@"price"];
                    
                }
                if ([currentDic objectForKey:@"decoration"]) {
                    
                    house.decoration = [currentDic objectForKey:@"decoration"];
                    
                }
                if ([currentDic objectForKey:@"decorationYear"]) {
                    
                    house.decorationYear = [currentDic objectForKey:@"decorationYear"];
                    
                }
                if ([currentDic objectForKey:@"proportion"]) {
                    
                    house.proportion = [currentDic objectForKey:@"proportion"];
                    
                }
                if ([currentDic objectForKey:@"rentYear"]) {
                    
                    house.rentYear = [currentDic objectForKey:@"rentYear"];
                    
                    NSLog(@"%@",[currentDic objectForKey:@"rentYear"]);

                }
                if ([currentDic objectForKey:@"facilities"]) {
                    
                    house.facilityArray = [currentDic objectForKey:@"facilities"];
                    
                    NSLog(@"%@",[currentDic objectForKey:@"facilities"]);

                    
                }
                if ([currentDic objectForKey:@"projectName"]) {
                    
                    house.areaTitle = [currentDic objectForKey:@"projectName"];
                    
                    NSLog(@"%@",[currentDic objectForKey:@"projectName"]);
  
                }
                
               
                return house;
                
            }
            
            
            return  nil;
    }];
    
    
    return  result;
}

//上传图片
+ (Result *)uploadImage:(HouseMessageType)houseMessageType imageFieldName:(NSString *)imageFieldName image:(UIImage *)image uploadDate:(NSDate *)uploadDate progressBlock:(void (^)(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progressBlock
{
  
    NSLog(@"imageFieldName = %@",imageFieldName);
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (houseMessageType == HouseMessageTypeRent) {
        [params setObject:@"rent" forKey:@"type"];
    } else if (houseMessageType == HouseMessageTypeSell) {
        [params setObject:@"oversell" forKey:@"type"];
    }
    [params setObject:[[NSString alloc] initWithFormat:@"%i", (NSUInteger)[uploadDate timeIntervalSince1970]] forKey:@"times"];
    NSLog(@"params %@", params);
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"uploadImage.html" params:params];
    
    Result *result = [webAPI postWithImageFieldName:@"photoFileName" image:image progressBlock:^(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
        progressBlock(bytesWritten, totalBytesWritten, totalBytesExpectedToWrite);
    } successBlock:^id(id responseObject) {
        HouseImage* houseImage = [[HouseImage alloc]init];
        if (responseObject) {
            houseImage.houseImageID = [responseObject objectForKey:@"houseImageId"];
        }
        
        return houseImage;
    }];
    return result;
}
//删除图片
+ (Result*)deleteImage:(NSString*)houseImageId
{

    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:houseImageId forKey:@"houseImageId"];

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"deleteGalleryImage.html" params:params];
    
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        
        NSLog(@"%@",responseObject);
        
         return nil;
 
    }];
    
    return result;

}
//上架
+ (Result*)soldOnHouse:(int)houseId isRelease:(int)isRelease
{


    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:[[NSNumber numberWithInt:houseId] stringValue] forKey:@"houseId"];
    [params setObject:[[NSNumber numberWithInt:isRelease] stringValue] forKey:@"isRelease"];

    
    NSLog(@"params %@", params);
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"setRelease.html" params:params];
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
    
    NSLog(@"responseObject =  %@",responseObject);
        
        
        return  nil;
        
    }];
  
    
    return  result;
}
//搜索房源
+(Result*)searchHouse:(NSString*)keyword houseType:(NSString*)houseType
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:keyword forKey:@"keyword"];
    [params setObject:houseType forKey:@"type"];

    NSLog(@"params %@", params);
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"search.html" params:params];
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject =  %@",responseObject);
        
        if ([responseObject objectForKey:@"list"])
        {
            
            NSDictionary* currentDic= [responseObject objectForKey:@"list"];
            NSMutableArray* houseArray = [NSMutableArray array];
            for (NSDictionary* dic in currentDic)
            {
            
                House* house = [[House alloc]init];
                
                if ([dic objectForKey:@"id"]) {
                    
                    house.houseID = [dic objectForKey:@"id"];
                }
                if ([dic objectForKey:@"sn"]) {
                    
                    house.houseIdentifier = [dic objectForKey:@"sn"];
                }
                if ([dic objectForKey:@"projectName"]) {
                                      
                    
                    house.title = [dic objectForKey:@"projectName"];
                }
                
                [houseArray addObject:house];
                
            }
            
            return houseArray;
            
        }
        
           return  nil;
        
    }];
    
     return  result;

}
//获取会员信息
+ (Result*)memberInfomation:(NSString*)memberId
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:memberId forKey:@"memberId"];
    
    NSLog(@"params %@", params);
    
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"getMemberInfo.html" params:params];
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
    
        
        NSLog(@"responseObject = %@",responseObject);
        Member* member = [Member shareMember];

        if ([responseObject objectForKey:@"Detail"]) {
            
            NSDictionary* dic = [responseObject objectForKey:@"Detail"];
            
            
            if ([dic objectForKey:@"dateType"]) {
                
                member.loginAppTime = [dic objectForKey:@"dateType"];
                
            }
            if ([dic objectForKey:@"sex"]) {
                
                member.sexString = [dic objectForKey:@"sex"];
                
            }
            if ([dic objectForKey:@"username"]) {
                
                member.loginUsername = [dic objectForKey:@"username"];
            }
            if ([dic objectForKey:@"name"]) {
                
                member.name = [dic objectForKey:@"name"];
            }
            
            
        }
        
        return member;
        
        
    }];
    
    return result;
    

}

@end

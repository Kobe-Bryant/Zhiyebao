   //
//  House.m
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-14.
//
//

#import "House.h"
#import "WebAPI.h"

#define HouseIdentifier @"houseIdentifier"
#define HouseId @"HouseId"
#define HouseTitle @"houseTitle"

@implementation House

- (void)encodeWithCoder:(NSCoder *)aCoder
{
  
    [aCoder encodeObject:self.houseIdentifier forKey:HouseIdentifier];
    [aCoder encodeObject:self.title forKey:HouseTitle];
    [aCoder encodeObject:self.houseID forKey:HouseId];
    
    
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        
        
        self.houseIdentifier = [aDecoder decodeObjectForKey:HouseIdentifier];
        self.title = [aDecoder decodeObjectForKey:HouseTitle];
        self.houseID = [aDecoder decodeObjectForKey:HouseId];
        
    }

 
    return self;
    
 
}

+ (Result *)requestListWithMessageType:(HouseMessageType)houseMessageType isRecommend:(BOOL)isRecommend areaIDArray:(NSArray *)areaIDArray houseTypeIDArray:(NSArray *)houseTypeIDArray rentPriceIDArray:(NSArray *)rentPriceIDArray proportionIDArray:(NSArray *)proportionIDArray offset:(NSInteger)offset limit:(NSInteger)limit
{
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (houseMessageType == HouseMessageTypeRent) {
        [params setObject:@"rent" forKey:@"type"];
    } else if (houseMessageType == HouseMessageTypeSell) {
        [params setObject:@"oversell" forKey:@"type"];
    }
    if (isRecommend) {
        [params setObject:@"1" forKey:@"isRecommend"];
    } else {
        [params setObject:@"-1" forKey:@"isRecommend"];
    }
    if (areaIDArray != nil && [areaIDArray count] > 0) {
        [params setObject:[areaIDArray componentsJoinedByString:@","] forKey:@"areaId"];
    } else {
        [params setObject:@"" forKey:@"areaId"];
    }
    if (houseTypeIDArray != nil && [houseTypeIDArray count] > 0) {
        [params setObject:[houseTypeIDArray componentsJoinedByString:@","] forKey:@"apartmentId"];
    } else {
        [params setObject:@"" forKey:@"apartmentId"];
    }
    if (rentPriceIDArray != nil && [rentPriceIDArray count] > 0) {
        [params setObject:[rentPriceIDArray componentsJoinedByString:@","] forKey:@"priceId"];
    } else {
        [params setObject:@"" forKey:@"priceId"];
    }
    if (proportionIDArray != nil && [proportionIDArray count] > 0) {
        [params setObject:[proportionIDArray componentsJoinedByString:@","] forKey:@"proportionId"];
    } else {
        [params setObject:@"" forKey:@"proportionId"];
    }

    [params setObject:[[NSNumber numberWithInteger:offset] stringValue] forKey:@"offset"];
    [params setObject:[[NSNumber numberWithInteger:limit] stringValue] forKey:@"length"];
    NSLog(@"params %@", params);

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getHouseList.html" params:params];
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        
        
      NSLog(@"responseObject 地产 ＝  %@", responseObject);
        
        if ([responseObject objectForKey:@"list"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"list"];
            NSMutableArray *houseArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                
                NSLog(@"dic = %@",infoDict);
                
                House *house = [[House alloc] init];
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    house.houseID = [infoDict objectForKey:@"id"];
                }
                if ([[UIScreen mainScreen] scale] == 2.0) {
                    if ([infoDict objectForKey:@"photoX2"] && [infoDict objectForKey:@"photoX2"] != [NSNull null]) {
                        house.thumbImageURLString = [infoDict objectForKey:@"photoX2"];
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
                
                [houseArray addObject:house];
            }
            return houseArray;
        }
        
        return [[NSArray alloc] init];
    }];
    
    return result;
}

+ (Result *)requestOneWithHouseID:(NSString *)houseID userID:(NSString *)userID
{
    
    return [self requestOneWithHouseID:houseID userID:userID flag:1];
    
    
}

+ (Result *)requestOneWithHouseID:(NSString *)houseID userID:(NSString *)userID flag:(BOOL)flag
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    [params setObject:houseID forKey:@"id"];
    if (userID == nil) {
        [params setObject:@"" forKey:@"userId"];
    } else {
        [params setObject:userID forKey:@"userId"];
    }
    [params setObject:(flag ? @"1" : @"0") forKey:@"flag"];
    

    NSLog(@"params %@", params);

    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getHouseDetail.html" params:params];
    
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        
        
        NSLog(@"responseObject %@", responseObject);
        if ([responseObject objectForKey:@"Detail"]) {
            House *house = [[House alloc] init];
            NSDictionary *infoDict = [responseObject objectForKey:@"Detail"];
            if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                house.houseID = [infoDict objectForKey:@"id"];
            }
            if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                house.title = [infoDict objectForKey:@"title"];
            }
            if ([infoDict objectForKey:@"price"] && [infoDict objectForKey:@"price"] != [NSNull null]) {
                house.price = [infoDict objectForKey:@"price"];
            }
            if ([infoDict objectForKey:@"areaName"] && [infoDict objectForKey:@"areaName"] != [NSNull null]) {
                house.areaTitle = [infoDict objectForKey:@"areaName"];
            }
            if ([infoDict objectForKey:@"projectName"] && [infoDict objectForKey:@"projectName"] != [NSNull null]) {
                house.projectTitle = [infoDict objectForKey:@"projectName"];
            }
            if ([infoDict objectForKey:@"apartment"] && [infoDict objectForKey:@"apartment"] != [NSNull null]) {
                house.houseTypeTitle = [infoDict objectForKey:@"apartment"];
            }
            if ([infoDict objectForKey:@"postTime"] && [infoDict objectForKey:@"postTime"] != [NSNull null]) {
                house.releaseDateString = [infoDict objectForKey:@"postTime"];
            }
            if ([infoDict objectForKey:@"building"] && [infoDict objectForKey:@"building"] != [NSNull null]) {
                house.building = [infoDict objectForKey:@"building"];
            }
            if ([infoDict objectForKey:@"proportion"] && [infoDict objectForKey:@"proportion"] != [NSNull null]) {
                house.proportion = [infoDict objectForKey:@"proportion"];
            }
            if ([infoDict objectForKey:@"level"] && [infoDict objectForKey:@"level"] != [NSNull null]) {
                house.level = [infoDict objectForKey:@"level"];
            }
            if ([infoDict objectForKey:@"decorationYear"] && [infoDict objectForKey:@"decorationYear"] != [NSNull null]) {
                house.decorationYear = [infoDict objectForKey:@"decorationYear"];
                
                NSLog(@"house = %@",house.decorationYear);
                
            }
            if ([infoDict objectForKey:@"decoration"] && [infoDict objectForKey:@"decoration"] != [NSNull null]) {
                house.decoration = [infoDict objectForKey:@"decoration"];
            }
            if ([infoDict objectForKey:@"forward"] && [infoDict objectForKey:@"forward"] != [NSNull null]) {
                house.forward = [infoDict objectForKey:@"forward"];
            }
            if ([infoDict objectForKey:@"rentYear"] && [infoDict objectForKey:@"rentYear"] != [NSNull null]) {
                house.rentYear = [infoDict objectForKey:@"rentYear"];
                
                NSLog(@"%@",house.rentYear);
            }
            if ([infoDict objectForKey:@"sn"]) {
                
                house.houseIdentifier = [infoDict objectForKey:@"sn"];
                
            }
            if ([infoDict objectForKey:@"facilities"] && [infoDict objectForKey:@"facilities"] != [NSNull null]) {
                NSMutableArray *facilityArray = [[NSMutableArray alloc] init];
                NSDictionary *facilityListDict = [infoDict objectForKey:@"facilities"];
                for (NSDictionary *facilityDict in facilityListDict) {
                    Facility *facility = [[Facility alloc] init];
                    if ([facilityDict objectForKey:@"id"] && [facilityDict objectForKey:@"id"] != [NSNull null]) {
                        facility.facilityID = [facilityDict objectForKey:@"id"];
                    }
                    if ([facilityDict objectForKey:@"title"] && [facilityDict objectForKey:@"title"] != [NSNull null]) {
                        facility.title = [facilityDict objectForKey:@"title"];
                    }
                    [facilityArray addObject:facility];
                }
                house.facilityArray = [[NSArray alloc] initWithArray:facilityArray];
            }
            if ([infoDict objectForKey:@"agencyPhone"] && [infoDict objectForKey:@"agencyPhone"] != [NSNull null]) {
                house.contact = [infoDict objectForKey:@"agencyPhone"];
            }
            if ([infoDict objectForKey:@"ownerPhone"] && [infoDict objectForKey:@"ownerPhone"] != [NSNull null]) {
                house.ownerPhone = [infoDict objectForKey:@"ownerPhone"];
            }
            if ([infoDict objectForKey:@"isCanViewPhone"] && [infoDict objectForKey:@"isCanViewPhone"] != [NSNull null]) {
                house.canViewPhone = [[infoDict objectForKey:@"isCanViewPhone"] boolValue];
            }
            if ([infoDict objectForKey:@"type"] && [infoDict objectForKey:@"type"] != [NSNull null]) {
                if ([[infoDict objectForKey:@"type"] isEqualToString:@"rent"]) {
                    house.houseMessageType = HouseMessageTypeRent;
                } else if ([[infoDict objectForKey:@"type"] isEqualToString:@"sell"]) {
                    house.houseMessageType = HouseMessageTypeSell;
                }
            }
            
            if ([infoDict objectForKey:@"galleryList"]) {
                NSDictionary *galleryListDict = [infoDict objectForKey:@"galleryList"];
                NSMutableArray *houseImageArray = [[NSMutableArray alloc] init];
                for (NSDictionary *galleryDict in galleryListDict) {
                    HouseImage *houseImage = [[HouseImage alloc] init];
                    if ([galleryDict objectForKey:@"id"] && [galleryDict objectForKey:@"rentYear"] != [NSNull null]) {
                        houseImage.houseImageID = [galleryDict objectForKey:@"id"];
                    }
                    if ([[UIScreen mainScreen] scale] == 2.0) {
                        if ([galleryDict objectForKey:@"smallPhotoX2"] && [galleryDict objectForKey:@"smallPhotoX2"] != [NSNull null]) {
                            houseImage.thumbImageURLString = [galleryDict objectForKey:@"smallPhotoX2"];
                        }
                    } else {
                        if ([galleryDict objectForKey:@"smallPhoto"] && [galleryDict objectForKey:@"smallPhoto"] != [NSNull null]) {
                            houseImage.thumbImageURLString = [galleryDict objectForKey:@"smallPhoto"];
                        }
                    }
                    if ([[UIScreen mainScreen] scale] == 2.0) {
                        if ([galleryDict objectForKey:@"photoX2"] && [galleryDict objectForKey:@"photoX2"] != [NSNull null]) {
                            houseImage.largeImageURLString = [galleryDict objectForKey:@"photoX2"];
                        }
                    } else {
                        if ([galleryDict objectForKey:@"photo"] && [galleryDict objectForKey:@"photo"] != [NSNull null]) {
                            houseImage.largeImageURLString = [galleryDict objectForKey:@"photo"];
                        }
                    }
                    if ([galleryDict objectForKey:@"title"] && [galleryDict objectForKey:@"title"] != [NSNull null]) {
                        houseImage.title = [galleryDict objectForKey:@"title"];
                    }
                    [houseImageArray addObject:houseImage];
                }
                house.houseImageArray = [[NSArray alloc] initWithArray:houseImageArray];
            }
            
            return house;
        }
        
        return nil;
    }];
    
    return result;
}


@end

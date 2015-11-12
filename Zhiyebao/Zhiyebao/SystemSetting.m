//
//  SystemSetting.m
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-14.
//
//

#import "SystemSetting.h"
#import "WebAPI.h"

@implementation SystemSetting

+ (Result *)request
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    WebAPI *webAPI = [[WebAPI alloc] initWithMethod:@"getSysSetting.html" params:params];
    
    Result *result = [webAPI postWithCache:^id(id responseObject) {
        
        NSLog(@"responseObject %@", responseObject);
        
        NSMutableDictionary *returnDict = [[NSMutableDictionary alloc] init];
        
        if ([responseObject objectForKey:@"areas"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"areas"];
            NSMutableArray *areaArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Area *area = [[Area alloc] init];
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    area.areaID = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    area.title = [infoDict objectForKey:@"title"];
                    NSLog(@"area.title =  %@",area.title);
                    
                }
                
                [areaArray addObject:area];
            }

            [returnDict setValue:areaArray forKey:AREA_KEY];
        }
        if ([responseObject objectForKey:@"apartments"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"apartments"];
            NSMutableArray *houseTypeArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                HouseType *houseType = [[HouseType alloc] init];
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    houseType.houseTypeID = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    houseType.title = [infoDict objectForKey:@"title"];
                    NSLog(@"houseType.title =  %@",houseType.title);
                    
                    
                }
                
                [houseTypeArray addObject:houseType];
            }
            
            [returnDict setValue:houseTypeArray forKey:HOUSE_TYPE_KEY];
        }
        if ([responseObject objectForKey:@"rent_price"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"rent_price"];
            NSMutableArray *rentPriceArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                RentPrice *rentPrice = [[RentPrice alloc] init];
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    rentPrice.rentPriceID = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    rentPrice.title = [infoDict objectForKey:@"title"];
                }
                
                [rentPriceArray addObject:rentPrice];
            }
            
            [returnDict setValue:rentPriceArray forKey:RENT_PRICE_KEY];
        }
        if ([responseObject objectForKey:@"ovsersell_price"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"ovsersell_price"];
            NSMutableArray *sellPriceArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                SellPrice *sellPrice = [[SellPrice alloc] init];
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    sellPrice.sellPriceID = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    sellPrice.title = [infoDict objectForKey:@"title"];
                }
                
                [sellPriceArray addObject:sellPrice];
            }
            
            [returnDict setValue:sellPriceArray forKey:SELL_PRICE_KEY];
        }
        if ([responseObject objectForKey:@"proportion"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"proportion"];
            NSMutableArray *proportionArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Proportion *proportion = [[Proportion alloc] init];
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    proportion.proportionID = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    proportion.title = [infoDict objectForKey:@"title"];
                    
                    NSLog(@"proportion.title =  %@",proportion.title);
                    
                }

                [proportionArray addObject:proportion];
            }
            
            [returnDict setValue:proportionArray forKey:PROPORTION_KEY];
        }
        
        if ([responseObject objectForKey:@"decorations"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"decorations"];
            NSMutableArray *decorationsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Decoration* decoration = [[Decoration alloc]init];
                
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    decoration.decorationId = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    decoration.title = [infoDict objectForKey:@"title"];
                    NSLog(@"%@",  decoration.title);
                }
                
                [decorationsArray addObject:decoration];
            }
            
            [returnDict setValue:decorationsArray forKey:DECORATION_KEY];
        }
        if ([responseObject objectForKey:@"forwards"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"forwards"];
            NSMutableArray *forwardsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {

                Forward* forward = [[Forward alloc]init];
                
                
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    forward.forwardsId = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    forward.title = [infoDict objectForKey:@"title"];
                }
                
                [forwardsArray addObject:forward];
            }
            
            [returnDict setValue:forwardsArray forKey:FORWARDS_KEY];
        }
        
        if ([responseObject objectForKey:@"projects"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"projects"];
            NSMutableArray *projectsArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                Project* project = [[Project alloc]init];
                
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    project.projectId = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    project.title = [infoDict objectForKey:@"title"];
                }
                
                [projectsArray addObject:project];
            }
            
            [returnDict setValue:projectsArray forKey:PROJECT_KEY];
        }
        
        if ([responseObject objectForKey:@"facilities"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"facilities"];
            NSMutableArray *facilityArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {

                Facility* facility = [[Facility alloc]init]
                ;
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    facility.facilityID = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    facility.title = [infoDict objectForKey:@"title"];
                }
                
                [facilityArray addObject:facility];
            }
            
            [returnDict setValue:facilityArray forKey:FACILITY];
        }
        
        
        if ([responseObject objectForKey:@"rentYears"]) {
            NSDictionary *listDict = [responseObject objectForKey:@"rentYears"];
            NSMutableArray *rentYearArray = [[NSMutableArray alloc] init];
            for (NSDictionary *infoDict in listDict) {
                
                RentYear* rentyear = [[RentYear alloc]init]
                ;
                if ([infoDict objectForKey:@"id"] && [infoDict objectForKey:@"id"] != [NSNull null]) {
                    rentyear.rentYearId = [infoDict objectForKey:@"id"];
                }
                if ([infoDict objectForKey:@"title"] && [infoDict objectForKey:@"title"] != [NSNull null]) {
                    rentyear.title = [infoDict objectForKey:@"title"];
                }
                
                [rentYearArray addObject:rentyear];
            }
            
            [returnDict setValue:rentYearArray forKey:RENTYEAR];
        }
        
        
        return returnDict;
        
    }];
    
    return result;
}

@end

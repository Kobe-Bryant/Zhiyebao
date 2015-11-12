//
//  SystemSetting.h
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-14.
//
//

#define AREA_KEY @"AREA"
#define HOUSE_TYPE_KEY @"HOUSE_TYPE"
#define RENT_PRICE_KEY @"RENT_PRICE"
#define SELL_PRICE_KEY @"SELL_PRICE"
#define PROPORTION_KEY @"PROPORTION_PRICE"
#define DECORATION_KEY @"DECORATION"
#define FORWARDS_KEY @"FORWARDS"
#define PROJECT_KEY @"PROJECT"
#define FACILITY @"FACILITY"
#define RENTYEAR @"RENTYEAR"
#define BUYYEAR @"BUYYEAR"

#import <Foundation/Foundation.h>
#import "Result.h"
#import "Area.h"
#import "HouseType.h"
#import "RentPrice.h"
#import "SellPrice.h"
#import "Proportion.h"
#import "Decoration.h"
#import "Project.h"
#import "Facility.h"
#import "Forward.h"
#import "RentYear.h"






@interface SystemSetting : NSObject

+ (Result *)request;

@end

//
//  House.h
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-14.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"
#import "HouseImage.h"
#import "Facility.h"

typedef enum : NSUInteger {
    HouseMessageTypeRent                          = 0,
    HouseMessageTypeSell                          = 1 << 0
} HouseMessageType;


@interface House : NSObject<NSCoding>


@property (nonatomic, strong) NSString *houseID;
@property (nonatomic, retain) NSString *thumbImageURLString;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *price;
@property (nonatomic, retain) NSNumber *areaID;
@property (nonatomic, retain) NSString *areaTitle;
@property (nonatomic, retain) NSString *projectTitle;
@property (nonatomic, retain) NSNumber *houseTypeID;
@property (nonatomic, strong) NSString *houseTypeTitle;
@property (nonatomic, retain) NSString *releaseDateString;
@property (nonatomic, retain) NSString *building;
@property (nonatomic, retain) NSString *proportion;
@property (nonatomic, retain) NSString *level;
@property (nonatomic, retain) NSString *decorationYear;
@property (nonatomic, retain) NSString *decoration;
@property (nonatomic, retain) NSString *forward;
@property (nonatomic, retain) NSString *rentYear;
@property (nonatomic, retain) NSArray *facilityArray;
@property (nonatomic, retain) NSString *contact;
@property (nonatomic, retain) NSString *ownerPhone;
@property (nonatomic, retain) NSArray *houseImageArray;
@property (nonatomic, retain) NSString* houseType;
@property(nonatomic,retain) NSString* areaNameString;
@property(nonatomic,retain) NSString* houseIdentifier;


@property (nonatomic) BOOL canViewPhone;
@property (nonatomic) HouseMessageType houseMessageType;
@property(nonatomic) BOOL isCollectHouseExsited;



- (void)encodeWithCoder:(NSCoder *)aCoder;
- (id)initWithCoder:(NSCoder *)aDecoder;



+ (Result *)requestListWithMessageType:(HouseMessageType)houseMessageType isRecommend:(BOOL)isRecommend areaIDArray:(NSArray *)areaIDArray houseTypeIDArray:(NSArray *)houseTypeIDArray rentPriceIDArray:(NSArray *)rentPriceIDArray proportionIDArray:(NSArray *)proportionIDArray offset:(NSInteger)offset limit:(NSInteger)limit;
+ (Result *)requestOneWithHouseID:(NSString *)houseID userID:(NSString *)userID;
+ (Result *)requestOneWithHouseID:(NSString *)houseID userID:(NSString *)userID flag:(BOOL)flag;


@end

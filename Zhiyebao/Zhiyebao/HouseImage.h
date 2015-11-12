//
//  HouseImage.h
//  Zhiyebao
//
//  Created by LaiZhaowu on 14-5-14.
//
//

#import <Foundation/Foundation.h>

@interface HouseImage : NSObject

@property(nonatomic, retain) NSString* houseImageID;
@property(nonatomic, retain) NSNumber* houseID;
@property(nonatomic, retain) NSString* thumbImageURLString;
@property(nonatomic, retain) NSString* largeImageURLString;
@property(nonatomic, retain) NSString* title;
@property(nonatomic,retain) NSString* lastLargeImageURLString;



@end

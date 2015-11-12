//
//  ManagerMember.h
//  Zhiyebao
//
//  Created by Apple on 14-5-16.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"
#import "House.h"


@interface ManagerMember : NSObject



//用户注册
+ (Result*)memberRegin:(NSString*)reginName reginPassword:(NSString*)password;

//用户登陆
+ (Result*)memberLogin:(NSString*)loginName loginPassword:(NSString*)password;

//获取会员信息
+ (Result*)memberInfomation:(NSString*)memberId;


//获取浏览记录
+ (Result*)getMyScanList:(NSString*)userId offset:(int)offset length:(int)length;

//添加浏览记录
+ (Result*)addScanHistoryList:(int)userId infomationId:(int)ID;

//删除浏览记录
+ (Result*)deleteScanHistoryList:(NSString*)userId houseID:(int)houseId;


//获取收藏信息列表
+ (Result*)getCollectHouseList:(int)userId offset:(int)offset length:(int)length;

//收藏房子
+ (Result*)collectHouse:(int)userId houseId:(int)ID;

//取消收藏房子
+ (Result*)cancelCollectHouse:(NSString*)userId houseId:(int)houseId;

//获取联系记录
+ (Result*)getMyContactList:(NSString*)userId offset:(int)offset length:(int)length;

//添加联系记录
+ (Result*)addContactList:(int)userId infomationId:(int)ID;

//删除联系记录
+ (Result*)deleteContactList:(NSString*)userId houseId:(int)houseId;


//获取我刊登的房子的列表
+ (Result*)getMyPostHouseList:(int)userId offset:(int)offset length:(int)length
                         type:(NSString*)type isReleased:(int)isReleased;

//获取会员收藏房子是否存在
+ (Result*)getIsCollectHouseExsited:(NSString*)loginName loginPassword:(NSString*)loginPassword
                            houseId:(int)houseId;



//刊登出租
+ (Result*)postRentHouse:(int)userId houseId:(NSString*)houseId title:(NSString *)title projectId:(int)projectId price:(NSString *)price areaId:(int)areaId apartmentId:(int)apartmentId building:(NSString *)building level:(NSString *)level proportion:(NSString *)proportion decorationYear:(NSString *)decorationYear decorationId:(int)decorationId rentYear:(NSNumber*)rentYear forwardId:(int)forwardId facilities:(NSArray *)facilities times:(NSDate *)times;
//刊登出售
+ (Result*)postSellHouse:(int)userId houseId:(NSString*)houseId
                   title:(NSString*)title projectId:(int)projectId
                   price:(NSString*)price areaId:(int)areaId apartmentId:(int)apartmentId
                building:(NSString*)building level:(NSString*)level proportion:(NSString*)proportion
          decorationYear:(NSString*)decorationYear decorationId:(int)decorationId rentYear:(NSString*)rentYear forwardId:(int)forwardId
              facilities:(NSArray*)facilities  purchaseYear:(NSString*)purchaseYear times:(NSDate*)times;


//下架
+ (Result*)cancelReleaseHouse:(int)houseId isRelease:(int)isRelease;


//上架
+ (Result*)soldOnHouse:(int)houseId isRelease:(int)isRelease;

//修改发布房源的信息
+ (Result*)updateRentHouseInfomation:(int)userId houseId:(int)houseId;


//上传图片
+ (Result *)uploadImage:(HouseMessageType)houseMessageType imageFieldName:(NSString *)imageFieldName image:(UIImage *)image uploadDate:(NSDate *)uploadDate progressBlock:(void (^)(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progressBlock;

//删除图片
+ (Result*)deleteImage:(NSString*)houseImageId;

//搜索房源
+(Result*)searchHouse:(NSString*)keyword houseType:(NSString*)houseType;


@end

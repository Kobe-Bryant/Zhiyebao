//
//  WebApi.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-25.
//



#import <Foundation/Foundation.h>
#import "Result.h"

@interface WebAPI : NSObject

@property (nonatomic, retain) NSString *method;
@property (nonatomic, retain) NSDictionary *params;

- (id)initWithMethod:(NSString *)method params:(NSDictionary *)params;
- (NSURL *)apiURL;
- (Result *)post:(id (^)(id responseObject))block;
- (Result *)postWithCache:(id (^)(id responseObject))block;
- (Result *)postWithImageFieldName:(NSString *)imageFieldName image:(UIImage *)image progressBlock:(void (^)(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progressBlock successBlock:(id (^)(id responseObject))successBlock;
@end

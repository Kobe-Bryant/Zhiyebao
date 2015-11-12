//
//  WebApi.m
//  HKGMap
//
//  Created by LaiZhaowu on 14-3-25.
//
//

#define API_URL @"WebAPIURL"
#define MIX_CODE @"gdhome"
#define SIGNATURE_KEY @"signature"
#define TIME_OUT 30.0
#import "PostViewController.h"

#import "WebApi.h"
#import "NSString+MD5.h"
#import "AFHTTPRequestOperationManager.h"

@implementation WebAPI

- (id)initWithMethod:(NSString *)method params:(NSDictionary *)params
{
    self = [super init];
    if (self) {
        self.method = method;
        self.params = params;
        return self;
    }
    return nil;
}

- (NSURL *)apiURL
{
    NSString *baseURLString = [[[NSBundle mainBundle] infoDictionary] objectForKey:API_URL];
    NSString *urlString = [NSString stringWithString:baseURLString];
    if ([baseURLString length] > 0 && [baseURLString hasSuffix:@"/"] == NO) {
        urlString = [urlString stringByAppendingString:@"/"];
    }
    urlString = [urlString stringByAppendingString:self.method];
    return [[NSURL alloc] initWithString:urlString];
}

- (NSString *)generateSignature:(NSDictionary *)params
{
    NSMutableArray *orderedKeys = [[NSMutableArray alloc] init];
    for (NSString *key in params) {
        [orderedKeys addObject:key];
    }
    [orderedKeys sortUsingSelector:@selector(compare:)];
    
    NSString *signature = [[NSString alloc] init];
    for (NSString *key in orderedKeys) {
        if (key != nil) {
            signature = [signature stringByAppendingString:key];
            signature = [signature stringByAppendingString:@"="];
            signature = [signature stringByAppendingString:[params objectForKey:key]];
        }
    }
    signature = [signature stringByAppendingString:MIX_CODE];
    
 //   NSString *encodeString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)signature, NULL, (CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
    
  //  return [[encodeString MD5String] lowercaseString];
    return @"test";
}

- (Result *)processReturnResponseObject:(NSDictionary *)responseObject
{
    NSDictionary *dict = [[NSDictionary alloc] initWithDictionary:responseObject];
    if ([dict objectForKey:@"status"]) {
        NSDictionary *currentDict = [dict objectForKey:@"status"];
        if ([currentDict objectForKey:@"code"]) {
            NSInteger code = [[currentDict objectForKey:@"code"] integerValue];
            if (code == 1) {
                return [[Result alloc] initWithSuccessData:dict];
            } else if ([currentDict objectForKey:@"message"]) {
                NSError *currentError = [[NSError alloc] initWithDomain:[[self apiURL] host] code:code userInfo:[[NSDictionary alloc] initWithObjectsAndKeys:[currentDict objectForKey:@"message"], NSLocalizedDescriptionKey, nil]];
                return [[Result alloc] initWithFailureError:currentError];
            }
        }
    }
    return nil;
}

- (Result *)processReturnData:(id)dataObject
{
    if ([dataObject isKindOfClass:[NSData class]]) {
        NSError *error;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:dataObject options:NSJSONReadingMutableContainers error:&error];
        if (error == nil) {
            return [self processReturnResponseObject:dict];
        } else {
            return [[Result alloc] initWithFailureError:error];
        }
    } else if ([dataObject isKindOfClass:[NSDictionary class]]) {
        return [self processReturnResponseObject:dataObject];
    }
    
    return nil;
}


- (Result *)post:(id (^)(id))block
{
    NSMutableDictionary *currentParams = [[NSMutableDictionary alloc] initWithDictionary:self.params];
    [currentParams setObject:[self generateSignature:self.params] forKey:SIGNATURE_KEY];
    
    
    __block Result *result = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    [[AFHTTPRequestOperationManager manager] POST:[[self apiURL] absoluteString] parameters:currentParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        Result *progressResult = [self processReturnData:responseObject];
        if (progressResult.isSuccess && block) {
            result = [[Result alloc] initWithSuccessData:block(progressResult.data)];
        } else {
            result = progressResult;
        }
        dispatch_semaphore_signal(semaphore);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        result = [[Result alloc] initWithFailureError:error];
        dispatch_semaphore_signal(semaphore);
    }];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;
}



- (Result *)postWithCache:(id (^)(id))block
{
    NSMutableDictionary *currentParams = [[NSMutableDictionary alloc] initWithDictionary:self.params];
    [currentParams setObject:[self generateSignature:self.params] forKey:SIGNATURE_KEY];
    
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:[[self apiURL] absoluteString] parameters:currentParams error:nil];
    request.cachePolicy = NSURLRequestReloadIgnoringCacheData;
    request.timeoutInterval = TIME_OUT;

    __block Result *result = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    if ([[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusNotReachable || [[AFNetworkReachabilityManager sharedManager] networkReachabilityStatus] == AFNetworkReachabilityStatusUnknown) {
        NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:request];
        if (cachedResponse != nil && cachedResponse.data != nil) {
            Result *progressResult = [self processReturnData:cachedResponse.data];
            if (block) {
                result = [[Result alloc] initWithSuccessData:block(progressResult.data)];
            } else {
                result = progressResult;
            }
            dispatch_semaphore_signal(semaphore);
        }
    }
    
    if (result == nil) {
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            Result *progressResult = [self processReturnData:responseObject];
            if (progressResult.isSuccess && block) {
                result = [[Result alloc] initWithSuccessData:block(progressResult.data)];
            } else {
                result = progressResult;
            }
            dispatch_semaphore_signal(semaphore);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            result = [[Result alloc] initWithFailureError:error];
            dispatch_semaphore_signal(semaphore);
        }];
        [operation start];
    }
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;
}




- (Result *)postWithImageFieldName:(NSString *)imageFieldName image:(UIImage *)image progressBlock:(void (^)(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite))progressBlock successBlock:(id (^)(id responseObject))successBlock
{
   
    
    
    NSMutableDictionary *currentParams = [[NSMutableDictionary alloc] initWithDictionary:self.params];
    [currentParams setObject:[self generateSignature:self.params] forKey:SIGNATURE_KEY];
    
    
    __block Result *result = nil;
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(0);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [AFHTTPRequestOperationManager manager].responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    NSLog(@"[AFHTTPRequestOperationManager manager].responseSerializer.acceptableContentTypes %@", [AFHTTPRequestOperationManager manager].responseSerializer.acceptableContentTypes);
    
    
    
 AFHTTPRequestOperation *operation =  [manager POST:[[self apiURL] absoluteString] parameters:currentParams constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFormData:UIImageJPEGRepresentation(image, 1.0)
                                    name:imageFieldName];
     
     } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"responseObject %@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        
        Result *progressResult = [self processReturnData:responseObject];
        if (progressResult.isSuccess && successBlock) {
            result = [[Result alloc] initWithSuccessData:successBlock(progressResult.data)];
        } else {
            result = progressResult;
        }
        dispatch_semaphore_signal(semaphore);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error %@", error);
        result = [[Result alloc] initWithFailureError:error];
        dispatch_semaphore_signal(semaphore);
    }];
    
    [operation setUploadProgressBlock:^(NSUInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {

        if (progressBlock) {
            progressBlock(bytesWritten, totalBytesExpectedToWrite, totalBytesExpectedToWrite);
        }
       
    }];
    [operation start];
    
    dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
    return result;

}

@end

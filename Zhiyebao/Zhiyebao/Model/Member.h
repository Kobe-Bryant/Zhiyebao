//
//  Member.h
//  Zhiyebao
//
//  Created by Apple on 14-5-16.
//
//

#import <Foundation/Foundation.h>
#import "Result.h"

@interface Member : NSObject

@property(nonatomic,retain) NSString* memberID;
@property (nonatomic, retain) NSString *loginUsername;
@property (nonatomic, retain) NSString *loginPassword;
@property (nonatomic, retain) NSString *mobile;
@property(nonatomic,retain) NSString* loginAppTime;
@property(nonatomic,retain) NSString* sexString;
@property(nonatomic,retain) NSString* name;



+ (Member*)shareMember;
- (BOOL)isLogined;

//重置密码
+ (Result *)resetPassword:(NSString*)memberId oldPassword:(NSString*)oldPassword
                                               newPassword:(NSString*)newPassword;

//修改个人信息
+ (Result *)modifyProfile:(NSString*)memberId name:(NSString*)name sex:(int)gender;



- (id)initWithSingle;



@end

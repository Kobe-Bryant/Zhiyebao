//
//  Member.m
//  Zhiyebao
//
//  Created by Apple on 14-5-16.
//
//

#import "Member.h"
#import "CustomMarcos.h"
#import "WebAPI.h"

@implementation Member

static Member *singleMember= nil;

+ (Member *)shareMember
{
    if (singleMember == nil) {
        
        
        singleMember = [[Member alloc]initWithSingle];
                
      
    }
    
    return singleMember;
}
- (id)initWithSingle
{

    self = [super init];
    
    if (self) {
        
    }
    return self;
    

}
- (BOOL)isLogined
{
    
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    singleMember.memberID = [userDefaults objectForKey:MEMBER_ID];
    singleMember.loginUsername = [userDefaults objectForKey:LOGIN_USER_NAME];
    singleMember.loginPassword = [userDefaults objectForKey:LOGIN_PASSWORD];
    return (singleMember.memberID != nil && singleMember.memberID > 0
            && singleMember.loginUsername != nil && [singleMember.loginUsername length] > 0
            && singleMember.loginPassword != nil && [singleMember.loginPassword length] > 0);
}

//重置密码
+ (Result *)resetPassword:(NSString*)memberId oldPassword:(NSString*)oldPassword
              newPassword:(NSString*)newPassword
{
    
    
    
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:oldPassword forKey:@"oldPassword"];
    [params setObject:newPassword forKey:@"newPassword"];
    [params setObject:memberId forKey:@"userId"];

    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"modifyPassword.html" params:params];
    
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        NSLog(@"responseObject =  %@",responseObject);
        
        return nil;
        
    }];
                      
    
    return result;
    
}

//修改个人信息
+ (Result *)modifyProfile:(NSString*)memberId name:(NSString*)name sex:(int)gender;
{


    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    
    [params setObject:name forKey:@"name"];
    [params setObject:[[NSNumber numberWithInt:gender] stringValue] forKey:@"sex"];
    [params setObject:memberId forKey:@"userId"];
    
    WebAPI* webAPI = [[WebAPI alloc]initWithMethod:@"modifyProfile.html" params:params];
    
    Result* result = [webAPI postWithCache:^id(id responseObject) {
        
        NSLog(@"responseObject =  %@",responseObject);
        
        return nil;
        
    }];
    
    
    return result;


}
@end

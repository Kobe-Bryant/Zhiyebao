//
//  NSString+Validator.h
//  HKGMap
//
//  Created by LaiZhaowu on 14-4-18.
//
//

#import <Foundation/Foundation.h>

@interface NSString(Validator)

- (BOOL)isNumeric;
- (BOOL)isEmail;
- (BOOL)isMobile;

@end

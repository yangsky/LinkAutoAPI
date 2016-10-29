//
//  Hmac.h
//  AutoLinQ
//
//  Created by WangErdong on 16/4/19.
//
//

#import <Foundation/Foundation.h>

@interface Hmac : NSObject

+ (NSString *)encrypt2HMAC:(NSString *)message key:(NSString *)key;

+ (NSString *)encrypt2HMAC:(Byte [])bytes withKey:(NSString *)key;

@end

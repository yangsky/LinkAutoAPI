#import <Foundation/Foundation.h>

@interface Des : NSObject

// Encrpty a String Object as DES algorithm
+ (NSString *) encrypt2DES:(NSString *)message key:(NSString *)key;

// Encrpty byte[] Object as DES algorithm.
+ (NSString *) encrypt2DES:(Byte [])bytes withKey:(NSString *)key;

// Decrpty a String as DES algorithm.
+ (NSString *) decrypt2DES:(NSString *)message key:(NSString *)key;

// Decrpty byte[] Object as DES algorithm.
+ (NSString *) decrypt2DES:(Byte [])bytes withKey:(NSString *)key;

@end
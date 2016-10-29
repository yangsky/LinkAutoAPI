//
//  Hmac.m
//  AutoLinQ
//
//  Created by WangErdong on 16/4/19.
//
//

#import "Hmac.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import "StringUitl.h"

@implementation Hmac

+ (NSString *)encrypt2HMAC:(NSString *)message key:(NSString *)key {
    
    const char *cKey  = [key cStringUsingEncoding:NSASCIIStringEncoding];
    const char *cData = [message cStringUsingEncoding:NSASCIIStringEncoding];
    
    //sha1
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, cKey, strlen(cKey), cData, strlen(cData), cHMAC);
    
    // base64
    /*
     NSData *HMAC = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
     NSString *hash = [HMAC base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
     */
    
    // to hex
    NSMutableString *hash = [[NSMutableString alloc] init];
    for (int i=0; i<CC_SHA1_DIGEST_LENGTH; i++) {
        [hash appendFormat:@"%02x", cHMAC[i]];
    }
    
    return hash;
}

+ (NSString *)encrypt2HMAC:(Byte [])bytes withKey:(NSString *)key {
    
    // bytes to string
    NSString *message = [StringUitl bytes2String:bytes];
    
    return [self encrypt2HMAC:message key:key];
}

@end

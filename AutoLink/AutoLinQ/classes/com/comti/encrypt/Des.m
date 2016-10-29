#import "Des.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonCryptor.h>
#import "StringUitl.h"

@implementation Des

+ (NSString *) encrypt2DES:(NSString *)message key:(NSString *)key {

    return [Des encrypt:message encryptOrDecrypt:kCCEncrypt key:key];
}

+ (NSString *) encrypt2DES:(Byte [])bytes withKey:(NSString *)key {
    
    // bytes to string
    NSString *message = [StringUitl bytes2String:bytes];
    
    return [Des encrypt:message encryptOrDecrypt:kCCEncrypt key:key];
}

+ (NSString *) decrypt2DES:(NSString *)message key:(NSString *)key {
    
    return [Des encrypt:message encryptOrDecrypt:kCCDecrypt key:key];
}

+ (NSString *) decrypt2DES:(Byte [])bytes withKey:(NSString *)key {
    
    // bytes to string
    NSString *message = [StringUitl bytes2String:bytes];
    
    return [Des encrypt:message encryptOrDecrypt:kCCDecrypt key:key];
}

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key {

    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt) {

        // string to byte
        NSData *decryptData = [self stringToByte:sText];
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    } else {

        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    // CCCrypt
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    NSString *initIv = key;
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    // CCCrypt
    ccStatus = CCCrypt(encryptOperation,
                       kCCAlgorithmDES,
                       kCCOptionPKCS7Padding,
                       vkey,
                       kCCKeySizeDES,
                       iv,
                       dataIn,
                       dataInLength,
                       (void *)dataOut,
                       dataOutAvailable,
                       &dataOutMoved);
    
    NSString *result = nil;
    
    if (encryptOperation == kCCDecrypt) {

        result = [[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding];
    } else {

        // to hex
        NSMutableString *hash = [[NSMutableString alloc] init];

        for (int i=0; i<dataOutAvailable; i++) {
            
            [hash appendFormat:@"%02x", dataOut[i]];
        }
        
        result = hash;
    }
    
    return result;
}

// string to byte
+ (NSData *)stringToByte:(NSString*)string {

    NSString *hexString=[[string uppercaseString] stringByReplacingOccurrencesOfString:@" " withString:@""];

    if ([hexString length]%2 != 0) {

        return nil;
    }

    Byte tempbyt[1]={0};
    NSMutableData* bytes=[NSMutableData data];

    for(int i=0;i<[hexString length];i++) {

        unichar hex_char1 = [hexString characterAtIndex:i];
        int int_ch1;
        
        if(hex_char1 >= '0' && hex_char1 <='9') {
            
            int_ch1 = (hex_char1-48)*16;
        } else if(hex_char1 >= 'A' && hex_char1 <='F') {
            
            int_ch1 = (hex_char1-55)*16;
        } else {
            
            return nil;
        }
        i++;
        
        unichar hex_char2 = [hexString characterAtIndex:i];
        int int_ch2;
        
        if(hex_char2 >= '0' && hex_char2 <='9') {
            
            int_ch2 = (hex_char2-48);
        } else if(hex_char2 >= 'A' && hex_char2 <='F') {
            
            int_ch2 = hex_char2-55;
        } else {
            
            return nil;
        }
        
        tempbyt[0] = int_ch1 + int_ch2;
        [bytes appendBytes:tempbyt length:1];
    }

    return bytes;
}

@end
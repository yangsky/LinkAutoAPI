//
//  desMethod.m
//  DES
//
//  Created by steven_yang on 16/4/2.
//  Copyright © 2016年 steven_yang. All rights reserved.
//

#import "EncryptionMethod.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonHMAC.h>
#import "GTMBase64.h"

@implementation EncryptionMethod

 //  Encrpty a String Object as DES algorithm
+ (NSString *)encryptWithMsg:(NSString *)sText Key:(NSString *)key
{
    //kCCEncrypt 
    return [self encrypt:sText encryptOrDecrypt:kCCEncrypt key:key];
}


//  Dencrpty a String Object as DES algorithm
+ (NSString *)decryptWithMsg:(NSString *)sText Key:(NSString *)key
{
    //kCCDecrypt
    return [self encrypt:sText encryptOrDecrypt:kCCDecrypt key:key];
}

+ (NSString *)encrypt:(NSString *)sText encryptOrDecrypt:(CCOperation)encryptOperation key:(NSString *)key
{
    const void *dataIn;
    size_t dataInLength;
    
    if (encryptOperation == kCCDecrypt)// transfered parameter is used for decrypt
    {
        //decode base64
        NSData *decryptData = [GTMBase64 decodeData:[sText dataUsingEncoding:NSUTF8StringEncoding]];//transfor to utf-8 and decode
        dataInLength = [decryptData length];
        dataIn = [decryptData bytes];
    }
    else  // transfered parameter is used for encrypt
    {
        NSData* encryptData = [sText dataUsingEncoding:NSUTF8StringEncoding];
        dataInLength = [encryptData length];
        dataIn = (const void *)[encryptData bytes];
    }
    
    /*
     DES encrypt ：encrypt it by function CCCrypt，and then encode by base64 , transmit it
     DES decrypt ：decode the received data by base64, and then get the orginal data by decrypt with function CCCrypt.
     */
    CCCryptorStatus ccStatus;
    uint8_t *dataOut = NULL;
    size_t dataOutAvailable = 0;
    size_t dataOutMoved = 0;
    
    dataOutAvailable = (dataInLength + kCCBlockSizeDES) & ~(kCCBlockSizeDES - 1);
    dataOut = malloc( dataOutAvailable * sizeof(uint8_t));
    memset((void *)dataOut, 0x0, dataOutAvailable);
    
    NSString *initIv = @"12345678";
    const void *vkey = (const void *) [key UTF8String];
    const void *iv = (const void *) [initIv UTF8String];
    
    // function CCCrypt
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
    
    if (encryptOperation == kCCDecrypt)
    {

        result = [[[NSString alloc] initWithData:[NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved] encoding:NSUTF8StringEncoding] autorelease];
    }
    else
    {

        NSData *data = [NSData dataWithBytes:(const void *)dataOut length:(NSUInteger)dataOutMoved];
        result = [GTMBase64 stringByEncodingData:data];
    }
    
    return result;
}

// Encrpty a String Object as HMAC-sha1 algorithm
+ (NSString *)encrypt2HMACWithMsg:(NSString *)message
{
    const char *key = [message cStringUsingEncoding:NSUTF8StringEncoding];
    const char *data = [self cStringUsingEncoding:NSUTF8StringEncoding];
    unsigned char cHMAC[CC_SHA1_DIGEST_LENGTH];
    CCHmac(kCCHmacAlgSHA1, key, strlen(key), data, strlen(data), cHMAC);
    NSData *resultData = [[NSData alloc] initWithBytes:cHMAC length:sizeof(cHMAC)];
    char *utf8;
    utf8 = (char *)[resultData bytes];
    NSMutableString *hex = [NSMutableString string];
    while ( *utf8 )
    {
        [hex appendFormat:@"%02X" , *utf8++ & 0x00FF];
    }
    return [NSString stringWithFormat:@"%@", hex];
}


@end

//
//  desMethod.h
//  DES
//
//  Created by steven_yang on 16/4/2.
//  Copyright © 2016年 steven_yang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncryptionMethod : NSObject


/**
 *  Encrpty a String Object as DES algorithm
 *
 *  @param a String Ojbect
 *  @param the key used for DES algorithm
 
 *
 */
+ (NSString *)encryptWithMsg:(NSString *)sText Key:(NSString *)key;//加密


/**
 *  Decrypt a String Object as DES algorithm
 *
 *  @param a String Ojbect
 *  @param the key used for DES algorithm
 
 *
 */
+ (NSString *)decryptWithMsg:(NSString *)sText Key:(NSString *)key;//解密


/**
 *  Encrpty a String Object as HMAC-sha1 algorithm
 *
 *  @param a String Ojbect
 *
 */
+ (NSString *)encrypt2HMACWithMsg:(NSString *)message;

@end

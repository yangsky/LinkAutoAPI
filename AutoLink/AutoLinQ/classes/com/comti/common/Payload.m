//
//  Payload.m
//  AutoLinQ
//
//  Created by WangErdong on 16/4/17.
//
//

#import "Payload.h"

@implementation Payload

+ (NSString *)generateCommomMsgWithFunid:(NSString *)funid pkgNum:(NSString *)pkgNum isEncryption:(NSString *)isEncryption  isCompress:(NSString *)isCompress data:(NSString *)data {
    
    Message *message = [[Message alloc] init];
    
    message.funcID = funid;
    message.pkgNum = pkgNum;
    message.isEncryption = isEncryption;
    message.isCompress = isCompress;
    message.data = data;
    
    return [message toJson];
}

@end

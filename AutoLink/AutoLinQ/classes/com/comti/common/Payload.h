//
//  Payload.h
//  AutoLinQ
//
//  Created by WangErdong on 16/4/17.
//
//

#import <Foundation/Foundation.h>
#import "Message.h"

@interface Payload : NSObject

+ (NSString *)generateCommomMsgWithFunid:(NSString *)funid pkgNum:(NSString *)pkgNum isEncryption:(NSString *)isEncryption  isCompress:(NSString *)isCompress data:(NSString *)data;

@end

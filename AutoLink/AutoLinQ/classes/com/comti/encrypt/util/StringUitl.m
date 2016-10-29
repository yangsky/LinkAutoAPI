//
//  StringUitl.m
//  AutoLinQ
//
//  Created by WangErdong on 16/4/19.
//
//

#import "StringUitl.h"

@implementation StringUitl

+ (NSString *)bytes2String:(Byte [])bytes {
    
    NSData *data = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return string;
}

@end

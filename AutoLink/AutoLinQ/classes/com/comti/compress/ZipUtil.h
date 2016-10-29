//
//  ZipUtil.h
//  AutoLinQ
//
//  Created by WangErdong on 16/4/20.
//
//

#import <Foundation/Foundation.h>

@interface ZipUtil : NSObject

// Compress byte arrays to zip format.
+ (NSData *)compresszip:(NSData *)data;

// Uncompress byte arrays as upzip format.
+ (NSData *)uncompresszip:(NSData *)data;

@end

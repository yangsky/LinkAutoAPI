//
//  ZipUtil.m
//  AutoLinQ
//
//  Created by WangErdong on 16/4/20.
//
//

#import "ZipUtil.h"
#import "GZIP.h"

@implementation ZipUtil

// Compress byte arrays to zip format.
+ (NSData *)compresszip:(NSData *)pUncompressedData {

    return [pUncompressedData gzippedData];
}

// Uncompress byte arrays as upzip format.
+ (NSData *)uncompresszip:(NSData *)compressedData {
    
    return [compressedData gunzippedData];
}

@end

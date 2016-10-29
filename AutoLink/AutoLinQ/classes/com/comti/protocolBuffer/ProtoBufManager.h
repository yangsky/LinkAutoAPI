//
//  ProtoBufManager.h
//  AutoLinQ
//
//  Created by com.conti on 16/4/17.
//  Copyright (c) 2016年 com.conti. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProtoBufManager : NSObject

/**
 *  output data to file
 *
 *  @param outputFile output file
 *  @param dict       data(For example, data from https request)
 */
- (void)output:(NSString *)outputFile withData:(NSDictionary *)dict;

/**
 *  read the .proto file
 *
 *  @param dataFile .proto file
 *
 *  @return The contents of the .proto file.(key-value pairs)
 */
- (NSDictionary *)read:(NSString *)dataFile;

+ (NSData *)dictionaryToData:(NSDictionary *)dict;
+ (NSDictionary *)dataToDictionary:(NSData *)data;

@end

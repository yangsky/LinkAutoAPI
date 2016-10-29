//
//  IndexGenerator.h
//  AutoLinQ
//
//  Created by WangErdong on 16/4/17.
//
//

#import <Foundation/Foundation.h>

@interface IndexGenerator : NSObject

+ (instancetype) sharedGenerator;

- (int)timeStampIndex:(NSString *)timeStamp;
@end

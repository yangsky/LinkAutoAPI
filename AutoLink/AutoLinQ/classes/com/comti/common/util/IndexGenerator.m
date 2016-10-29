//
//  IndexGenerator.m
//  AutoLinQ
//
//  Created by WangErdong on 16/4/17.
//
//

#import "IndexGenerator.h"

@interface IndexGenerator ()

@property (nonatomic, copy) NSString *currentTimeStamp;
@property (nonatomic, assign) int currentIndex;
@end

@implementation IndexGenerator

// 单例模式
+ (instancetype) sharedGenerator {
    
    static IndexGenerator *instance = nil;
    static dispatch_once_t predicate;

    dispatch_once(&predicate, ^{
        
        if (!instance) {
            
            instance = [[IndexGenerator alloc] init];
        }
    });
    
    return instance;
}

// 相同的时间戳，index加1
- (int)timeStampIndex:(NSString *)timeStamp {
    
    if ([timeStamp isEqualToString:[[IndexGenerator sharedGenerator] currentTimeStamp]]) {
        
        int currentIndex = [[IndexGenerator sharedGenerator] currentIndex];
        [[IndexGenerator sharedGenerator] setCurrentIndex:(currentIndex+1)];
    } else {
        
        [[IndexGenerator sharedGenerator] setCurrentTimeStamp:timeStamp];
        [[IndexGenerator sharedGenerator] setCurrentIndex:1];
    }
    
    return [[IndexGenerator sharedGenerator] currentIndex];
}

@end

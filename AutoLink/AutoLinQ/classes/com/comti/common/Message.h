//
//  Message.h
//  AutoLinQ
//
//  Created by WangErdong on 16/4/17.
//
//

#import <Foundation/Foundation.h>

@interface Message : NSObject

@property (nonatomic, copy) NSString *appID;
@property (nonatomic, copy) NSString *categoryID;
@property (nonatomic, copy) NSString *funcID;
@property (nonatomic, copy) NSString *appVersion;
@property (nonatomic, copy) NSString *timeStamp;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *pkgID;
@property (nonatomic, copy) NSString *pkgIndex;
@property (nonatomic, copy) NSString *pkgNum;
@property (nonatomic, copy) NSString *isEncryption;
@property (nonatomic, copy) NSString *isCompress;
@property (nonatomic, copy) NSString *data;

+ (Message *)messageWithDictionary:(NSDictionary *)dictionary;

- (NSString *)toJson;
@end
